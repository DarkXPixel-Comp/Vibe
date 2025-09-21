import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:grpc/grpc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibe/generated/auth/auth.pbgrpc.dart';
import 'package:vibe/generated/chat/chat.pbgrpc.dart';
import 'package:vibe/services/auth_service.dart';

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
    return const FlutterSecureStorage();
},);

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(); 
});

final clientChannelProvider = Provider<ClientChannel>((ref) {
  return ClientChannel(
    '10.0.2.2', port: 8080,
    options: const ChannelOptions(credentials: ChannelCredentials.insecure()));
});

final authClientProvider = Provider<AuthServiceClient>((ref) {
  return AuthServiceClient(ref.read(clientChannelProvider));
});

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(
    ref.read(authClientProvider),
    ref.read(secureStorageProvider),
    sharedPrefs: kIsWeb ? ref.read(sharedPreferencesProvider) : null);
});

final chatClientProvider = Provider<ChatServiceClient>((ref) {
  const storage = FlutterSecureStorage();
  return ChatServiceClient(
    ref.read(clientChannelProvider),
    options: CallOptions(
      metadata: {
        'content-type': kIsWeb ? 'application/grpc-web+proto' : 'application/grpc',
        'authorization': 'Bearer ${storage.read(key: 'auth_token').toString()}'
      },
    ),
  );
});


final userIdProvider = FutureProvider<String>((ref) async {
  const storage = FlutterSecureStorage();
  return await storage.read(key: 'user_id') ?? '';
});



final chatsProvider = FutureProvider.family<List<Chat>, int>((ref, page) async {
  final chatClient = ref.read(chatClientProvider);
  final userId = await ref.read(userIdProvider.future);
  const pageSize = 20;
  final response = await chatClient.listUserChats(ListUserChatsRequest(
    userId: userId,
    limit: pageSize,
    offset: page * pageSize,
  ));
  return response.chats;
});
