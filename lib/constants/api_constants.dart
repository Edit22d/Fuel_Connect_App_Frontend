class ApiConstants {
  // ✅ Use 10.0.2.2 for Android emulator | 127.0.0.1 for web/iOS simulator | 192.168.X.X for physical device
  static const String baseUrl = 'http://10.0.2.2:8000/api/v1';

  static const String appInfo        = '$baseUrl/auth/info/';
  static const String register       = '$baseUrl/auth/register/';
  static const String login          = '$baseUrl/auth/login/';
  static const String logout         = '$baseUrl/auth/logout/';
  static const String me             = '$baseUrl/auth/me/';
  static const String profile        = '$baseUrl/auth/profile/';
  static const String tokenRefresh   = '$baseUrl/auth/token/refresh/';
  static const String forgotPassword = '$baseUrl/auth/forgot-password/';
  static const String resetPassword  = '$baseUrl/auth/reset-password/';
  static const String socialAuth     = '$baseUrl/auth/social/';
  static const String social         = socialAuth;
  static const String updateProfile  = '$baseUrl/auth/update-profile/';
}