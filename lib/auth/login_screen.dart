import 'package:flutter/material.dart';
import 'dart:async';
import '../services/auth_service.dart';
import 'signup_screen.dart';
import 'theme.dart'; // ✅ Import theme system

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
  bool _isLoading = false;

  // Regex for Phone only
  static final _phoneRegex = RegExp(
    r'^\+\d{1,4}[\s\-]?\d{3}[\s\-]?\d{3}[\s\-]?\d{3,4}$',
  );

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _goToHome() => Navigator.pushReplacementNamed(context, '/home');
  void _goToSignUp() => Navigator.pushNamed(context, '/signup');
  void _goToForgotPassword() => Navigator.pushNamed(context, '/forgot-password');

  Future<void> _handleLogin() async {
    final phone = _phoneController.text.trim();
    final password = _passwordController.text.trim();

    if (phone.isEmpty || password.isEmpty) {
      _showError('All fields are required');
      return;
    }

    if (!_phoneRegex.hasMatch(phone)) {
      _showError('Please enter a valid phone number (e.g. +256 744 000 000)');
      return;
    }

    setState(() => _isLoading = true);
    try {
      final result = await _auth
          .login(phoneNumber: phone, password: password)
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () => throw TimeoutException('Connection timed out'),
          );

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (result['success'] == true) {
        _goToHome();
      } else {
        _showError(result['message'] ?? 'Login failed. Please try again.');
      }
    } on TimeoutException {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showError('Request timed out. Check your internet connection.');
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showError('An error occurred: ${e.toString()}');
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.iconTheme.color),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacementNamed(context, '/onboarding');
            }
          },
        ),
        actions: const [
          ThemeToggleButton(),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Column(
            children: [
              // ============================================================
              // LAYER 1: Logo Section (Top)
              // ============================================================
              const FuelConnectLogo(fontSize: 20),
              const SizedBox(height: 12),
              Text(
                'FUEL CONNECT PORTAL',
                style: TextStyle(
                  color: theme.textTheme.bodyMedium?.color,
                  fontSize: 10,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 32),

              // ============================================================
              // LAYER 2: Login Form
              // ============================================================
              Container(
                constraints: const BoxConstraints(maxWidth: 400),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: theme.dividerColor),
                  boxShadow: [
                    BoxShadow(
                      color: isDark ? Colors.black.withOpacity(0.4) : Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Welcome back',
                      style: TextStyle(
                        color: theme.textTheme.bodyLarge?.color,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Please enter your phone number and password.',
                      style: TextStyle(
                        color: theme.textTheme.bodyMedium?.color,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Phone Field
                    _buildLabel('PHONE NUMBER', theme),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _phoneController,
                      hintText: '+256 744 000 000',
                      prefixIcon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      theme: theme,
                    ),
                    const SizedBox(height: 18),

                    // Password Field
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildLabel('PASSWORD', theme),
                        GestureDetector(
                          onTap: _goToForgotPassword,
                          child: const Text(
                            'FORGOT PASSWORD?',
                            style: TextStyle(
                              color: AppTheme.gold,
                              fontSize: 10,
                              letterSpacing: 1.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _passwordController,
                      hintText: '••••••••',
                      prefixIcon: Icons.lock_outline,
                      obscureText: _obscurePassword,
                      theme: theme,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                          size: 18,
                        ),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Login Button
                    GoldButton(
                      text: _isLoading ? 'LOGGING IN...' : 'LOG IN',
                      onPressed: _isLoading ? () {} : _handleLogin,
                    ),
                    const SizedBox(height: 24),

                    // Divider
                    Row(
                      children: [
                        Expanded(child: Divider(color: theme.dividerColor, thickness: 1)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            'OR CONTINUE WITH',
                            style: TextStyle(
                              color: theme.textTheme.bodyMedium?.color,
                              fontSize: 10,
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Expanded(child: Divider(color: theme.dividerColor, thickness: 1)),
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
                            theme: theme,
                            onPressed: _handleGoogleSignIn,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _SocialButton(
                            label: 'APPLE',
                            icon: _AppleIcon(isDark: isDark),
                            theme: theme,
                            onPressed: _handleAppleSignIn,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // ============================================================
              // LAYER 3: Create Account (Bottom)
              // ============================================================
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: TextStyle(
                      color: theme.textTheme.bodyMedium?.color,
                      fontSize: 13,
                    ),
                  ),
                  GestureDetector(
                    onTap: _goToSignUp,
                    child: const Text(
                      'Create Account',
                      style: TextStyle(
                        color: AppTheme.gold,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
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
    );
  }

  Widget _buildLabel(String text, ThemeData theme) {
    return Text(
      text,
      style: TextStyle(
        color: theme.textTheme.bodyMedium?.color,
        fontSize: 10,
        letterSpacing: 1.2,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    required ThemeData theme,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    final isDark = theme.brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF0F0F0);

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: theme.dividerColor),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        style: TextStyle(color: theme.textTheme.bodyLarge?.color, fontSize: 14),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5), fontSize: 14),
          prefixIcon: Icon(prefixIcon, color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6), size: 20),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
// Custom UI Components
// ─────────────────────────────────────────────────────────────────────

class _SocialButton extends StatelessWidget {
  final String label;
  final Widget icon;
  final ThemeData theme;
  final VoidCallback? onPressed;

  const _SocialButton({
    required this.label,
    required this.icon,
    required this.theme,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = theme.brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF0F0F0);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 44,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(10),
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
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
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
      width: 18,
      height: 18,
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
  final bool isDark;
  const _AppleIcon({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 18,
      height: 18,
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

    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}