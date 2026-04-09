import 'package:flutter/material.dart';
import '/screens/splash_screen2.dart';

class SplashScreen1 extends StatelessWidget {
  const SplashScreen1({super.key});

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1A1A1A),
              Color(0xFF0D0D0D),
              Color(0xFF000000),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top spacer
              const Spacer(flex: 3),
 
              // Logo centered
              Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 250,
                  fit: BoxFit.contain,
                ),
              ),

               const Spacer(flex: 1),

             

              const Spacer(flex: 3),

                   // Tagline
              const Text(
                'Fuel Delivery at Your Fingertips',
                style: TextStyle(
                  color: Color(0xFFB0B0B0),
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.3,
                ),
              ),
 
              const Spacer(flex: 4),
 
              // Next button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SplashScreen2(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFC8922A),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Next →',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
              ),
 
              
               const SizedBox(height: 40),
 
              // Bottom page indicator dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 20,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFC8A84B),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    width: 8,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFF444444),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    width: 8,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFF444444),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
 
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
 