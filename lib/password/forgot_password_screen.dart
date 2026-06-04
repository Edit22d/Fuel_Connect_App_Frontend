import 'package:flutter/material.dart';
import 'otp_screen.dart';
import '../auth/theme.dart';

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

  void _handleNext() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email or phone number'), backgroundColor: Colors.redAccent),
      );
      return;
    }

    setState(() => _isLoading = true);
    
    // Simulate API call for sending OTP
    await Future.delayed(const Duration(seconds: 1));
    
    if (!mounted) return;
    setState(() => _isLoading = false);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OtpScreen(
          email: email,
          fromForgotPassword: true, 
        ),
      ),
    );
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
        child: Column(
          children: [
            // ==================== HEADER ====================
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 24),
              child: Column(
                children: [
                  const FuelConnectLogo(fontSize: 16),
                  const SizedBox(height: 8),
                  Text(
                    'FUEL CONNECT PORTAL',
                    style: TextStyle(
                      color: theme.textTheme.bodyMedium?.color,
                      fontSize: 10,
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // ==================== CARD ====================
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
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
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Padlock Icon
                        Container(
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
                        const SizedBox(height: 24),

                        // Title
                        Text(
                          'Forgot your password?',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: theme.textTheme.bodyLarge?.color, fontSize: 24, fontWeight: FontWeight.w800),
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
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'EMAIL OR PHONE NUMBER',
                            style: TextStyle(
                              color: theme.textTheme.bodyMedium?.color,
                              fontSize: 10,
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.w700,
                            ),
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
                          child: Text(
                            'Return to Login',
                            style: TextStyle(
                              color: theme.textTheme.bodyMedium?.color,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // ==================== FOOTER ====================
            Padding(
              padding: const EdgeInsets.only(bottom: 24, top: 16),
              child: Column(
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
            ),
          ],
        ),
      ),
    );
  }
}