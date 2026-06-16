import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../models/user_model.dart';

class AuthService {

  // =========================================================
  // SINGLETON
  // =========================================================

  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // =========================================================
  // STORAGE
  // =========================================================

  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  // =========================================================
  // BASE URL
  // =========================================================

  static const String baseUrl = kIsWeb
      ? "http://127.0.0.1:8000/api/auth"
      : "http://10.0.2.2:8000/api/auth";

  // =========================================================
  // ENDPOINTS
  // =========================================================

  static const String registerEndpoint = "$baseUrl/register/";
  static const String loginEndpoint = "$baseUrl/login/";
  static const String socialLoginEndpoint = "$baseUrl/social/";
  static const String forgotPasswordEndpoint = "$baseUrl/forgot-password/";
  static const String resetPasswordEndpoint = "$baseUrl/reset-password/";
  static const String refreshTokenEndpoint = "$baseUrl/refresh/";
  static const String logoutEndpoint = "$baseUrl/logout/";
  static const String meEndpoint = "$baseUrl/user/profile/";
  static const String updateProfileEndpoint = "$baseUrl/user/profile/";

  // =========================================================
  // HEADERS
  // =========================================================

  Map<String, String> get _headers => {
        "Content-Type": "application/json",
        "Accept": "application/json",
      };

  Future<Map<String, String>> get _authHeaders async {
    final token = await getAccessToken();
    return {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };
  }

  // =========================================================
  // SAVE TOKENS
  // =========================================================

  Future<void> saveTokens(String access, String refresh) async {
    await _storage.write(key: "access_token", value: access);
    await _storage.write(key: "refresh_token", value: refresh);
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: "access_token");
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: "refresh_token");
  }

  Future<void> clearTokens() async {
    await _storage.deleteAll();
  }

  // =========================================================
  // SAVE USER
  // =========================================================

  Future<void> saveUserProfile(UserModel user) async {
    await _storage.write(key: "user_profile", value: jsonEncode(user.toJson()));
  }

  Future<UserModel?> getCurrentUser() async {
    final profileJson = await _storage.read(key: "user_profile");
    if (profileJson == null) return null;
    try {
      return UserModel.fromJson(jsonDecode(profileJson));
    } catch (_) {
      return null;
    }
  }

  // =========================================================
  // SAFE JSON DECODER
  // =========================================================

  dynamic _safeJsonDecode(String body) {
    try {
      return jsonDecode(body);
    } catch (_) {
      return {"message": body};
    }
  }

  // =========================================================
  // ERROR PARSER
  // =========================================================

  String _parseError(dynamic data) {
    if (data == null) return "Unknown error occurred";
    if (data is String) return data;
    if (data is Map<String, dynamic>) {
      if (data["message"] != null) return data["message"].toString();
      if (data["detail"] != null) return data["detail"].toString();
      if (data["errors"] != null && data["errors"] is Map) {
        final errors = data["errors"];
        if (errors["phone_number"] != null) return errors["phone_number"].toString();
        if (errors["email"] != null) return errors["email"].toString();
        if (errors["password"] != null) return errors["password"].toString();
        if (errors["confirm_password"] != null) return errors["confirm_password"].toString();
      }
      if (data["error"] != null) {
        if (data["error"] == "account_locked") return data["message"] ?? "Account locked. Try again later.";
        if (data["error"] == "invalid_credentials") return data["message"] ?? "Invalid credentials";
        if (data["error"] == "account_not_found") return data["message"] ?? "No account found with this phone number";
        if (data["error"] == "captcha_required") return data["message"] ?? "Verification required";
        if (data["error"] == "captcha_failed") return data["message"] ?? "Verification failed";
      }
      for (final value in data.values) {
        if (value is List && value.isNotEmpty) return value.first.toString();
        if (value is String) return value;
      }
    }
    return "Something went wrong";
  }

  // =========================================================
  // REGISTER
  // =========================================================

  Future<Map<String, dynamic>> register({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String password,
    required String confirmPassword,
    String userType = "customer",
    String location = "",
    String referralCode = "",
    String? vehicleType,
    String? vehicleNumber,
    String? licenseNumber,
    String? captchaToken,
  }) async {
    try {
      final body = {
        "full_name": fullName,
        "email": email,
        "phone_number": phoneNumber,
        "password": password,
        "confirm_password": confirmPassword,
        "user_type": userType,
        "location": location,
        "referral_code": referralCode,
      };
      if (captchaToken != null && captchaToken.isNotEmpty) {
        body["captcha_token"] = captchaToken;
      }
      if (userType == "driver") {
        body["vehicle_type"] = vehicleType ?? "";
        body["vehicle_number"] = vehicleNumber ?? "";
        body["license_number"] = licenseNumber ?? "";
      }
      final response = await http.post(
        Uri.parse(registerEndpoint),
        headers: _headers,
        body: jsonEncode(body),
      ).timeout(const Duration(seconds: 20));
      final data = _safeJsonDecode(response.body);
      if (response.statusCode == 201 || response.statusCode == 200) {
        if (data["data"] != null && data["data"]["access_token"] != null) {
          await saveTokens(data["data"]["access_token"], data["data"]["refresh_token"]);
        }
        if (data["data"] != null && data["data"]["user"] != null) {
          await saveUserProfile(UserModel.fromJson(data["data"]["user"]));
        }
        return {"success": true, "message": data["message"] ?? "Registration successful", "data": data["data"]};
      }
      return {"success": false, "message": _parseError(data)};
    } catch (e) {
      return {"success": false, "message": "Registration failed: ${e.toString()}"};
    }
  }

  // =========================================================
  // LOGIN
  // =========================================================

  Future<Map<String, dynamic>> login({
    required String phoneNumber,
    required String password,
    String? captchaToken,
  }) async {
    try {
      final body = {"phone_number": phoneNumber.trim(), "password": password.trim()};
      if (captchaToken != null && captchaToken.isNotEmpty) {
        body["captcha_token"] = captchaToken;
      }
      final response = await http.post(
        Uri.parse(loginEndpoint),
        headers: _headers,
        body: jsonEncode(body),
      ).timeout(const Duration(seconds: 20));
      final data = _safeJsonDecode(response.body);
      if (response.statusCode == 200) {
        if (data["data"] != null && data["data"]["access_token"] != null) {
          await saveTokens(data["data"]["access_token"], data["data"]["refresh_token"]);
        }
        if (data["data"] != null && data["data"]["user"] != null) {
          await saveUserProfile(UserModel.fromJson(data["data"]["user"]));
        }
        return {"success": true, "message": data["message"] ?? "Login successful", "user": data["data"]?["user"]};
      }
      if (data["requires_captcha"] == true) {
        return {"success": false, "message": data["message"] ?? "Verification required", "requires_captcha": true};
      }
      return {"success": false, "message": _parseError(data)};
    } catch (e) {
      return {"success": false, "message": "Login failed: ${e.toString()}"};
    }
  }

  // =========================================================
  // FORGOT PASSWORD
  // =========================================================

  Future<Map<String, dynamic>> forgotPassword({required String phoneNumber}) async {
    try {
      final response = await http.post(
        Uri.parse(forgotPasswordEndpoint),
        headers: _headers,
        body: jsonEncode({"phone_number": phoneNumber}),
      ).timeout(const Duration(seconds: 20));
      final data = _safeJsonDecode(response.body);
      if (response.statusCode == 200) {
        return {"success": true, "message": data["message"] ?? "Reset token sent", "reset_token": data["reset_token"]};
      }
      return {"success": false, "message": _parseError(data)};
    } catch (e) {
      return {"success": false, "message": "Forgot password failed: ${e.toString()}"};
    }
  }

  // =========================================================
  // RESET PASSWORD
  // =========================================================

  Future<Map<String, dynamic>> resetPassword({
    required String token,
    required String newPassword,
    required String confirmPassword,
    required String phoneNumber,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(resetPasswordEndpoint),
        headers: _headers,
        body: jsonEncode({
          "token": token,
          "new_password": newPassword,
          "confirm_password": confirmPassword,
          "phone_number": phoneNumber,
        }),
      ).timeout(const Duration(seconds: 20));
      final data = _safeJsonDecode(response.body);
      if (response.statusCode == 200) {
        return {"success": true, "message": data["message"] ?? "Password reset successful"};
      }
      return {"success": false, "message": _parseError(data)};
    } catch (e) {
      return {"success": false, "message": "Reset password failed: ${e.toString()}"};
    }
  }

  // =========================================================
// GOOGLE SIGN IN
// =========================================================

Future<Map<String, dynamic>> signInWithGoogle() async {
  try {
    // Google Sign-In with Client ID
    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: '942220142341-0a8au268j11in2i3qhl4vuuqh9lmlkft.apps.googleusercontent.com',
      scopes: ['email', 'profile'],
    );
    
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      return {'success': false, 'message': 'Google sign in cancelled'};
    }
    
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    
    // Check if we have a valid token
    if (googleAuth.idToken == null && googleAuth.accessToken == null) {
      return {'success': false, 'message': 'Failed to get authentication token'};
    }
    
    // Use idToken for better compatibility
    final String? tokenToSend = googleAuth.idToken ?? googleAuth.accessToken;
    
    print('✅ Google Auth - ID Token exists: ${googleAuth.idToken != null}');
    print('✅ Google Auth - Access Token exists: ${googleAuth.accessToken != null}');
    print('📧 Google User Email: ${googleUser.email}');
    print('👤 Google User Name: ${googleUser.displayName}');
    
    final response = await http.post(
      Uri.parse(socialLoginEndpoint),
      headers: _headers,
      body: jsonEncode({
        'provider': 'google',
        'access_token': tokenToSend ?? '',
        'email': googleUser.email,
        'full_name': googleUser.displayName ?? googleUser.email.split('@')[0],
      }),
    ).timeout(const Duration(seconds: 30));
    
    final data = _safeJsonDecode(response.body);
    
    print('📡 Social login response status: ${response.statusCode}');
    print('📡 Social login response body: $data');
    
    if (response.statusCode == 200 && data['success'] == true) {
      if (data['data']['access_token'] != null) {
        await saveTokens(data['data']['access_token'], data['data']['refresh_token']);
      }
      if (data['data']['user'] != null) {
        await saveUserProfile(UserModel.fromJson(data['data']['user']));
      }
      return {'success': true, 'message': data['message'] ?? 'Google sign in successful'};
    }
    
    return {'success': false, 'message': data['message'] ?? 'Google sign in failed'};
  } catch (e) {
    print('❌ Google sign in error: $e');
    return {'success': false, 'message': 'Google sign in failed: ${e.toString()}'};
  }
}

  // =========================================================
  // APPLE SIGN IN (Fixed - removed fullName reference)
  // =========================================================

  Future<Map<String, dynamic>> signInWithApple() async {
    try {
      final isAvailable = await SignInWithApple.isAvailable();
      if (!isAvailable) {
        return {'success': false, 'message': 'Apple Sign In is not available on this device'};
      }
      
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
      );
      
      // Create a display name from the user identifier
      String fullName = 'Apple User';
      if (credential.userIdentifier != null && credential.userIdentifier!.length > 8) {
        fullName = 'Apple User ${credential.userIdentifier!.substring(0, 8)}';
      }
      
      print('Apple Sign In - Email: ${credential.email}');
      print('Apple Sign In - User ID: ${credential.userIdentifier}');
      
      final response = await http.post(
        Uri.parse(socialLoginEndpoint),
        headers: _headers,
        body: jsonEncode({
          'provider': 'apple',
          'access_token': credential.authorizationCode,
          'user_identifier': credential.userIdentifier,
          'email': credential.email ?? '',
          'full_name': fullName,
        }),
      );
      
      final data = _safeJsonDecode(response.body);
      
      print('Apple login response status: ${response.statusCode}');
      
      if (response.statusCode == 200 && data['success'] == true) {
        if (data['data']['access_token'] != null) {
          await saveTokens(data['data']['access_token'], data['data']['refresh_token']);
        }
        if (data['data']['user'] != null) {
          await saveUserProfile(UserModel.fromJson(data['data']['user']));
        }
        return {'success': true, 'message': data['message'] ?? 'Apple sign in successful'};
      }
      return {'success': false, 'message': data['message'] ?? 'Apple sign in failed'};
    } catch (e) {
      print('Apple sign in error: $e');
      return {'success': false, 'message': 'Apple sign in failed: ${e.toString()}'};
    }
  }

  // =========================================================
  // LOGOUT
  // =========================================================

  Future<void> logout() async {
    try {
      final refresh = await getRefreshToken();
      if (refresh != null) {
        final headers = await _authHeaders;
        await http.post(
          Uri.parse(logoutEndpoint), 
          headers: headers, 
          body: jsonEncode({"refresh_token": refresh})
        ).timeout(const Duration(seconds: 10));
      }
      // Sign out from Google as well
      try {
        final GoogleSignIn googleSignIn = GoogleSignIn();
        await googleSignIn.signOut();
      } catch (_) {}
    } catch (e) {
      print("Logout error: $e");
    } finally {
      await clearTokens();
    }
  }

  // =========================================================
  // GET PROFILE
  // =========================================================

  Future<Map<String, dynamic>> getMe() async {
    try {
      final headers = await _authHeaders;
      final response = await http.get(
        Uri.parse(meEndpoint), 
        headers: headers
      ).timeout(const Duration(seconds: 15));
      final data = _safeJsonDecode(response.body);
      if (response.statusCode == 200) {
        if (data["data"] != null) {
          await saveUserProfile(UserModel.fromJson(data["data"]));
        }
        return {"success": true, "data": data["data"] ?? data};
      }
      // If token expired, clear it
      if (response.statusCode == 401) {
        await clearTokens();
      }
      return {"success": false, "message": _parseError(data)};
    } catch (e) {
      return {"success": false, "message": "Failed to fetch profile: ${e.toString()}"};
    }
  }

  // =========================================================
  // UPDATE PROFILE
  // =========================================================

  Future<Map<String, dynamic>> updateProfile({
    String? fullName,
    String? location,
    String? vehicleType,
    String? vehicleNumber,
    String? licenseNumber,
  }) async {
    try {
      final headers = await _authHeaders;
      final body = {
        if (fullName != null) "full_name": fullName,
        if (location != null) "location": location,
        if (vehicleType != null) "vehicle_type": vehicleType,
        if (vehicleNumber != null) "vehicle_number": vehicleNumber,
        if (licenseNumber != null) "license_number": licenseNumber,
      };
      final response = await http.patch(
        Uri.parse(updateProfileEndpoint), 
        headers: headers, 
        body: jsonEncode(body)
      ).timeout(const Duration(seconds: 15));
      final data = _safeJsonDecode(response.body);
      if (response.statusCode == 200) {
        if (data["data"] != null) {
          await saveUserProfile(UserModel.fromJson(data["data"]));
        }
        return {"success": true, "message": data["message"] ?? "Profile updated successfully", "data": data["data"]};
      }
      return {"success": false, "message": _parseError(data)};
    } catch (e) {
      return {"success": false, "message": "Profile update failed: ${e.toString()}"};
    }
  }

  // =========================================================
  // CHECK LOGIN
  // =========================================================

  Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    if (token == null) return false;
    
    // Validate token by fetching profile
    try {
      final headers = await _authHeaders;
      final response = await http.get(
        Uri.parse(meEndpoint), 
        headers: headers
      ).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 401) {
        // Token expired, clear it
        await clearTokens();
        return false;
      }
      return false;
    } catch (e) {
      return token != null;
    }
  }
  
  // =========================================================
  // VALIDATE TOKEN
  // =========================================================
  
  Future<bool> validateToken() async {
    final token = await getAccessToken();
    if (token == null) return false;
    
    try {
      final headers = await _authHeaders;
      final response = await http.get(
        Uri.parse(meEndpoint), 
        headers: headers
      ).timeout(const Duration(seconds: 10));
      
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}