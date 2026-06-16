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
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  final _auth = AuthService();

  void _handleNext() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your email address'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _emailSent = false;
    });
    
    try {
      final result = await _auth.forgotPassword(phoneNumber: email);
      if (!mounted) return;
      
      setState(() {
        _isLoading = false;
        _emailSent = true;
      });

      if (result['success'] == true) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? '6-digit verification code sent to your email!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),
        );
        
        // Get the reset token if available (for development testing)
        final resetToken = result['reset_token'];
        
        // Navigate to OTP screen with a slight delay
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => OtpScreen(
                  email: email,
                  fromForgotPassword: true,
                  token: resetToken,
                ),
              ),
            );
          }
        });
      } else {
        String errorMessage = result['message'] ?? 'Failed to send verification code';
        
        if (errorMessage.contains('No account found') || 
            errorMessage.contains('phone number') ||
            errorMessage.toLowerCase().contains('not found')) {
          errorMessage = 'No account found with this email address.\nPlease check and try again.';
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _emailSent = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Connection error: Unable to reach server.\nPlease check your internet connection.'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
        ),
      );
      debugPrint('Forgot password error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: WavyHeader(title: 'Forgot Password'),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 16),
                          
                          // Subtitle
                          Text(
                            'Mail Address Here',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: isDark ? Colors.white : const Color(0xFF2C2C2C),
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.2,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Description
                          Text(
                            'Enter the email address associated\nwith your account.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: isDark ? Colors.white70 : const Color(0xFF757575),
                              fontSize: 14,
                              height: 1.5,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 40),

                          // Email Text Field
                          TextFormField(
                            controller: _emailController,
                            style: TextStyle(
                              color: isDark ? Colors.white : Colors.black87,
                              fontSize: 16,
                            ),
                            keyboardType: TextInputType.emailAddress,
                            enabled: !_isLoading,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              labelStyle: TextStyle(
                                color: isDark ? Colors.white60 : Colors.black54,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              floatingLabelStyle: const TextStyle(
                                color: AppTheme.gold,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              prefixIcon: const Icon(
                                Icons.email_outlined,
                                color: AppTheme.gold,
                                size: 22,
                              ),
                              hintText: 'edith@gmail.com',
                              hintStyle: TextStyle(
                                color: isDark ? Colors.white30 : Colors.black38,
                                fontSize: 16,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: isDark ? AppTheme.darkBorder : const Color(0xFFE0E0E0),
                                  width: 1.5,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: AppTheme.gold,
                                  width: 2.0,
                                ),
                              ),
                              filled: true,
                              fillColor: isDark ? const Color(0xFF141414) : Colors.white,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Recover Password Button
                          Container(
                            width: double.infinity,
                            height: 54,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: AppTheme.buttonGradient,
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.gold.withOpacity(isDark ? 0.15 : 0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: _isLoading ? () {} : _handleNext,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
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
                                  : const Text(
                                      'Recover Password',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                            ),
                          ),
                          
                          // Success indicator when email is sent
                          if (_emailSent && !_isLoading)
                            Container(
                              margin: const EdgeInsets.only(top: 16),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.green.withOpacity(0.3)),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.check_circle, color: Colors.green, size: 20),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      '✓ 6-digit verification code sent successfully! Check your email.',
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          // Info text about token
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.orange.withOpacity(0.3)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.info_outline, color: Colors.orange, size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'A 6-digit verification code will be sent to your email. Check your inbox and spam folder.',
                                    style: TextStyle(
                                      color: isDark ? Colors.white70 : Colors.black54,
                                      fontSize: 12,
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      
                      // Bottom navigation helper
                      Padding(
                        padding: const EdgeInsets.only(top: 32.0),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.maybePop(context),
                              child: Text(
                                'Return to Login',
                                style: TextStyle(
                                  color: AppTheme.gold,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'PRIVACY PROTECTED • HELP CENTER',
                              style: TextStyle(
                                color: isDark ? Colors.white38 : Colors.black38,
                                fontSize: 10,
                                letterSpacing: 1.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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