import 'package:grpc/grpc.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibe/generated/auth/auth.pbgrpc.dart';


class AuthService {
  final AuthServiceClient client;
  final FlutterSecureStorage secureStorage;
  final SharedPreferences? sharedPrefs;

  AuthService(this.client, this.secureStorage, {this.sharedPrefs});

  Future<bool> validateToken() async {
    final token = await getToken();
    if (token == null) {
      return false;
    }

    try {
      final request = ValidateTokenRequest()..token = token;
      final response = await client.validateToken(request);
      if (!response.success) {
        await clearToken();
      }
      return response.success;
    } catch (e) {
      print('Error validation token: $e');
      await clearToken();
      return false;
    }
  }

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
        if (kIsWeb && sharedPrefs != null) {
          await sharedPrefs!.setString('auth_token', response.authToken);
          await sharedPrefs!.setString('user_id', response.userId);
        } else {
          await secureStorage.write(key: 'auth_token', value: response.authToken);
          await secureStorage.write(key: 'user_id', value: response.userId);
        }
    	}
			return response;
		} catch (e) {
			throw Exception('Error verify code: $e');
		}
  }

  Future<String?> getToken() async {
    if (kIsWeb && sharedPrefs != null) {
      return sharedPrefs!.getString('auth_token');
    }
    return await secureStorage.read(key: 'auth_token');
  }

  Future<String?> getUserId() async {
    if (kIsWeb && sharedPrefs != null) {
      return sharedPrefs!.getString('user_id');
    }
    return await secureStorage.read(key: 'user_id');
  }

  Future<void> clearToken() async {
    if (kIsWeb && sharedPrefs != null) {
      await sharedPrefs!.remove('auth_token');
      await sharedPrefs!.remove('user_id');
    } else {
      await secureStorage.delete(key: 'auth_token');
      await secureStorage.delete(key: 'user_id');
    }
  }

}