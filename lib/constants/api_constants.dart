class ApiConstants {
  static const String baseUrl = 'http://127.0.0.1:8000/api/v1';

  static const String appInfo       = '$baseUrl/auth/info/';
  static const String register      = '$baseUrl/auth/register/';
  static const String login         = '$baseUrl/auth/login/';
  static const String logout        = '$baseUrl/auth/logout/';
  static const String profile       = '$baseUrl/auth/profile/';
  static const String tokenRefresh  = '$baseUrl/auth/token/refresh/';
  static const String forgotPassword = '$baseUrl/auth/forgot-password/';
  static const String resetPassword  = '$baseUrl/auth/reset-password/';
  static const String changePassword = '$baseUrl/auth/change-password/';
  static const String socialAuth    = '$baseUrl/auth/social/';

 
  static const String social = socialAuth;
    
  static const String updateProfile = "$baseUrl/update-profile";
}