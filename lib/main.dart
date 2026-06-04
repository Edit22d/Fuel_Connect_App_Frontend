import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'auth/theme.dart'; // ✅ Import theme definitions
import 'services/auth_service.dart';
import 'screens/onboarding_screen.dart';
import 'screens/splash_screen2.dart';
import 'screens/home_screen.dart';
import 'screens/station_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/order_screen.dart';
import 'screens/support_screen.dart';
import 'auth/login_screen.dart';
import 'auth/signup_screen.dart';
import 'password/forgot_password_screen.dart';
import 'password/otp_screen.dart';
import 'password/otp_verify_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation to portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // ✅ Check if user is already logged in before showing any screen
  final authService = AuthService();
  final isLoggedIn = await authService.isLoggedIn();

  runApp(FuelConnectApp(isLoggedIn: isLoggedIn));
}

class FuelConnectApp extends StatelessWidget {
  final bool isLoggedIn;
  const FuelConnectApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, mode, child) {
        return MaterialApp(
          title: 'Fuel Connect',
          debugShowCheckedModeBanner: false,
          themeMode: mode,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          // ✅ Auto-login: go straight to HomeScreen if token is valid
          home: isLoggedIn ? const HomeScreen() : const OnboardingScreen(),
          routes: {
            '/onboarding':      (context) => const OnboardingScreen(),
            '/login':           (context) => const LoginScreen(),
            '/signup':          (context) => const SignUpScreen(),
            '/home':            (context) => const HomeScreen(),
            '/station':         (context) => const StationScreen(),
            '/profile':         (context) => const ProfileScreen(),
            '/orders':          (context) => const OrderScreen(),
            '/support':         (context) => const SupportScreen(),
            '/forgot-password': (context) => const ForgotPasswordScreen(),
            '/otp':             (context) => const OtpScreen(email: ''), // placeholder
          },
        );
      },
    );
  }
}