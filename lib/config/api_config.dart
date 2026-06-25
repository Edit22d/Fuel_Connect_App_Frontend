// lib/config/api_config.dart
class ApiConfig {
  // Development
  static const String devBaseUrl = 'http://127.0.0.1:8000';
  
  // For Android emulator, use 10.0.2.2
  // static const String devBaseUrl = 'http://10.0.2.2:8000';
  
  // For physical device, use your computer's IP address
  // static const String devBaseUrl = 'http://192.168.1.100:8000';
  
  // Production URL
  static const String prodBaseUrl = 'https://your-domain.com';
  
  // Environment switch (true = development, false = production)
  static const bool isDevelopment = true;
  
  static String get baseUrl {
    if (isDevelopment) {
      return devBaseUrl;
    } else {
      return prodBaseUrl;
    }
  }
  
  // Media URL for images
  static String get mediaUrl => '$baseUrl/media/';
  
  // API endpoints
  static const String apiVersion = 'api';
  
  static String get stationsEndpoint => '$baseUrl/$apiVersion/stations/';
  static String get stationsManageEndpoint => '$baseUrl/$apiVersion/stations/manage/';
  static String get topStationsEndpoint => '$baseUrl/$apiVersion/stations/top/';
  static String get dashboardEndpoint => '$baseUrl/$apiVersion/dashboard/';
  static String get ordersEndpoint => '$baseUrl/$apiVersion/orders/';
  static String get paymentsEndpoint => '$baseUrl/$apiVersion/payments/';
  static String get notificationsEndpoint => '$baseUrl/$apiVersion/notifications/';
  static String get usersEndpoint => '$baseUrl/$apiVersion/users/';
  static String get authLoginEndpoint => '$baseUrl/$apiVersion/auth/login/';
  static String get authRegisterEndpoint => '$baseUrl/$apiVersion/auth/register/';
  static String get authLogoutEndpoint => '$baseUrl/$apiVersion/auth/logout/';
  static String get authRefreshEndpoint => '$baseUrl/$apiVersion/auth/refresh/';
  static String get authForgotPasswordEndpoint => '$baseUrl/$apiVersion/auth/forgot-password/';
  static String get authResetPasswordEndpoint => '$baseUrl/$apiVersion/auth/reset-password/';
  static String get authSocialEndpoint => '$baseUrl/$apiVersion/auth/social/';
}