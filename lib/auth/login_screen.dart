import 'package:flutter/material.dart';
import 'dart:async';
import '../services/auth_service.dart';
import 'signup_screen.dart';
import '../screens/home_screen.dart';
import '../password/forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  static final _emailOrPhoneRegex = RegExp(
    r'^(\+\d{1,4}[\s\-]?\d{3}[\s\-]?\d{3}[\s\-]?\d{3,4}|[^@]+@[^@]+\.[^@]+)$',
  );
  static final _passwordRegex = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$',
  );

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _goToHome() => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );

  void _goToSignUp() => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SignUpScreen()),
      );

  void _goToForgotPassword() => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
      );

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty && password.isEmpty) {
      _showError('Please enter credentials before continuing');
      return;
    }
    if (email.isEmpty || password.isEmpty) {
      _showError('All fields are required');
      return;
    }
    if (!_emailOrPhoneRegex.hasMatch(email) ||
        !_passwordRegex.hasMatch(password)) {
      _showError('Invalid credentials, please enter correct credentials');
      return;
    }

    setState(() => _isLoading = true);
    try {
      final result = await _auth
          .login(emailOrPhone: email, password: password)
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw TimeoutException('Timed out'),
          );

      if (!mounted) return;
      setState(() => _isLoading = false);

      result['success'] == true
          ? _goToHome()
          : _showError(result['message'] ?? 'Login failed.');
    } on TimeoutException {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showError('Login took too long. Please try again.');
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showError('An error occurred. Please try again.');
    }
  }

  Future<void> _handleGoogleSignIn() async {
    _showError('Google Sign-In coming soon!');
  }

  Future<void> _handleAppleSignIn() async {
    _showError('Apple Sign-In coming soon!');
  }

  void _showError(String msg) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: SafeArea(
        child: Column(
          children: [
            // ============================================================
            // LAYER 1: Logo Section (Top)
            // ============================================================
            Padding(
              padding: const EdgeInsets.only(top: 32),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    width: 80,
                    height: 80,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.local_gas_station,
                      size: 60,
                      color: Color(0xFFC8A84B),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'FUEL CONNECT PORTAL',
                    style: TextStyle(
                      color: Color(0xFF888888),
                      fontSize: 10,
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ============================================================
            // LAYER 2: Login Card (Center - Flexible)
            // ============================================================
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 400),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF141414),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF2A2A2A)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Welcome Section
                      const Text(
                        'Welcome back',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Please enter valid credentials!.',
                        style: TextStyle(
                          color: Color(0xFF888888),
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Phone Field
                      const Text(
                        'PHONE',
                        style: TextStyle(
                          color: Color(0xFF888888),
                          fontSize: 10,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      _buildTextField(
                        controller: _emailController,
                        hintText: 'Enter your phone number',
                        prefixIcon: Icons.phone,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 16),

                      // Password Field
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'PASSWORD',
                            style: TextStyle(
                              color: Color(0xFF888888),
                              fontSize: 10,
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          GestureDetector(
                            onTap: _goToForgotPassword,
                            child: const Text(
                              'FORGOT PASSWORD?',
                              style: TextStyle(
                                color: Color(0xFFC8A84B),
                                fontSize: 10,
                                letterSpacing: 1.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      _buildTextField(
                        controller: _passwordController,
                        hintText: '••••••••',
                        prefixIcon: Icons.lock_outline,
                        obscureText: _obscurePassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: const Color(0xFF666666),
                            size: 18,
                          ),
                          onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Login Button
                      _YellowButton(
                        isLoading: _isLoading,
                        onPressed: _isLoading ? null : _handleLogin,
                      ),
                      const SizedBox(height: 20),

                      // Divider
                      Row(
                        children: const [
                          Expanded(
                            child: Divider(color: Color(0xFF2A2A2A), thickness: 1),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              'OR CONTINUE WITH',
                              style: TextStyle(
                                color: Color(0xFF555555),
                                fontSize: 9,
                                letterSpacing: 1.2,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(color: Color(0xFF2A2A2A), thickness: 1),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Social Login Buttons
                      Row(
                        children: [
                          Expanded(
                            child: _SocialButton(
                              label: 'GOOGLE',
                              icon: const _GoogleIcon(),
                              onPressed: _handleGoogleSignIn,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _SocialButton(
                              label: 'APPLE',
                              icon: const _AppleIcon(),
                              onPressed: _handleAppleSignIn,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ============================================================
            // LAYER 3: Create Account (Bottom)
            // ============================================================
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account? ",
                    style: TextStyle(
                      color: Color(0xFF888888),
                      fontSize: 12,
                    ),
                  ),
                  GestureDetector(
                    onTap: _goToSignUp,
                    child: const Text(
                      'Create Account',
                      style: TextStyle(
                        color: Color(0xFFC8A84B),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        style: const TextStyle(color: Colors.white, fontSize: 13),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Color(0xFF555555), fontSize: 13),
          prefixIcon: Icon(prefixIcon, color: const Color(0xFF666666), size: 18),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        ),
      ),
    );
  }
}

class _YellowButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;

  const _YellowButton({this.onPressed, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 44,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFC8A84B),
          foregroundColor: Colors.white,
          disabledBackgroundColor: const Color(0xFFC8A84B).withOpacity(0.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'LOG IN',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(width: 6),
                ],
              ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String label;
  final Widget icon;
  final VoidCallback? onPressed;

  const _SocialButton({
    required this.label,
    required this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF2A2A2A)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
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
      width: 16,
      height: 16,
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

    canvas.drawCircle(Offset(cx, cy), r, Paint()..color = Colors.white);

    const segments = [
      (0.0, 1.57, Color(0xFF4285F4)),
      (1.57, 3.14, Color(0xFF34A853)),
      (3.14, 4.71, Color(0xFFFBBC05)),
      (4.71, 6.28, Color(0xFFEA4335)),
    ];
    for (final seg in segments) {
      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: r * 0.7),
        seg.$1,
        seg.$2 - seg.$1,
        false,
        Paint()
          ..color = seg.$3
          ..style = PaintingStyle.stroke
          ..strokeWidth = size.width * 0.2,
      );
    }

    canvas.drawCircle(Offset(cx, cy), r * 0.45, Paint()..color = Colors.white);

    canvas.drawLine(
      Offset(cx, cy),
      Offset(cx + r * 0.65, cy),
      Paint()
        ..color = const Color(0xFF4285F4)
        ..strokeWidth = size.height * 0.18
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _AppleIcon extends StatelessWidget {
  const _AppleIcon();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 16,
      height: 16,
      child: CustomPaint(painter: _ApplePainter()),
    );
  }
}

class _ApplePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    
    path.moveTo(size.width * 0.5, size.height * 0.15);
    path.cubicTo(
      size.width * 0.5, size.height * 0.15,
      size.width * 0.42, size.height * 0.05,
      size.width * 0.3, size.height * 0.08,
    );
    path.cubicTo(
      size.width * 0.18, size.height * 0.11,
      size.width * 0.12, size.height * 0.25,
      size.width * 0.15, size.height * 0.38,
    );
    path.cubicTo(
      size.width * 0.18, size.height * 0.51,
      size.width * 0.32, size.height * 0.62,
      size.width * 0.45, size.height * 0.6,
    );
    path.cubicTo(
      size.width * 0.58, size.height * 0.58,
      size.width * 0.7, size.height * 0.48,
      size.width * 0.72, size.height * 0.4,
    );
    path.cubicTo(
      size.width * 0.74, size.height * 0.32,
      size.width * 0.68, size.height * 0.22,
      size.width * 0.58, size.height * 0.2,
    );
    path.cubicTo(
      size.width * 0.48, size.height * 0.18,
      size.width * 0.5, size.height * 0.15,
      size.width * 0.5, size.height * 0.15,
    );
    path.close();

    path.moveTo(size.width * 0.58, size.height * 0.18);
    path.cubicTo(
      size.width * 0.65, size.height * 0.12,
      size.width * 0.75, size.height * 0.1,
      size.width * 0.8, size.height * 0.15,
    );
    path.cubicTo(
      size.width * 0.85, size.height * 0.2,
      size.width * 0.78, size.height * 0.3,
      size.width * 0.7, size.height * 0.32,
    );
    path.close();

    canvas.drawPath(
      path,
      Paint()..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}