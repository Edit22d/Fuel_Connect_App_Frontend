import 'package:flutter/material.dart';
import 'otp_screen.dart';
import '../auth/theme.dart';
import '../services/auth_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  final _auth = AuthService();

  void _handleNext() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter an email or phone number')));
      return;
    }

    setState(() => _isLoading = true);
    
    try {
      final result = await _auth.forgotPassword(email: email);
      if (!mounted) return;
      setState(() => _isLoading = false);

      if (result['success'] == true) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OtpScreen(
              email: email,
              fromForgotPassword: true, 
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result['message'] ?? 'Failed to send OTP')));
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('An error occurred: $e')));
    }
  }

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
          onPressed: () => Navigator.maybePop(context),
        ),
        actions: const [
          ThemeToggleButton(),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 400),
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Center(child: FuelConnectLogo(fontSize: 32)),
                        const SizedBox(height: 8),
                        Center(
                          child: Text(
                            'FUEL CONNECT PORTAL',
                            style: TextStyle(
                              color: theme.textTheme.bodyMedium?.color,
                              fontSize: 10,
                              letterSpacing: 2.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Padlock Icon
                        Center(
                          child: Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: AppTheme.buttonGradient,
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.gold.withOpacity(0.4),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: const Icon(Icons.lock_outline, color: Colors.black, size: 32),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Title
                        Text(
                          'Forgot your password?',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: theme.textTheme.bodyLarge?.color, fontSize: 22, fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 12),

                        // Subtitle
                        Text(
                          'No worries! Enter your registered email or phone number to receive a secure OTP.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: theme.textTheme.bodyMedium?.color, fontSize: 13, height: 1.5),
                        ),
                        const SizedBox(height: 32),

                        // Email Field
                        Text(
                          'EMAIL OR PHONE NUMBER',
                          style: TextStyle(
                            color: theme.textTheme.bodyMedium?.color,
                            fontSize: 10,
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        
                        Container(
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF0F0F0),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: theme.dividerColor),
                          ),
                          child: TextField(
                            controller: _emailController,
                            style: TextStyle(color: theme.textTheme.bodyLarge?.color, fontSize: 14),
                            decoration: InputDecoration(
                              hintText: 'example@email.com / +256...',
                              hintStyle: TextStyle(color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5), fontSize: 14),
                              prefixIcon: Icon(Icons.email_outlined, color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6), size: 20),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.done,
                          ),
                        ),
                        const SizedBox(height: 28),

                        // Next Button
                        GoldButton(
                          text: _isLoading ? 'SENDING OTP...' : 'NEXT',
                          onPressed: _isLoading ? () {} : _handleNext,
                        ),
                        const SizedBox(height: 24),

                        // Return to Login
                        GestureDetector(
                          onTap: () => Navigator.maybePop(context),
                          child: Center(
                            child: Text(
                              'Return to Login',
                              style: TextStyle(
                                color: theme.textTheme.bodyMedium?.color,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 48),

                        // Footer
                        Column(
                          children: [
                            Text(
                              'PRIVACY PROTECTED • HELP CENTER',
                              style: TextStyle(color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6), fontSize: 9, letterSpacing: 1.2),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '© FUELCONNECT. SYSTEM SECURE',
                              style: TextStyle(color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6), fontSize: 9, letterSpacing: 1.2),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}