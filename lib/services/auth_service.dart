
import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../models/user_model.dart';

class AuthService {

  // =========================================================
  // SINGLETON
  // =========================================================

  static final AuthService _instance =
      AuthService._internal();

  factory AuthService() => _instance;

  AuthService._internal();

  // =========================================================
  // STORAGE
  // =========================================================

  final FlutterSecureStorage _storage =
      const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility:
          KeychainAccessibility.first_unlock,
    ),
  );

  // =========================================================
  // BASE URL
  // =========================================================

  /*
    ANDROID EMULATOR:
    http://10.0.2.2:8000/api/v1/auth

    REAL PHONE:
    http://192.168.1.5:8000/api/v1/auth

    WEB:
    http://127.0.0.1:8000/api/v1/auth
  */

  static const String baseUrl =
      kIsWeb
          ? "http://127.0.0.1:8000/api/v1/auth"
          : "http://10.0.2.2:8000/api/v1/auth";

  // =========================================================
  // ENDPOINTS
  // =========================================================

  static const String registerEndpoint =
      "$baseUrl/register/";

  static const String loginEndpoint =
      "$baseUrl/login/";

  static const String forgotPasswordEndpoint =
      "$baseUrl/forgot-password/";

  static const String resetPasswordEndpoint =
      "$baseUrl/reset-password/";

  static const String refreshTokenEndpoint =
      "$baseUrl/token/refresh/";

  static const String logoutEndpoint =
      "$baseUrl/logout/";

  static const String meEndpoint =
      "$baseUrl/me/";

  static const String updateProfileEndpoint =
      "$baseUrl/profile/update/";

  static const String appInfoEndpoint =
      "$baseUrl/app-info/";

  // =========================================================
  // HEADERS
  // =========================================================

  Map<String, String> get _headers => {
        "Content-Type": "application/json",
        "Accept": "application/json",
      };

  Future<Map<String, String>>
      get _authHeaders async {

    final token =
        await getAccessToken();

    return {
      "Content-Type":
          "application/json",
      "Accept":
          "application/json",
      "Authorization":
          "Bearer $token",
    };
  }

  // =========================================================
  // SAVE TOKENS
  // =========================================================

  Future<void> saveTokens(
    String access,
    String refresh,
  ) async {

    await _storage.write(
      key: "access_token",
      value: access,
    );

    await _storage.write(
      key: "refresh_token",
      value: refresh,
    );
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(
      key: "access_token",
    );
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(
      key: "refresh_token",
    );
  }

  Future<void> clearTokens() async {
    await _storage.deleteAll();
  }

  // =========================================================
  // SAVE USER
  // =========================================================

  Future<void> saveUserProfile(
    UserModel user,
  ) async {

    await _storage.write(
      key: "user_profile",
      value: jsonEncode(user.toJson()),
    );
  }

  Future<UserModel?> getCurrentUser() async {

    final profileJson =
        await _storage.read(
      key: "user_profile",
    );

    if (profileJson == null) {
      return null;
    }

    try {

      return UserModel.fromJson(
        jsonDecode(profileJson),
      );

    } catch (_) {

      return null;
    }
  }

  // =========================================================
  // SAFE JSON DECODER
  // =========================================================

  dynamic _safeJsonDecode(
      String body) {

    try {

      return jsonDecode(body);

    } catch (_) {

      return {
        "message": body,
      };
    }
  }

  // =========================================================
  // ERROR PARSER
  // =========================================================

  String _parseError(dynamic data) {

    if (data == null) {
      return "Unknown error occurred";
    }

    if (data is String) {
      return data;
    }

    if (data is Map<String, dynamic>) {

      if (data["message"] != null) {
        return data["message"]
            .toString();
      }

      if (data["detail"] != null) {
        return data["detail"]
            .toString();
      }

      for (final value
          in data.values) {

        if (value is List &&
            value.isNotEmpty) {

          return value.first
              .toString();
        }

        if (value is String) {
          return value;
        }
      }
    }

    return "Something went wrong";
  }

  // =========================================================
  // GET APP INFO
  // =========================================================

  Future<Map<String, dynamic>>
      getAppInfo() async {

    try {

      final response = await http
          .get(
            Uri.parse(appInfoEndpoint),
            headers: _headers,
          )
          .timeout(
            const Duration(seconds: 15),
          );

      final data =
          _safeJsonDecode(
              response.body);

      if (response.statusCode ==
          200) {

        return {
          "success": true,
          "data": data,
        };
      }

      return {
        "success": false,
        "message":
            _parseError(data),
      };

    } catch (e) {

      return {
        "success": false,
        "message":
            "Failed to load app info",
      };
    }
  }

  // =========================================================
  // REGISTER
  // =========================================================

  Future<Map<String, dynamic>>
      register({
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
  }) async {

    try {

      final body = {
        "full_name": fullName,
        "email": email,
        "phone_number":
            phoneNumber,
        "password": password,
        "confirm_password":
            confirmPassword,
        "user_type": userType,
        "location": location,
        "company_name": "",
        "fleet_size": 0,

        if (referralCode
            .isNotEmpty)
          "referral_code":
              referralCode,

        if (userType ==
            "driver") ...{
          "vehicle_type":
              vehicleType ?? "",
          "vehicle_number":
              vehicleNumber ?? "",
          "license_number":
              licenseNumber ?? "",
        },
      };

      final response = await http
          .post(
            Uri.parse(
                registerEndpoint),
            headers: _headers,
            body:
                jsonEncode(body),
          )
          .timeout(
            const Duration(
                seconds: 20),
          );

      final data =
          _safeJsonDecode(
              response.body);

      if (response.statusCode ==
              200 ||
          response.statusCode ==
              201) {

        if (data["tokens"] !=
            null) {

          await saveTokens(
            data["tokens"]
                ["access"],
            data["tokens"]
                ["refresh"],
          );
        }

        if (data["user"] !=
            null) {

          await saveUserProfile(
            UserModel.fromJson(
              data["user"],
            ),
          );
        }

        return {
          "success": true,
          "message":
              data["message"] ??
                  "Registration successful",
          "data": data,
        };
      }

      return {
        "success": false,
        "message":
            _parseError(data),
      };

    } catch (e) {

      return {
        "success": false,
        "message":
            "Registration failed: ${e.toString()}",
      };
    }
  }

  // =========================================================
  // LOGIN
  // =========================================================

  // =========================================================
// LOGIN
// =========================================================

Future<Map<String, dynamic>>
    login({
  required String phoneNumber,
  required String password,
}) async {

  try {

    final response = await http
        .post(
          Uri.parse(
              loginEndpoint),
          headers: _headers,
          body: jsonEncode({
            "phone_number":
                phoneNumber.trim(),
            "password":
                password.trim(),
          }),
        )
        .timeout(
          const Duration(
              seconds: 20),
        );

    final data =
        _safeJsonDecode(
            response.body);

    if (response.statusCode ==
        200) {

      if (data["tokens"] !=
          null) {

        await saveTokens(
          data["tokens"]
              ["access"],
          data["tokens"]
              ["refresh"],
        );
      }

      if (data["user"] !=
          null) {

        await saveUserProfile(
          UserModel.fromJson(
            data["user"],
          ),
        );
      }

      return {
        "success": true,
        "message":
            data["message"] ??
                "Login successful",
        "data": data,
      };
    }

    return {
      "success": false,
      "message":
          _parseError(data),
    };

  } catch (e) {

    return {
      "success": false,
      "message":
          "Login failed: ${e.toString()}",
    };
  }
}
  // =========================================================
  // FORGOT PASSWORD
  // =========================================================

  Future<Map<String, dynamic>>
      forgotPassword({
    required String email,
  }) async {

    try {

      final response = await http
          .post(
            Uri.parse(
                forgotPasswordEndpoint),
            headers: _headers,
            body: jsonEncode({
              "email": email,
            }),
          )
          .timeout(
            const Duration(
                seconds: 20),
          );

      final data =
          _safeJsonDecode(
              response.body);

      if (response.statusCode ==
          200) {

        return {
          "success": true,
          "message":
              data["message"] ??
                  "OTP sent successfully",
        };
      }

      return {
        "success": false,
        "message":
            _parseError(data),
      };

    } catch (e) {

      return {
        "success": false,
        "message":
            "Forgot password failed",
      };
    }
  }

  // =========================================================
  // RESET PASSWORD
  // =========================================================

  Future<Map<String, dynamic>>
      resetPassword({
    required String email,
    required String token,
    required String newPassword,
    required String confirmNewPassword,
  }) async {

    try {

      final response = await http
          .post(
            Uri.parse(
                resetPasswordEndpoint),
            headers: _headers,
            body: jsonEncode({
              "email": email,
              "token": token,
              "new_password":
                  newPassword,
              "confirm_new_password":
                  confirmNewPassword,
            }),
          )
          .timeout(
            const Duration(
                seconds: 20),
          );

      final data =
          _safeJsonDecode(
              response.body);

      if (response.statusCode ==
          200) {

        return {
          "success": true,
          "message":
              data["message"] ??
                  "Password reset successful",
          "data": data,
        };
      }

      return {
        "success": false,
        "message":
            _parseError(data),
      };

    } catch (e) {

      return {
        "success": false,
        "message":
            "Reset password failed: ${e.toString()}",
      };
    }
  }

  // =========================================================
  // LOGOUT
  // =========================================================

  Future<void> logout() async {

    try {

      final refresh =
          await getRefreshToken();

      final headers =
          await _authHeaders;

      await http.post(
        Uri.parse(logoutEndpoint),
        headers: headers,
        body: jsonEncode({
          "refresh": refresh,
        }),
      );

    } finally {

      await clearTokens();
    }
  }

  // =========================================================
  // GET PROFILE
  // =========================================================

  Future<Map<String, dynamic>>
      getMe() async {

    try {

      final headers =
          await _authHeaders;

      final response = await http
          .get(
            Uri.parse(meEndpoint),
            headers: headers,
          );

      final data =
          _safeJsonDecode(
              response.body);

      if (response.statusCode ==
          200) {

        return {
          "success": true,
          "data": data,
        };
      }

      return {
        "success": false,
        "message":
            _parseError(data),
      };

    } catch (e) {

      return {
        "success": false,
        "message":
            "Failed to fetch profile",
      };
    }
  }

  // =========================================================
  // CHECK LOGIN
  // =========================================================

  Future<bool> isLoggedIn() async {

    final token =
        await getAccessToken();

    return token != null;
  }
}
