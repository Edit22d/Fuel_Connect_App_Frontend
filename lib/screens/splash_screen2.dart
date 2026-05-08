import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../auth/login_screen.dart';
// import '../auth/signup_screen.dart'; // ✅ Added import for Sign Up
import 'home_screen.dart';

class SplashScreen2 extends StatefulWidget {
  const SplashScreen2({super.key});

  @override
  State<SplashScreen2> createState() => _SplashScreen2State();
}

class _SplashScreen2State extends State<SplashScreen2> {
  
  final _auth = AuthService();

  String _tagline = 'Always On Demand';
  String _description =
      'No more waiting in lines. Our \n professional fleet delivers high-\n quality fuel directly to your location, wherever \n you need it.';
      
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadAppInfo();
  }

  Future<void> _loadAppInfo() async {
    final result = await _auth.getAppInfo();
    
    if (result['success'] && mounted) {
      setState(() {
        _tagline     = result['data']['tagline'] ?? _tagline;
        _description = result['data']['description'] ?? _description;
      });
    }
  }

  // ✅ Updated: Bypass login/signup and go directly to Home Screen
  Future<void> _handleGetStarted() async {
    if (!mounted) return;
    
    // User is automatically taken to the Home Screen without login
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  // ✅ Updated: Check login status. 
  // If Logged In -> Home. 
  // If Not -> Go to Login Screen.
  Future<void> _goToLogin() async {
    final loggedIn = await _auth.isLoggedIn();
    
    if (!mounted) return;

    if (loggedIn) {
      // Skip login screen if already authenticated
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

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

                Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 150,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => 
                        const Icon(Icons.local_gas_station, size: 80, color: Colors.white), 
                  ),
                ),

                const SizedBox(height: 18),

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
                        errorBuilder: (context, error, stackTrace) => 
                            const Icon(Icons.directions_car, size: 150, color: Colors.grey), 
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

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
                          color: Color(0xFFC4963D),
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

                Text(
                  _description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFFAAAAAA),
                    fontSize: 13,
                    height: 1.6,
                    fontWeight: FontWeight.w400,
                  ),
                ),

                const SizedBox(height: 28),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildTag('Premium Fuel'),
                      const SizedBox(width: 12),
                      _buildTag('Fast Delivery'),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleGetStarted,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFC4963D),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : const Text(
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
                      onTap: _goToLogin, // ✅ Now calls the async check
                      child: const Text(
                        'Log in',
                        style: TextStyle(
                          color: Color(0xFFC4963D),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFFC4963D)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFFC4963D),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}