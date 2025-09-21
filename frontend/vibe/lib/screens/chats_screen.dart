import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibe/generated/chat/chat.pbgrpc.dart';
import 'package:vibe/providers.dart';

class ChatsScreen extends ConsumerStatefulWidget {
  const ChatsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends ConsumerState<ChatsScreen> {
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 0;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent * 0.8 &&
          !_isLoadingMore) {
        setState(() {
          _isLoadingMore = true;
          _currentPage++;
        });
        ref.refresh(chatsProvider(_currentPage));
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userIdAsync = ref.watch(userIdProvider);
    final chatsAsync = ref.watch(chatsProvider(0)); // Начальная страница

    return Scaffold(
      appBar: AppBar(
        title: const Text('Чаты'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CreateChatScreen()),
              );
            },
          ),
        ],
      ),
      body: userIdAsync.when(
        data: (userId) {
          if (userId.isEmpty) {
            return const Center(child: Text('Пользователь не авторизован'));
          }
          return chatsAsync.when(
            data: (chats) => RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  _currentPage = 0;
                });
                ref.invalidate(chatsProvider);
              },
              child: chats.isEmpty
                  ? const Center(child: Text('Нет чатов'))
                  : ListView.builder(
                      controller: _scrollController,
                      itemCount: chats.length + (_isLoadingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == chats.length && _isLoadingMore) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        final chat = chats[index];
                        return ListTile(
                          leading: CircleAvatar(
                            child: Text(chat.title.isNotEmpty
                                ? chat.title[0]
                                : chat.type.toString().split('.').last[0]),
                          ),
                          title: Text(
                            chat.title.isNotEmpty
                                ? chat.title
                                : '${chat.type.toString().split('.').last} ${chat.id.substring(0, 4)}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          subtitle: Text(
                            '${chat.type.toString().split('.').last} • ${chat.memberCount} участников',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    MessagesScreen(chatId: chat.id),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Ошибка: $err')),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Ошибка: $err')),
      ),
    );
  }
}

class CreateChatScreen extends ConsumerStatefulWidget {
  const CreateChatScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CreateChatScreen> createState() => _CreateChatScreenState();
}

class _CreateChatScreenState extends ConsumerState<CreateChatScreen> {
  final _titleController = TextEditingController();
  final _userIdsController = TextEditingController();
  ChatType _selectedType = ChatType.GROUP;

  @override
  void dispose() {
    _titleController.dispose();
    _userIdsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatClient = ref.read(chatClientProvider);
    final userIdAsync = ref.watch(userIdProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Создать чат')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Название чата',
                hintText: 'Оставьте пустым для личных чатов',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _userIdsController,
              decoration: const InputDecoration(
                labelText: 'ID пользователей (через запятую)',
                hintText: 'Введите UUID пользователей',
              ),
            ),
            const SizedBox(height: 16),
            DropdownButton<ChatType>(
              value: _selectedType,
              isExpanded: true,
              items: const [
                DropdownMenuItem(
                  value: ChatType.PRIVATE,
                  child: Text('Личный'),
                ),
                DropdownMenuItem(
                  value: ChatType.GROUP,
                  child: Text('Группа'),
                ),
                DropdownMenuItem(
                  value: ChatType.CHANNEL,
                  child: Text('Канал'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedType = value;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final userId = await userIdAsync.when(
                  data: (id) => id,
                  loading: () => '',
                  error: (err, _) => '',
                );
                if (userId.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Пользователь не авторизован')),
                  );
                  return;
                }

                final userIds = _userIdsController.text
                    .split(',')
                    .map((e) => e.trim())
                    .where((e) => e.isNotEmpty)
                    .toList();

                try {
                  final response = await chatClient.createChat(
                    CreateChatRequest(
                      type: _selectedType,
                      title: _titleController.text,
                      creatorId: userId,
                      userIds: userIds,
                    ),
                  );
                  if (response.success) {
                    ref.invalidate(chatsProvider);
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Ошибка: ${response.errorMessage}')),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Ошибка: $e')),
                  );
                }
              },
              child: const Text('Создать'),
            ),
          ],
        ),
      ),
    );
  }
}

class MessagesScreen extends StatelessWidget {
  final String chatId;

  const MessagesScreen({Key? key, required this.chatId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Чат $chatId')),
      body: const Center(child: Text('Экран сообщений (для MessageService)')),
    );
  }
}