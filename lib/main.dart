import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fuel_app/auth/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'services/auth_service.dart';
import 'services/notification_service.dart';
import 'screens/onboarding_screen.dart';
import 'screens/splash_screen2.dart';
import 'screens/home_screen.dart';
import 'screens/station_screen.dart';
import 'screens/profile_screen.dart';
import 'payment/order_summary_screen.dart';
import 'screens/support_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/notification_screen.dart';
import 'screens/terms_screen.dart';
import 'auth/login_screen.dart';
import 'auth/signup_screen.dart';
import 'password/forgot_password_screen.dart';
import 'password/otp_screen.dart';
import 'password/otp_verify_screen.dart';
import 'screens/station_management.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation to portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Run app - OnboardingScreen will display first
  runApp(const FuelConnectApp());
}

class FuelConnectApp extends StatelessWidget {
  const FuelConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, mode, child) {
        return MaterialApp(
          title: 'Fuel Connect',
          debugShowCheckedModeBanner: false,
          scrollBehavior: const MaterialScrollBehavior().copyWith(
            dragDevices: {
              PointerDeviceKind.mouse,
              PointerDeviceKind.touch,
              PointerDeviceKind.trackpad,
            },
          ),
          themeMode: mode,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          initialRoute: '/onboarding', // Changed from '/' to '/onboarding'
          routes: {
            '/': (context) => const SplashScreen2(),
            '/onboarding': (context) => const OnboardingScreen(),
            '/login': (context) => const LoginScreen(),
            '/signup': (context) => const SignUpScreen(),
            '/home': (context) => const HomeScreen(),
            '/station': (context) => const StationScreen(),
            '/profile': (context) => const ProfileScreen(),
            '/orders': (context) => const OrderSummaryScreen(),
            '/support': (context) => const SupportScreen(),
            '/settings': (context) => const SettingsScreen(),
            '/notifications': (context) => const NotificationScreen(),
            '/terms': (context) => const TermsScreen(section: 'terms'),
            '/privacy': (context) => const TermsScreen(section: 'privacy'),
            '/forgot-password': (context) => const ForgotPasswordScreen(),
            '/otp': (context) => const OtpScreen(email: ''),
            '/otp-verify': (context) => const OtpVerifyScreen(email: '', otp: ''),
            '/station-management': (context) => const StationManagementScreen(),
          },
          builder: (context, child) {
            return NotificationPopupOverlay(child: child!);
          },
        );
      },
    );
  }
}

// Notification Popup Overlay Widget
class NotificationPopupOverlay extends StatelessWidget {
  final Widget child;
  
  const NotificationPopupOverlay({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        // You can add notification overlay widgets here
      ],
    );
  }
}