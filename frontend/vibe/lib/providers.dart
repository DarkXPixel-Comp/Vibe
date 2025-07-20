import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grpc/grpc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibe/generated/auth/auth.pbgrpc.dart';
import 'package:vibe/services/auth_service.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(); 
});

final clientChannerProvider = Provider<ClientChannel>((ref) {
  return ClientChannel(
    '192.168.1.3', port: 50032,
    options: const ChannelOptions(credentials: ChannelCredentials.insecure()));
});

final authClientProvider = Provider<AuthServiceClient>((ref) {
  return AuthServiceClient(ref.read(clientChannerProvider));
});

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(
    ref.read(authClientProvider),
    ref.read(sharedPreferencesProvider));
});

