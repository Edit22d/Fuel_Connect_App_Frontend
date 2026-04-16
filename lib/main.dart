import 'package:flutter/material.dart';
import '/screens/splash_screen1.dart';
import '/screens/splash_screen2.dart';
import '/auth/login_screen.dart';
import '/auth/signup_screen.dart';
import '/screens/home_screen.dart';
import '/screens/station_screen.dart';
import '/screens/profile_screen.dart';
import '/screens/order_screen.dart';
import '/screens/support_screen.dart';
import '/password/forgot_password_screen.dart';
import '/password/otp_screen.dart';
import '/password/success_otp_screen.dart';
import '/password/otp_verify_screen.dart';





void main() {
  runApp(const FuelConnectApp());
}

class FuelConnectApp extends StatelessWidget {
  const FuelConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fuel Connect',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF0D0D0D),
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFFC8A84B),
          background: const Color(0xFF0D0D0D),
        ),
        fontFamily: 'sans-serif',
      ),
      initialRoute: '/',
      routes: {
        '/': (context) =>  SplashScreen1(),
     
      },
    );
  }
}
