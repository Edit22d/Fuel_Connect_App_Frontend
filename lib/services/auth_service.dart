import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/api_constants.dart';
import '../models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AuthService {
  Future<void> saveAuthData({
    required String token,
    required String userId,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('token', token);
    await prefs.setString('userId', userId);
  }

  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final _storage = const FlutterSecureStorage();

  Future<void> saveTokens(String access, String refresh) async {
    await _storage.write(key: 'access_token', value: access);
    await _storage.write(key: 'refresh_token', value: refresh);
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: 'access_token');
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: 'refresh_token');
  }

  Future<void> clearTokens() async {
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
    await _storage.delete(key: 'user_profile');
  }

  Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  Future<UserModel?> getCurrentUser() async {
    final profileJson = await _storage.read(key: 'user_profile');
    if (profileJson != null && profileJson.isNotEmpty) {
      return UserModel.fromJson(jsonDecode(profileJson));
    }
    return null;
  }

  Future<void> saveUserProfile(UserModel user) async {
    await _storage.write(key: 'user_profile', value: jsonEncode(user.toJson()));
  }

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
      };

  Future<Map<String, String>> get _authHeaders async {
    final token = await getAccessToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<Map<String, dynamic>> getAppInfo() async {
    final response = await http.get(
      Uri.parse(ApiConstants.appInfo),
      headers: _headers,
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return {'success': true, 'data': data};
    }
    return {'success': false, 'message': 'Failed to load app info'};
  }

  Future<Map<String, dynamic>> register({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String password,
    required String confirmPassword,
  }) async {
    final response = await http.post(
      Uri.parse(ApiConstants.register),
      headers: _headers,
      body: jsonEncode({
        'full_name': fullName,
        'email': email,
        'phone_number': phoneNumber,
        'password': password,
        'confirm_password': confirmPassword,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      await saveTokens(data['access'], data['refresh']);
      final user = UserModel.fromJson(data['user']);
      await saveUserProfile(user);
      return {
        'success': true,
        'user': user,
        'message': data['message'],
      };
    }

    String errorMsg = 'Registration failed.';
    if (data is Map) {
      final firstKey = data.keys.first;
      final firstValue = data[firstKey];
      errorMsg =
          firstValue is List ? firstValue.first : firstValue.toString();
    }
    return {'success': false, 'message': errorMsg};
  }

  Future<Map<String, dynamic>> login({
    required String emailOrPhone,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse(ApiConstants.login),
      headers: _headers,
      body: jsonEncode({
        'email': emailOrPhone,
        'password': password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      await saveTokens(data['access'], data['refresh']);
      final user = UserModel.fromJson(data['user']);
      await saveUserProfile(user);
      return {
        'success': true,
        'user': user,
      };
    }

    return {
      'success': false,
      'message': data['detail'] ?? 'Invalid credentials.',
    };
  }

  Future<void> logout() async {
    final refresh = await getRefreshToken();
    final headers = await _authHeaders;

    await http.post(
      Uri.parse(ApiConstants.logout),
      headers: headers,
      body: jsonEncode({'refresh': refresh}),
    );

    await clearTokens();
  }

  Future<Map<String, dynamic>> socialLogin({
    required String provider,
    required String accessToken,
    String fullName = '',
    String email = '',
  }) async {
    final body = {
      'provider': provider,
      'access_token': accessToken,
    };
    if (fullName.isNotEmpty) body['full_name'] = fullName;
    if (email.isNotEmpty) body['email'] = email;

    final response = await http.post(
      Uri.parse(ApiConstants.socialAuth),
      headers: _headers,
      body: jsonEncode(body),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      await saveTokens(data['access'], data['refresh']);
      final user = UserModel.fromJson(data['user']);
      await saveUserProfile(user);

      return {
        'success': true,
        'user': user,
      };
    }

    return {
      'success': false,
      'message': data['detail'] ?? 'Social authentication failed.',
    };
  }

  Future<Map<String, dynamic>> refreshToken() async {
    final refresh = await getRefreshToken();
    if (refresh == null || refresh.isEmpty) {
      return {'success': false, 'message': 'No refresh token available'};
    }

    final response = await http.post(
      Uri.parse(ApiConstants.tokenRefresh),
      headers: _headers,
      body: jsonEncode({'refresh': refresh}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      await saveTokens(data['access'], data['refresh']);
      return {'success': true, 'data': data};
    }

    await clearTokens();
    return {'success': false, 'message': 'Token refresh failed'};
  }

  Future<Map<String, dynamic>> updateProfile({
    String? fullName,
    String? phoneNumber,
    String? companyName,
    int? fleetSize,
  }) async {
    final headers = await _authHeaders;
    final body = <String, dynamic>{};
    if (fullName != null) body['full_name'] = fullName;
    if (phoneNumber != null) body['phone_number'] = phoneNumber;
    if (companyName != null) body['company_name'] = companyName;
    if (fleetSize != null) body['fleet_size'] = fleetSize;

    final response = await http.patch(
      Uri.parse(ApiConstants.updateProfile),
      headers: headers,
      body: jsonEncode(body),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final updatedUser = UserModel.fromJson(data);
      await saveUserProfile(updatedUser);
      return {'success': true, 'user': updatedUser};
    }

    String errorMsg = 'Update failed.';
    if (data is Map) {
      final firstKey = data.keys.first;
      final firstValue = data[firstKey];
      errorMsg = firstValue is List ? firstValue.first : firstValue.toString();
    }
    return {'success': false, 'message': errorMsg};
  }

  Future<Map<String, dynamic>> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    final headers = await _authHeaders;
    final response = await http.post(
      Uri.parse(ApiConstants.changePassword),
      headers: headers,
      body: jsonEncode({
        'old_password': oldPassword,
        'new_password': newPassword,
        'confirm_new_password': confirmNewPassword,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return {'success': true, 'message': 'Password changed successfully'};
    }

    String errorMsg = 'Password change failed.';
    if (data is Map) {
      final firstKey = data.keys.first;
      final firstValue = data[firstKey];
      errorMsg = firstValue is List ? firstValue.first : firstValue.toString();
    }
    return {'success': false, 'message': errorMsg};
  }

  Future<Map<String, dynamic>> forgotPassword({required String email}) async {
    final response = await http.post(
      Uri.parse(ApiConstants.forgotPassword),
      headers: _headers,
      body: jsonEncode({'email': email}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return {'success': true, 'message': data['message'] ?? 'Reset link sent'};
    }

    return {
      'success': false,
      'message': data['detail'] ?? 'Failed to send reset link',
    };
  }

  Future<Map<String, dynamic>> resetPassword({
    required String token,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    final response = await http.post(
      Uri.parse(ApiConstants.resetPassword),
      headers: _headers,
      body: jsonEncode({
        'token': token,
        'new_password': newPassword,
        'confirm_new_password': confirmNewPassword,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return {'success': true, 'message': 'Password reset successfully'};
    }

    String errorMsg = 'Reset failed.';
    if (data is Map) {
      final firstKey = data.keys.first;
      final firstValue = data[firstKey];
      errorMsg = firstValue is List ? firstValue.first : firstValue.toString();
    }
    return {'success': false, 'message': errorMsg};
  }
}



