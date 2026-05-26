import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/api_constants.dart';
import '../models/user_model.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final _storage = const FlutterSecureStorage();

  // ──────────────────────────────────────────────────────────────
  // Token Management
  // ──────────────────────────────────────────────────────────────

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

  Future<void> saveUserProfile(UserModel user) async {
    await _storage.write(key: 'user_profile', value: jsonEncode(user.toJson()));
  }

  Future<UserModel?> getCurrentUser() async {
    final profileJson = await _storage.read(key: 'user_profile');
    if (profileJson != null && profileJson.isNotEmpty) {
      return UserModel.fromJson(jsonDecode(profileJson));
    }
    return null;
  }

  // ──────────────────────────────────────────────────────────────
  // API Headers
  // ──────────────────────────────────────────────────────────────

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

  // ──────────────────────────────────────────────────────────────
  // Error Parsing Helper
  // ──────────────────────────────────────────────────────────────

  String _parseErrorMessage(Map<String, dynamic> data) {
    // Priority 1: Direct message field
    if (data['message'] != null && data['message'] is String) {
      return data['message'];
    }
    
    // Priority 2: Django REST errors object
    if (data['errors'] is Map) {
      final errors = data['errors'] as Map;
      if (errors.isNotEmpty) {
        final firstKey = errors.keys.first;
        final firstValue = errors[firstKey];
        if (firstValue is List) {
          return '$firstKey: ${firstValue.first}';
        }
        return '$firstKey: $firstValue';
      }
    }
    
    // Priority 3: Detail field (DRF default)
    if (data['detail'] != null) {
      return data['detail'].toString();
    }
    
    // Priority 4: Any string value in response
    for (final value in data.values) {
      if (value is String && value.isNotEmpty) {
        return value;
      }
      if (value is List && value.isNotEmpty && value.first is String) {
        return value.first.toString();
      }
    }
    
    return 'An error occurred. Please try again.';
  }

  // ──────────────────────────────────────────────────────────────
  // Auth Actions
  // ──────────────────────────────────────────────────────────────

  Future<Map<String, dynamic>> getAppInfo() async {
    try {
      final response = await http.get(
        Uri.parse(ApiConstants.appInfo),
        headers: _headers,
      ).timeout(const Duration(seconds: 10));

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'data': data};
      }
      return {'success': false, 'message': 'Failed to load app info'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // ──────────────────────────────────────────────────────────────
  // ✅ REGISTER — Complete Field Support + Error Handling
  // ──────────────────────────────────────────────────────────────
  Future<Map<String, dynamic>> register({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String password,
    required String confirmPassword,
    // Optional fields with defaults
    String userType = 'customer',
    String location = '',
    String referralCode = '',
    // Driver-specific fields (nullable, only sent when userType == 'driver')
    String? vehicleType,
    String? vehicleNumber,
    String? licenseNumber,
  }) async {
    try {
      // Build request body with ALL fields Django expects
      final body = {
        'full_name': fullName,
        'email': email,
        'phone_number': phoneNumber,
        'password': password,
        'confirm_password': confirmPassword,
        'user_type': userType,
        'location': location,
        if (referralCode.isNotEmpty) 'referral_code': referralCode,
        // ✅ Conditionally include driver fields ONLY when userType is 'driver'
        if (userType == 'driver') ...{
          'vehicle_type': vehicleType ?? '',
          'vehicle_number': vehicleNumber ?? '',
          'license_number': licenseNumber ?? '',
        },
      };

      final response = await http.post(
        Uri.parse(ApiConstants.register),
        headers: _headers,
        body: jsonEncode(body),
      ).timeout(const Duration(seconds: 15));

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        // ✅ Expect flattened tokens from Django backend
        if (data['access'] == null || data['refresh'] == null) {
          return {
            'success': false,
            'message': 'Server response missing authentication tokens.',
          };
        }
        
        await saveTokens(data['access'], data['refresh']);
        
        if (data['user'] != null) {
          final user = UserModel.fromJson(data['user']);
          await saveUserProfile(user);
        }
        
        return {
          'success': true,
          'message': data['message'] ?? 'Account created successfully! Please log in.',
          'user': data['user'] != null ? UserModel.fromJson(data['user']) : null,
        };
      }

      // Parse backend validation errors
      return {
        'success': false,
        'message': _parseErrorMessage(data),
      };
      
    } on TimeoutException {
      return {
        'success': false,
        'message': 'Request timed out. Please check your connection and try again.',
      };
    } on http.ClientException catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.message}',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Registration failed: ${e.toString()}',
      };
    }
  }

  // ──────────────────────────────────────────────────────────────
  // ✅ LOGIN — Fixed Field Name + Lockout Handling
  // ──────────────────────────────────────────────────────────────
  Future<Map<String, dynamic>> login({
    required String emailOrPhone, 
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.login),
        headers: _headers,
        body: jsonEncode({
          // ✅ CRITICAL FIX: Django expects 'email_or_phone', NOT 'phone_number'
          'email_or_phone': emailOrPhone,
          'password': password,
        }),
      ).timeout(const Duration(seconds: 15));

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // ✅ Expect flattened tokens from Django backend
        if (data['access'] == null || data['refresh'] == null) {
          return {
            'success': false,
            'message': 'Server response missing authentication tokens.',
          };
        }
        
        await saveTokens(data['access'], data['refresh']);
        
        if (data['user'] != null) {
          final user = UserModel.fromJson(data['user']);
          await saveUserProfile(user);
        }
        
        return {
          'success': true,
          'message': data['message'] ?? 'Login successful.',
          'user': data['user'] != null ? UserModel.fromJson(data['user']) : null,
        };
      }

      // Handle specific HTTP status codes from backend
      if (response.statusCode == 423) {
        // Account locked due to failed attempts
        return {
          'success': false,
          'message': data['message'] ?? 'Too many failed attempts. Account temporarily locked.',
          'locked': true,
        };
      }

      if (response.statusCode == 401) {
        return {
          'success': false,
          'message': 'Invalid credentials. Please check your email/phone and password.',
        };
      }

      if (response.statusCode == 403) {
        return {
          'success': false,
          'message': data['message'] ?? 'Account access denied.',
        };
      }

      // Generic error parsing
      return {
        'success': false,
        'message': _parseErrorMessage(data),
      };
      
    } on TimeoutException {
      return {
        'success': false,
        'message': 'Request timed out. Please check your connection and try again.',
      };
    } on http.ClientException catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.message}',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Login failed: ${e.toString()}',
      };
    }
  }

  // ──────────────────────────────────────────────────────────────
  // Logout
  // ──────────────────────────────────────────────────────────────
  Future<void> logout() async {
    try {
      final refresh = await getRefreshToken();
    
      if (refresh != null && refresh.isNotEmpty) {
        final headers = await _authHeaders;
        await http.post(
          Uri.parse(ApiConstants.logout),
          headers: headers,
          body: jsonEncode({'refresh': refresh}),
        ).timeout(const Duration(seconds: 10));
      }
    } catch (e) {
      // Silently fail - always clear tokens locally
    } finally {
      await clearTokens();
    }
  }

  // ──────────────────────────────────────────────────────────────
  // Social Login (Google/Apple)
  // ──────────────────────────────────────────────────────────────
  Future<Map<String, dynamic>> socialLogin({
    required String provider, // 'google' or 'apple'
    required String accessToken,
    String? idToken, // For Apple sign-in
    String fullName = '',
    String email = '',
  }) async {
    try {
      final body = {
        'provider': provider,
        'access_token': accessToken,
        if (idToken != null) 'id_token': idToken,
        if (fullName.isNotEmpty) 'full_name': fullName,
        if (email.isNotEmpty) 'email': email,
      };

      final response = await http.post(
        Uri.parse(ApiConstants.socialAuth),
        headers: _headers,
        body: jsonEncode(body),
      ).timeout(const Duration(seconds: 15));

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (data['access'] == null || data['refresh'] == null) {
          return {
            'success': false,
            'message': 'Server response missing authentication tokens.',
          };
        }
        
        await saveTokens(data['access'], data['refresh']);
        
        if (data['user'] != null) {
          final user = UserModel.fromJson(data['user']);
          await saveUserProfile(user);
        }

        return {
          'success': true,
          'message': data['message'] ?? '${provider.capitalize()} sign-in successful.',
          'user': data['user'] != null ? UserModel.fromJson(data['user']) : null,
        };
      }

      return {
        'success': false,
        'message': _parseErrorMessage(data),
      };
      
    } catch (e) {
      return {
        'success': false,
        'message': '${provider.capitalize()} sign-in failed: ${e.toString()}',
      };
    }
  }

  // ──────────────────────────────────────────────────────────────
  // Refresh Token
  // ──────────────────────────────────────────────────────────────
  Future<Map<String, dynamic>> refreshToken() async {
    try {
      final refresh = await getRefreshToken();
      if (refresh == null || refresh.isEmpty) {
        return {'success': false, 'message': 'No refresh token available'};
      }

      final response = await http.post(
        Uri.parse(ApiConstants.tokenRefresh),
        headers: _headers,
        body: jsonEncode({'refresh': refresh}),
      ).timeout(const Duration(seconds: 10));

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (data['access'] != null) {
          // Update access token, keep existing refresh
          await _storage.write(key: 'access_token', value: data['access']);
          if (data['refresh'] != null) {
            await _storage.write(key: 'refresh_token', value: data['refresh']);
          }
          return {'success': true, 'data': data};
        }
      }

      await clearTokens();
      return {'success': false, 'message': 'Token refresh failed'};
      
    } catch (e) {
      await clearTokens();
      return {'success': false, 'message': 'Token refresh error: ${e.toString()}'};
    }
  }

  // ──────────────────────────────────────────────────────────────
  // Update Profile (Authenticated)
  // ──────────────────────────────────────────────────────────────
  Future<Map<String, dynamic>> updateProfile({
    String? fullName,
    String? phoneNumber,
    String? companyName,
    int? fleetSize,
  }) async {
    try {
      final headers = await _authHeaders;
      final body = <String, dynamic>{};
      
      if (fullName != null) body['full_name'] = fullName;
      if (phoneNumber != null) body['phone_number'] = phoneNumber;
      if (companyName != null) body['company_name'] = companyName;
      if (fleetSize != null) body['fleet_size'] = fleetSize;

      if (body.isEmpty) {
        return {'success': false, 'message': 'No fields to update'};
      }

      final response = await http.patch(
        Uri.parse(ApiConstants.updateProfile),
        headers: headers,
        body: jsonEncode(body),
      ).timeout(const Duration(seconds: 15));

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (data is Map && data['user'] != null) {
          final updatedUser = UserModel.fromJson(data['user']);
          await saveUserProfile(updatedUser);
          return {'success': true, 'user': updatedUser};
        }
        // Handle case where response is just the user object
        final updatedUser = UserModel.fromJson(data);
        await saveUserProfile(updatedUser);
        return {'success': true, 'user': updatedUser};
      }

      return {'success': false, 'message': _parseErrorMessage(data)};
      
    } catch (e) {
      return {'success': false, 'message': 'Profile update failed: ${e.toString()}'};
    }
  }

  // ──────────────────────────────────────────────────────────────
  // Change Password (Authenticated)
  // ──────────────────────────────────────────────────────────────
  Future<Map<String, dynamic>> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    try {
      final headers = await _authHeaders;
      final response = await http.post(
        Uri.parse(ApiConstants.changePassword),
        headers: headers,
        body: jsonEncode({
          'old_password': oldPassword,
          'new_password': newPassword,
          'confirm_new_password': confirmNewPassword,
        }),
      ).timeout(const Duration(seconds: 15));

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Password changed successfully'};
      }

      return {'success': false, 'message': _parseErrorMessage(data)};
      
    } catch (e) {
      return {'success': false, 'message': 'Password change failed: ${e.toString()}'};
    }
  }

  // ──────────────────────────────────────────────────────────────
  // Forgot Password (Public)
  // ──────────────────────────────────────────────────────────────
  Future<Map<String, dynamic>> forgotPassword({required String email}) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.forgotPassword),
        headers: _headers,
        body: jsonEncode({'email': email}),
      ).timeout(const Duration(seconds: 15));

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'message': data['message'] ?? 'If that email exists, a reset code has been sent.'};
      }

      return {
        'success': false,
        'message': _parseErrorMessage(data),
      };
      
    } catch (e) {
      return {
        'success': false,
        'message': 'Failed to send reset request: ${e.toString()}',
      };
    }
  }

  // ──────────────────────────────────────────────────────────────
  // Reset Password (Public)
  // ──────────────────────────────────────────────────────────────
  Future<Map<String, dynamic>> resetPassword({
    required String token,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.resetPassword),
        headers: _headers,
        body: jsonEncode({
          'token': token,
          'new_password': newPassword,
          'confirm_new_password': confirmNewPassword,
        }),
      ).timeout(const Duration(seconds: 15));

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Password reset successfully. You can now log in.'};
      }

      return {'success': false, 'message': _parseErrorMessage(data)};
      
    } catch (e) {
      return {'success': false, 'message': 'Password reset failed: ${e.toString()}'};
    }
  }
}

// ──────────────────────────────────────────────────────────────
// String Extension for Capitalization (used in social login messages)
// ──────────────────────────────────────────────────────────────
extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
}