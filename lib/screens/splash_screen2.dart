import 'package:flutter/material.dart';
import '/auth/login_screen.dart';
import '/screens/home_screen.dart';

class SplashScreen2 extends StatelessWidget {
  const SplashScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                const SizedBox(height: 10),

                // Top logo
                Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 150,
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: 18),

                // Car image
                Container(
                  width: double.infinity,
                  height: 350,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Image.asset(
                        'assets/images/car.png',
                        height: 350,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Headline text
                RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'Always ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                        ),
                      ),
                      TextSpan(
                        text: 'On\n',
                        style: TextStyle(
                          color: Color(0xFFC8A84B),
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                        ),
                      ),
                      TextSpan(
                        text: 'Demand',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Subtitle
                const Text(
                  'No more waiting in lines. Our \n professional fleet delivers high-\n quality fuel directly to your location, wherever \n you need it.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFAAAAAA),
                    fontSize: 13,
                    height: 1.6,
                    fontWeight: FontWeight.w400,
                  ),
                ),

                const SizedBox(height: 28),

                // Two inactive buttons row (Premium Fuel & Fast Delivery)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Premium Fuel button (inactive)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1E1E),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: const Color(0xFFC8A84B)),
                        ),
                        child: const Text(
                          'Premium Fuel',
                          style: TextStyle(
                            color: Color(0xFFC8A84B),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Fast Delivery button (inactive)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1E1E),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: const Color(0xFFC8A84B)),
                        ),
                        child: const Text(
                          'Fast Delivery',
                          style: TextStyle(
                            color: Color(0xFFC8A84B),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // Get Started button
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
                          builder: (context) => HomeScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFC8A84B),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Get Started',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
              ),

                  const SizedBox(height: 14),

                  // Login row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account? ',
                        style: TextStyle(
                          color: Color(0xFFAAAAAA),
                          fontSize: 12,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'Log in',
                          style: TextStyle(
                            color: Color(0xFFC8A84B),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 14),


                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  const _Tag({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF333333)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFFCCCCCC),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}