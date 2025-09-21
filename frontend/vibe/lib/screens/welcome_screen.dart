import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:vibe/providers/theme_provider.dart';

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeNotiferProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
            onPressed: () => ref.read(themeNotiferProvider.notifier).toggle(),
          ),
        ],
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Routemaster.of(context).push('/chat'),
              child: const Text('Хуй!'),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.favorite,
              size: 64,
              color: isDark ? Colors.white : Colors.black,
            ),
          ],
        ),
      ),
      // Center(
      //   child: ElevatedButton(
      //     onPressed: () => Routemaster.of(context).push('/chat'),
      //     child: const Text('Хуй!'),
      //   ),
      // ),
    );
  }
}