import 'package:flutter/material.dart';
import 'dart:async';
import '../services/auth_service.dart';
import 'login_screen.dart';
import 'theme.dart';
import '../widgets/theme_toggle_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _auth = AuthService();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _referralController = TextEditingController();
  final TextEditingController _vehicleTypeController = TextEditingController();
  final TextEditingController _vehicleNumberController = TextEditingController();
  final TextEditingController _licenseController = TextEditingController();

  String _userType = "customer";
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = false;
  bool _isLoading = false;

  static final _nameRegex = RegExp(r"^[a-zA-Z]+(?: [a-zA-Z]+)+$");
  static final _phoneRegex = RegExp(r"^\+\d{1,4}[\s\-]?\d{3}[\s\-]?\d{3}[\s\-]?\d{3,4}$");
  static final _passRegex = RegExp(r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$");

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _locationController.dispose();
    _referralController.dispose();
    _vehicleTypeController.dispose();
    _vehicleNumberController.dispose();
    _licenseController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    final fullName = _fullNameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();
    final location = _locationController.text.trim();

    if (fullName.isEmpty || email.isEmpty || phone.isEmpty || password.isEmpty || confirmPassword.isEmpty || location.isEmpty) {
      _showError('Please fill in all required fields');
      return;
    }
    if (password != confirmPassword) {
      _showError('Passwords do not match');
      return;
    }
    if (password.length < 8) {
      _showError('Password must be at least 8 characters');
      return;
    }
    if (!_agreeToTerms) {
      _showError('You must agree to the Terms of Use');
      return;
    }

    setState(() => _isLoading = true);
    
    try {
      final result = await _auth.register(
        fullName: fullName,
        email: email,
        phoneNumber: phone,
        password: password,
        confirmPassword: confirmPassword,
        userType: _userType,
        location: location,
        referralCode: _referralController.text.trim(),
        vehicleType: _userType == 'driver' ? _vehicleTypeController.text.trim() : null,
        vehicleNumber: _userType == 'driver' ? _vehicleNumberController.text.trim() : null,
        licenseNumber: _userType == 'driver' ? _licenseController.text.trim() : null,
      ).timeout(const Duration(seconds: 15));

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (result['success'] == true) {
        _showSuccess(result['message'] ?? 'Account created!');
        Future.delayed(const Duration(milliseconds: 1500), () {
          if (mounted) Navigator.pushReplacementNamed(context, '/login');
        });
      } else {
        _showError(result['message'] ?? 'Registration failed.');
      }
    } on TimeoutException {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showError('Request timed out. Please try again.');
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showError('Registration failed: ${e.toString()}');
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.redAccent, behavior: SnackBarBehavior.floating));
  }

  void _showSuccess(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.green, behavior: SnackBarBehavior.floating));
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
          // Top Image Background
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: size.height * 0.45,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/car.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                      Colors.black,
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      'Fuel Connect',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Create an account',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
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
                    // Email Address
                    _buildLabel('Your Email Address', theme),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _emailController,
                      hintText: 'jance@gmail.com',
                      theme: theme,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    
                    // Phone Number
                    _buildLabel('Phone Number', theme),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _phoneController,
                      hintText: '+256 700 000000',
                      theme: theme,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),

                    // Full Name & Location (to keep it concise, just required ones)
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('Full Name', theme),
                              const SizedBox(height: 8),
                              _buildTextField(controller: _fullNameController, hintText: 'Jane Doe', theme: theme),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('Location', theme),
                              const SizedBox(height: 8),
                              _buildTextField(controller: _locationController, hintText: 'City, Country', theme: theme),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Password Field
                    _buildLabel('Choose a Password', theme),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _passwordController,
                      hintText: 'min. 8 characters',
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

                    // Confirm Password Field
                    _buildLabel('Confirm Password', theme),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _confirmPasswordController,
                      hintText: '••••••••',
                      theme: theme,
                      obscureText: _obscureConfirmPassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                          color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5),
                        ),
                        onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Agree to terms
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'I agree with terms of use',
                          style: TextStyle(color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6), fontSize: 13),
                        ),
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Checkbox(
                            value: _agreeToTerms,
                            onChanged: (val) => setState(() => _agreeToTerms = val ?? false),
                            activeColor: AppTheme.gold,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Sign up Button
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleSignUp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.gold,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                          elevation: 0,
                        ),
                        child: _isLoading 
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Text('Sign up', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
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
                            onPressed: () {},
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _SocialButton(
                            label: 'Apple Store',
                            icon: _AppleIcon(isDark: isDark),
                            theme: theme,
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Log in
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Already have an account? ', style: TextStyle(color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6), fontSize: 13)),
                        GestureDetector(
                          onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen())),
                          child: const Text('Log in', style: TextStyle(color: AppTheme.gold, fontSize: 13, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40), // Padding for scroll bottom
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
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
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
    return SizedBox(width: 18, height: 18, child: CustomPaint(painter: _GooglePainter()));
  }
}
class _GooglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2, cy = size.height / 2, r = size.width / 2;
    canvas.drawCircle(Offset(cx, cy), r, Paint()..color = Colors.white);
    const segments = [(0.0, 1.57, Color(0xFF4285F4)), (1.57, 3.14, Color(0xFF34A853)), (3.14, 4.71, Color(0xFFFBBC05)), (4.71, 6.28, Color(0xFFEA4335))];
    for (final seg in segments) canvas.drawArc(Rect.fromCircle(center: Offset(cx, cy), radius: r * 0.7), seg.$1, seg.$2 - seg.$1, false, Paint()..color = seg.$3..style = PaintingStyle.stroke..strokeWidth = size.width * 0.2);
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
    return SizedBox(width: 18, height: 18, child: CustomPaint(painter: _ApplePainter(isDark: isDark)));
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