import 'package:grpc/grpc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibe/generated/auth/auth.pbgrpc.dart';


class AuthService {
  final AuthServiceClient client;
  final SharedPreferences prefs;

  AuthService(this.client, this.prefs);


  Future<SendCodeResponse> sendVerificationCode(String phoneNumber) async {
    final request = PhoneNumberRequest()..phoneNumber = phoneNumber;
    try {
      return await client.sendVerificationCode(request);  
    } catch (e) {
      throw Exception('Error send code: $e');
    }
   
  }

  Future<AuthResponse> verifyCode(String phoneNumber, String code, String token) async {
    final request = VerifyCodeRequest()
    ..phoneNumber = phoneNumber
    ..code = code
    ..token = token;

    try {
      final response = await client.verifyCode(request);
    	if (response.success) {
      	await prefs.setString('auth_token', response.authToken);
      	await prefs.setString('user_id', response.userId);
    	}
			return response;
		} catch (e) {
			throw Exception('Error verify code: $e');
		}
  }

  String? getToken() => prefs.getString('auth_token');
  String? getUserID() => prefs.getString('user_id');

}