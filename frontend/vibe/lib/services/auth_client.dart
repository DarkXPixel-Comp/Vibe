import 'package:grpc/grpc.dart';
import 'package:vibe/generated/auth/auth.pbgrpc.dart';

class AuthClient {
  late final AuthServiceClient client;

  AuthClient() {
    final channel = ClientChannel(
      'localhost',
      port: 50051,
      options: const ChannelOptions(credentials: ChannelCredentials.insecure())
    );

    client = AuthServiceClient(channel);
  }

  Future<AuthResponse> login(String username, String password) {
    final request = LoginRequest()
    ..username = username
    ..password = password;

    return client.login(request);
  }


  // AuthServiceClient {
  //   final channel = ClientChannel(
  //   'localhost',
  //   port: 50050,
  //   options: const ChannelOptions(credentials: Channel)
  // );
  // }
}