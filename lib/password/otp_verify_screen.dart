import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/auth/login_screen.dart';
import '/services/auth_service.dart';
import '../auth/theme.dart';

class OtpVerifyScreen extends StatefulWidget {
  final String email;
  final String otp;

  const OtpVerifyScreen({
    super.key,
    required this.email,
    required this.otp,
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
  void dispose() {
    _newPassController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // API integration for later implementation. Right now we simulate success.
      await Future.delayed(const Duration(seconds: 2));
      final result = {'success': true};
      /* 
      final result = await _auth.resetPassword(
        email: widget.email,
        token: widget.otp,
        newPassword: _newPassController.text.trim(),
        confirmNewPassword: _confirmPassController.text.trim(),
      ).timeout(const Duration(seconds: 15));
      */

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
        _showPopup(
          title: 'Reset Failed',
          message: result['message']?.toString() ?? 'Something went wrong. Please try again.',
          isSuccess: false,
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showPopup(
        title: 'Error',
        message: 'Request failed. Please check your connection.',
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
        backgroundColor: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: isSuccess ? AppTheme.gold : Colors.redAccent.withOpacity(0.5),
          ),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSuccess
                    ? AppTheme.gold.withOpacity(0.2)
                    : Colors.redAccent.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isSuccess ? Icons.check_circle_outline : Icons.error_outline,
                color: isSuccess ? AppTheme.gold : Colors.redAccent,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: theme.textTheme.bodyLarge?.color,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: TextStyle(color: theme.textTheme.bodyMedium?.color, fontSize: 14, height: 1.4),
        ),
        actionsPadding: const EdgeInsets.only(bottom: 12, right: 12),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx, rootNavigator: true).pop();
              if (onConfirm != null && mounted) onConfirm();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.gold,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            ),
            child: const Text('OK', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700)),
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.iconTheme.color),
          onPressed: () => Navigator.maybePop(context),
        ),
        actions: const [ThemeToggleButton()],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  children: [
                    const FuelConnectLogo(fontSize: 16),
                    const SizedBox(height: 8),
                    Text(
                      'SECURE PASSWORD RESET',
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

              // Body
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Center(
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
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 64, height: 64,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: AppTheme.buttonGradient,
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.gold.withOpacity(0.4),
                                  blurRadius: 20, spreadRadius: 3,
                                ),
                              ],
                            ),
                            child: const Icon(Icons.lock_outline, color: Colors.black, size: 32),
                          ),
                          const SizedBox(height: 24),
                          
                          Text(
                            'Create New Password',
                            style: TextStyle(color: theme.textTheme.bodyLarge?.color, fontSize: 22, fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 8),
                          
                          Text(
                            'For ${widget.email}',
                            style: TextStyle(color: theme.textTheme.bodyMedium?.color, fontSize: 13),
                          ),
                          const SizedBox(height: 12),

                          // Password rules hint
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF0F0F0),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: theme.dividerColor),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Password must contain:', 
                                  style: TextStyle(color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8), fontSize: 11, fontWeight: FontWeight.w600)
                                ),
                                const SizedBox(height: 6),
                                _RuleRow(text: 'At least 8 characters', theme: theme),
                                _RuleRow(text: 'Uppercase letter (A-Z)', theme: theme),
                                _RuleRow(text: 'Lowercase letter (a-z)', theme: theme),
                                _RuleRow(text: 'Number (0-9)', theme: theme),
                                _RuleRow(text: 'Special character (!@#\$%^&*)', theme: theme),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // New Password
                          _buildPasswordField(
                            controller: _newPassController,
                            label: 'NEW PASSWORD',
                            obscure: _obscureNew,
                            onToggle: () => setState(() => _obscureNew = !_obscureNew),
                            theme: theme,
                            isDark: isDark,
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) return 'Password is required';
                              if (!_passRegex.hasMatch(v.trim())) {
                                return 'Must have 8+ chars, upper, lower, number & symbol';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Confirm Password
                          _buildPasswordField(
                            controller: _confirmPassController,
                            label: 'CONFIRM PASSWORD',
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

                          // Reset Button
                          GoldButton(
                            text: _isLoading ? 'RESETTING...' : 'RESET PASSWORD',
                            onPressed: _isLoading ? () {} : _resetPassword,
                          ),
                          const SizedBox(height: 16),
                          
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Text('Cancel', style: TextStyle(color: theme.textTheme.bodyMedium?.color, fontSize: 13, fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label, 
          style: TextStyle(
            color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8), 
            fontSize: 10, 
            letterSpacing: 1.0, 
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
          child: TextFormField(
            controller: controller,
            obscureText: obscure,
            style: TextStyle(color: theme.textTheme.bodyLarge?.color, fontSize: 14),
            validator: validator,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            inputFormatters: [LengthLimitingTextInputFormatter(50)],
            decoration: InputDecoration(
              hintText: '••••••••',
              hintStyle: TextStyle(color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5)),
              prefixIcon: Icon(Icons.lock_outline, color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6), size: 18),
              suffixIcon: GestureDetector(
                onTap: onToggle,
                child: Icon(
                  obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6), 
                  size: 18,
                ),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
      ],
    );
  }
}

class _RuleRow extends StatelessWidget {
  final String text;
  final ThemeData theme;
  
  const _RuleRow({required this.text, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline, color: AppTheme.gold, size: 12),
          const SizedBox(width: 6),
          Text(text, style: TextStyle(color: theme.textTheme.bodyMedium?.color, fontSize: 11)),
        ],
      ),
    );
  }
}