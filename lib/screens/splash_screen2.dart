import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../auth/login_screen.dart';
import 'home_screen.dart';
import '../auth/theme.dart';
import '../widgets/theme_toggle_button.dart';

class SplashScreen2 extends StatefulWidget {
  const SplashScreen2({super.key});

  @override
  State<SplashScreen2> createState() => _SplashScreen2State();
}

class _SplashScreen2State extends State<SplashScreen2> {
  final _auth = AuthService();
  bool _isLoading = false;
  bool _isCheckingLogin = true;

  @override
  void initState() {
    super.initState();
    _checkAutoLogin();
  }

  Future<void> _checkAutoLogin() async {
    // Wait a moment for splash screen to show
    await Future.delayed(const Duration(seconds: 1));
    
    if (!mounted) return;
    
    final isLoggedIn = await _auth.isLoggedIn();
    
    if (!mounted) return;
    
    setState(() {
      _isCheckingLogin = false;
    });
    
    if (isLoggedIn) {
      // User is already logged in - auto navigate to home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  Future<void> _handleGetStarted() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    final loggedIn = await _auth.isLoggedIn();

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (loggedIn) {
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    // Show loading while checking login status
    if (_isCheckingLogin) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/fuel.png',
                width: 100,
                height: 100,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.local_gas_station,
                  size: 80,
                  color: AppTheme.gold,
                ),
              ),
              const SizedBox(height: 20),
              const CircularProgressIndicator(
                color: AppTheme.gold,
              ),
              const SizedBox(height: 20),
              Text(
                'Fuel Connect',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.bodyLarge?.color,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Top Full Image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: size.height * 0.55,
            child: Image.asset(
              'assets/images/shell_station.png',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.grey[300],
                child: const Icon(Icons.local_gas_station, size: 80, color: Colors.grey),
              ),
            ),
          ),

          // Theme Toggle at Top Right safely padded
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: 16,
            child: const CustomThemeToggle(
              iconColor: Colors.white,
              bgColor: Colors.black26,
            ),
          ),

          // Bottom Card
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: size.height * 0.50,
            child: Container(
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        'Real-Time Prices. Smarter\nFueling Decisions',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: theme.textTheme.bodyLarge?.color,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'A smart fuel tracker with advanced features that you\ncan control from a mobile application',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: theme.textTheme.bodyMedium?.color,
                          fontSize: 13,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),

                  // Dots Indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildDot(true),
                      const SizedBox(width: 6),
                      _buildDot(false),
                      const SizedBox(width: 6),
                      _buildDot(false),
                    ],
                  ),

                  // Get Started Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleGetStarted,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.gold,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : Stack(
                              alignment: Alignment.center,
                              children: [
                                const Center(
                                  child: Text(
                                    'Get Started',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.arrow_forward,
                                      color: AppTheme.gold,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(bool isActive) {
    return Container(
      width: isActive ? 20 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? AppTheme.gold : Colors.grey.withOpacity(0.3),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}