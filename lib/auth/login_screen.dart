// ignore_for_file: unused_local_variable, deprecated_member_use

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import '../services/auth_service.dart';
import 'signup_screen.dart';
import 'theme.dart';
import '../widgets/theme_toggle_button.dart';

// Simple Math CAPTCHA Widget
class MathCaptcha extends StatefulWidget {
  final Function(bool, String) onVerified;
  
  const MathCaptcha({super.key, required this.onVerified});
  
  @override
  State<MathCaptcha> createState() => _MathCaptchaState();
}

class _MathCaptchaState extends State<MathCaptcha> {
  int num1 = 0;
  int num2 = 0;
  int result = 0;
  final TextEditingController _answerController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _generateNewQuestion();
  }
  
  void _generateNewQuestion() {
    setState(() {
      num1 = Random().nextInt(20) + 1;
      num2 = Random().nextInt(20) + 1;
      result = num1 + num2;
    });
    _answerController.clear();
  }
  
  void _verify() {
    final answer = int.tryParse(_answerController.text.trim());
    if (answer == result) {
      String token = "math_captcha_${DateTime.now().millisecondsSinceEpoch}_$result";
      widget.onVerified(true, token);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Incorrect answer. Please try again!'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      _generateNewQuestion();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.grey[100],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppTheme.gold.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Text(
                'Security Verification',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.gold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Please solve this math problem to continue:',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.gold,
                    width: 2,
                  ),
                ),
                child: Text(
                  '$num1 + $num2 = ?',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _answerController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: isDark ? Colors.white : Colors.black87,
                ),
                decoration: InputDecoration(
                  hintText: 'Enter your answer',
                  hintStyle: TextStyle(
                    color: isDark ? Colors.white38 : Colors.black38,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDark ? Colors.white24 : Colors.black26,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppTheme.gold, width: 2),
                  ),
                  filled: true,
                  fillColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _verify,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.gold,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Verify',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  
  final _auth = AuthService();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _goToHome() => Navigator.pushReplacementNamed(context, '/home');
  void _goToSignUp() => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const SignUpScreen()));
  void _goToForgotPassword() => Navigator.pushNamed(context, '/forgot-password');

  Future<void> _handleLogin() async {
    final phoneNumber = _phoneController.text.trim();
    final password = _passwordController.text.trim();
    
    if (phoneNumber.isEmpty) {
      _showError('Please enter your phone number');
      return;
    }
    
    if (password.isEmpty) {
      _showError('Please enter your password');
      return;
    }
    
    setState(() => _isLoading = true);
    
    try {
      final result = await _auth.login(
        phoneNumber: phoneNumber,
        password: password,
      );
      
      if (!mounted) return;
      
      if (result['requires_captcha'] == true) {
        setState(() => _isLoading = false);
        _showCaptchaDialog(phoneNumber, password);
        return;
      }
      
      setState(() => _isLoading = false);
      
      if (result['success'] == true) {
        _showSuccess('Login successful!');
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) _goToHome();
        });
      } else {
        String errorMessage = result['message'] ?? 'Login failed';
        
        if (result['remaining_attempts'] != null && result['remaining_attempts'] > 0) {
          errorMessage = '${result['message']}\n${result['remaining_attempts']} attempts remaining.';
        }
        
        if (result['lockout_seconds'] != null && result['lockout_seconds'] > 0) {
          final minutes = (result['lockout_seconds'] / 60).floor();
          errorMessage = 'Too many failed attempts.\nPlease try again in $minutes minutes.';
        }
        
        if (result['error_type'] == 'account_not_found') {
          errorMessage = 'No account found with this phone number.\nPlease sign up first.';
        }
        
        _showError(errorMessage);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showError('Connection error: Unable to reach server.\nPlease check your internet connection.');
      debugPrint('Login error: $e');
    }
  }

  void _showCaptchaDialog(String phoneNumber, String password) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Security Verification'),
          content: MathCaptcha(
            onVerified: (success, token) async {
              Navigator.of(context).pop();
              if (success) {
                await _retryLoginWithCaptcha(phoneNumber, password, token);
              } else {
                _showError('Verification failed. Please try again.');
              }
            },
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        );
      },
    );
  }

  Future<void> _retryLoginWithCaptcha(
    String phoneNumber,
    String password,
    String captchaToken,
  ) async {
    setState(() => _isLoading = true);
    
    try {
      final result = await _auth.login(
        phoneNumber: phoneNumber,
        password: password,
        captchaToken: captchaToken,
      );
      
      if (!mounted) return;
      setState(() => _isLoading = false);
      
      if (result['success'] == true) {
        _showSuccess('Login successful!');
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) _goToHome();
        });
      } else {
        String errorMessage = result['message'] ?? 'Login failed';
        
        if (result['remaining_attempts'] != null && result['remaining_attempts'] > 0) {
          errorMessage = '${result['message']}\n${result['remaining_attempts']} attempts remaining.';
        }
        
        if (result['lockout_seconds'] != null && result['lockout_seconds'] > 0) {
          final minutes = (result['lockout_seconds'] / 60).floor();
          errorMessage = 'Too many failed attempts.\nPlease try again in $minutes minutes.';
        }
        
        _showError(errorMessage);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showError('Login failed: ${e.toString()}');
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);
    
    try {
      final result = await _auth.signInWithGoogle();
      
      if (!mounted) return;
      setState(() => _isLoading = false);
      
      if (result['success'] == true) {
        _showSuccess(result['message'] ?? 'Google sign in successful!');
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) _goToHome();
        });
      } else {
        _showError(result['message'] ?? 'Google sign in failed. Please try again.');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showError('Google sign in error: ${e.toString()}');
    }
  }

  Future<void> _handleAppleSignIn() async {
    setState(() => _isLoading = true);
    
    try {
      final result = await _auth.signInWithApple();
      
      if (!mounted) return;
      setState(() => _isLoading = false);
      
      if (result['success'] == true) {
        _showSuccess(result['message'] ?? 'Apple sign in successful!');
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) _goToHome();
        });
      } else {
        _showError(result['message'] ?? 'Apple sign in failed. Please try again.');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showError('Apple sign in error: ${e.toString()}');
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, textAlign: TextAlign.center),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showSuccess(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, textAlign: TextAlign.center),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Top Logo Banner
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: size.height * 0.45,
            child: Container(
              color: isDark ? const Color(0xFF1A1A1A) : AppTheme.gold.withOpacity(0.1),
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 20,
                bottom: 60,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Image.asset(
                        'assets/images/fuel.png',
                        fit: BoxFit.contain,
                        width: size.width * 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Log in to your account',
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Theme Toggle
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: 16,
            child: const CustomThemeToggle(
              iconColor: Colors.white,
              bgColor: Colors.black26,
            ),
          ),

          // Form Container
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: size.height * 0.65,
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
              
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Phone Number Field
                    _buildLabel('Phone Number', theme),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _phoneController,
                      hintText: '+256 744 000 000',
                      theme: theme,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 20),

                    // Password Field
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildLabel('Password', theme),
                        GestureDetector(
                          onTap: _goToForgotPassword,
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: AppTheme.gold,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _passwordController,
                      hintText: '••••••••',
                      theme: theme,
                      obscureText: _obscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                          color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5),
                        ),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Remember Me
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Remember me next time',
                          style: TextStyle(color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6), fontSize: 13),
                        ),
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Checkbox(
                            value: _rememberMe,
                            onChanged: (val) => setState(() => _rememberMe = val ?? false),
                            activeColor: AppTheme.gold,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Login Button
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.gold,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                          elevation: 0,
                        ),
                        child: _isLoading 
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Text('Log in', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Divider
                    Row(
                      children: [
                        Expanded(child: Divider(color: theme.dividerColor)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text('or', style: TextStyle(color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5))),
                        ),
                        Expanded(child: Divider(color: theme.dividerColor)),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Social Buttons
                    Row(
                      children: [
                        Expanded(
                          child: _SocialButton(
                            label: 'Google Play',
                            icon: const _GoogleIcon(),
                            theme: theme,
                            onPressed: _handleGoogleSignIn,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _SocialButton(
                            label: 'Apple Store',
                            icon: _AppleIcon(isDark: isDark),
                            theme: theme,
                            onPressed: _handleAppleSignIn,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Sign up
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Don\'t have an account? ', style: TextStyle(color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6), fontSize: 13)),
                        GestureDetector(
                          onTap: _goToSignUp,
                          child: const Text('Sign up', style: TextStyle(color: AppTheme.gold, fontSize: 13, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text, ThemeData theme) {
    return Text(
      text,
      style: TextStyle(
        color: theme.textTheme.bodyLarge?.color,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required ThemeData theme,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
  }) {
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : AppTheme.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: TextStyle(color: theme.textTheme.bodyLarge?.color),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: theme.textTheme.bodyMedium?.color?.withOpacity(0.4)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String label;
  final Widget icon;
  final ThemeData theme;
  final VoidCallback onPressed;

  const _SocialButton({required this.label, required this.icon, required this.theme, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    
    final isDark = theme.brightness == Brightness.dark;
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(25),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: theme.dividerColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: theme.textTheme.bodyLarge?.color,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GoogleIcon extends StatelessWidget {
  const _GoogleIcon();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 18, height: 18,
      child: CustomPaint(painter: _GooglePainter()),
    );
  }
}

class _GooglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2;
    canvas.drawCircle(Offset(cx, cy), r, Paint()..color = const Color.fromARGB(255, 253, 251, 251));
    const segments = [(0.0, 1.57, Color(0xFF4285F4)), (1.57, 3.14, Color(0xFF34A853)), (3.14, 4.71, Color(0xFFFBBC05)), (4.71, 6.28, Color(0xFFEA4335))];
    for (final seg in segments) {
      canvas.drawArc(Rect.fromCircle(center: Offset(cx, cy), radius: r * 0.7), seg.$1, seg.$2 - seg.$1, false, Paint()..color = seg.$3..style = PaintingStyle.stroke..strokeWidth = size.width * 0.2);
    }
    canvas.drawCircle(Offset(cx, cy), r * 0.45, Paint()..color = Colors.white);
    canvas.drawLine(Offset(cx, cy), Offset(cx + r * 0.65, cy), Paint()..color = const Color(0xFF4285F4)..strokeWidth = size.height * 0.18..strokeCap = StrokeCap.round);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _AppleIcon extends StatelessWidget {
  final bool isDark;
  const _AppleIcon({required this.isDark});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 18, height: 18,
      child: CustomPaint(painter: _ApplePainter(isDark: isDark)),
    );
  }
}

class _ApplePainter extends CustomPainter {
  final bool isDark;
  _ApplePainter({required this.isDark});
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    final color = isDark ? Colors.white : Colors.black;
    path.moveTo(size.width * 0.5, size.height * 0.15);
    path.cubicTo(size.width * 0.5, size.height * 0.15, size.width * 0.42, size.height * 0.05, size.width * 0.3, size.height * 0.08);
    path.cubicTo(size.width * 0.18, size.height * 0.11, size.width * 0.12, size.height * 0.25, size.width * 0.15, size.height * 0.38);
    path.cubicTo(size.width * 0.18, size.height * 0.51, size.width * 0.32, size.height * 0.62, size.width * 0.45, size.height * 0.6);
    path.cubicTo(size.width * 0.58, size.height * 0.58, size.width * 0.7, size.height * 0.48, size.width * 0.72, size.height * 0.4);
    path.cubicTo(size.width * 0.74, size.height * 0.32, size.width * 0.68, size.height * 0.22, size.width * 0.58, size.height * 0.2);
    path.cubicTo(size.width * 0.48, size.height * 0.18, size.width * 0.5, size.height * 0.15, size.width * 0.5, size.height * 0.15);
    path.close();
    path.moveTo(size.width * 0.58, size.height * 0.18);
    path.cubicTo(size.width * 0.65, size.height * 0.12, size.width * 0.75, size.height * 0.1, size.width * 0.8, size.height * 0.15);
    path.cubicTo(size.width * 0.85, size.height * 0.2, size.width * 0.78, size.height * 0.3, size.width * 0.7, size.height * 0.32);
    path.close();
    canvas.drawPath(path, Paint()..color = color);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}