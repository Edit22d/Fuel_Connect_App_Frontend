import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../auth/login_screen.dart';
import '../services/auth_service.dart';
import '../auth/theme.dart';

class OtpVerifyScreen extends StatefulWidget {
  final String email;
  final String otp;
  final String? token;

  const OtpVerifyScreen({
    super.key,
    required this.email,
    required this.otp,
    this.token,
  });

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  final _auth = AuthService();
  final TextEditingController _newPassController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  static final _passRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.token != null) {
        print('🔑 Using token: ${widget.token}');
      }
      print('📧 Email: ${widget.email}');
      print('🔢 OTP: ${widget.otp}');
    });
  }

  @override
  void dispose() {
    _newPassController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final String tokenToUse = widget.token ?? widget.otp;
      
      print('🔄 Resetting password with token: $tokenToUse');
      print('📧 Email: ${widget.email}');
      
      final result = await _auth.resetPassword(
        token: tokenToUse,
        newPassword: _newPassController.text.trim(),
        confirmPassword: _confirmPassController.text.trim(),
        phoneNumber: widget.email,
      );

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (result['success'] == true) {
        _showPopup(
          title: 'Password Reset!',
          message: 'Your password has been reset successfully. Please log in with your new password.',
          isSuccess: true,
          onConfirm: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
              (route) => false,
            );
          },
        );
      } else {
        String errorMessage = result['message']?.toString() ?? 'Something went wrong. Please try again.';
        
        if (errorMessage.contains('6-digit') || errorMessage.contains('token')) {
          errorMessage = 'Invalid verification code. Please enter the 6-digit code sent to your email.';
        } else if (errorMessage.contains('User not found')) {
          errorMessage = 'Account not found. Please check your email and try again.';
        }
        
        _showPopup(
          title: 'Reset Failed',
          message: errorMessage,
          isSuccess: false,
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showPopup(
        title: 'Error',
        message: 'Request failed: ${e.toString()}',
        isSuccess: false,
      );
    }
  }

  void _showPopup({
    required String title,
    required String message,
    required bool isSuccess,
    VoidCallback? onConfirm,
  }) {
    if (!mounted) return;
    
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: isSuccess ? AppTheme.gold : Colors.redAccent.withOpacity(0.5),
            width: 1.5,
          ),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSuccess
                    ? AppTheme.gold.withOpacity(0.15)
                    : Colors.redAccent.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isSuccess ? Icons.check_circle_outline : Icons.error_outline,
                color: isSuccess ? AppTheme.gold : Colors.redAccent,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: TextStyle(
            color: isDark ? Colors.white70 : Colors.black54,
            fontSize: 14,
            height: 1.5,
          ),
        ),
        actionsPadding: const EdgeInsets.only(bottom: 16, right: 16),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx, rootNavigator: true).pop();
              if (onConfirm != null && mounted) onConfirm();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.gold,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              elevation: 0,
            ),
            child: const Text(
              'OK',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: WavyHeader(title: 'Change Password'),
      body: SafeArea(
        child: Form(
          key: _formKey,
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
                            
                            Text(
                              'Enter New Password',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: isDark ? Colors.white : const Color(0xFF2C2C2C),
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.2,
                              ),
                            ),
                            const SizedBox(height: 12),

                            Text(
                              'Your new password must be different\nfrom previously used password.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: isDark ? Colors.white70 : const Color(0xFF757575),
                                fontSize: 14,
                                height: 1.5,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 24),

                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF141414) : const Color(0xFFF5F6F9),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isDark ? AppTheme.darkBorder : const Color(0xFFE0E0E0),
                                  width: 1.0,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Password requirements:', 
                                    style: TextStyle(
                                      color: isDark ? Colors.white : const Color(0xFF2C2C2C),
                                      fontSize: 12, 
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  _RuleRow(text: 'At least 8 characters', isDark: isDark),
                                  _RuleRow(text: 'Uppercase letter (A-Z)', isDark: isDark),
                                  _RuleRow(text: 'Lowercase letter (a-z)', isDark: isDark),
                                  _RuleRow(text: 'Number (0-9)', isDark: isDark),
                                  _RuleRow(text: 'Special character (!@#\$%^&*)', isDark: isDark),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),

                            _buildPasswordField(
                              controller: _newPassController,
                              label: 'Password',
                              obscure: _obscureNew,
                              onToggle: () => setState(() => _obscureNew = !_obscureNew),
                              theme: theme,
                              isDark: isDark,
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) return 'Password is required';
                                if (!_passRegex.hasMatch(v.trim())) {
                                  return 'Must meet all requirements above';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),

                            _buildPasswordField(
                              controller: _confirmPassController,
                              label: 'Confirm Password',
                              obscure: _obscureConfirm,
                              onToggle: () => setState(() => _obscureConfirm = !_obscureConfirm),
                              theme: theme,
                              isDark: isDark,
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) return 'Please confirm your password';
                                if (v.trim() != _newPassController.text.trim()) return 'Passwords do not match';
                                return null;
                              },
                            ),
                            const SizedBox(height: 32),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: _isLoading ? null : _resetPassword,
                                  style: TextButton.styleFrom(
                                    foregroundColor: AppTheme.gold,
                                    textStyle: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  child: const Text('Reset password'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
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
                                onPressed: _isLoading ? null : _resetPassword,
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
                                        'Continue',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                        
                        Padding(
                          padding: const EdgeInsets.only(top: 32.0),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Text(
                                  'Cancel',
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
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscure,
    required VoidCallback onToggle,
    required ThemeData theme,
    required bool isDark,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      style: TextStyle(
        color: isDark ? Colors.white : Colors.black87,
        fontSize: 16,
      ),
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      inputFormatters: [LengthLimitingTextInputFormatter(50)],
      decoration: InputDecoration(
        labelText: label,
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
          Icons.lock_outline,
          color: AppTheme.gold,
          size: 22,
        ),
        suffixIcon: GestureDetector(
          onTap: onToggle,
          child: Icon(
            obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            color: isDark ? Colors.white38 : Colors.black38,
            size: 20,
          ),
        ),
        hintText: '••••••••',
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
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.redAccent,
            width: 1.5,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.redAccent,
            width: 2.0,
          ),
        ),
        filled: true,
        fillColor: isDark ? const Color(0xFF141414) : Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      ),
    );
  }
}

class _RuleRow extends StatelessWidget {
  final String text;
  final bool isDark;
  
  const _RuleRow({required this.text, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline, color: AppTheme.gold, size: 14),
          const SizedBox(width: 8),
          Text(
            text, 
            style: TextStyle(
              color: isDark ? Colors.white70 : const Color(0xFF555555), 
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}