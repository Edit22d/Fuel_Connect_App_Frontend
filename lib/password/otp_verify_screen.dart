import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/auth/login_screen.dart';
import '/services/auth_service.dart';

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

  // Password strength
  static final _passRegex = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$',
  );

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
      final result = await _auth.resetPassword(
        email: widget.email,
        token: widget.otp,
        newPassword: _newPassController.text.trim(),
        confirmNewPassword: _confirmPassController.text.trim(),
      ).timeout(const Duration(seconds: 15));

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
          message: result['message'] ?? 'Something went wrong. Please try again.',
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
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: isSuccess ? const Color(0xFFC8A84B) : Colors.redAccent.withOpacity(0.5),
          ),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSuccess
                    ? const Color(0xFFC8A84B).withOpacity(0.2)
                    : Colors.redAccent.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isSuccess ? Icons.check_circle_outline : Icons.error_outline,
                color: isSuccess ? const Color(0xFFC8A84B) : Colors.redAccent,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: const TextStyle(color: Color(0xFFB0B0B0), fontSize: 14, height: 1.4),
        ),
        actionsPadding: const EdgeInsets.only(bottom: 12, right: 12),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx, rootNavigator: true).pop();
              if (onConfirm != null && mounted) onConfirm();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC8A84B),
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
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // ── Header ──────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 36, height: 36,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1A1A),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFF2A2A2A)),
                        ),
                        child: const Icon(Icons.chevron_left, color: Color(0xFFC8A84B), size: 22),
                      ),
                    ),
                    const Text(
                      'Set New Password',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    const SizedBox(width: 36),
                  ],
                ),
              ),

              // ── Body ────────────────────────────────────────────────
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 32),
                      Container(
                        width: 64, height: 64,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Color(0xFFC8A84B), Color(0xFFB8983B)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFC8A84B).withOpacity(0.4),
                              blurRadius: 20, spreadRadius: 3,
                            ),
                          ],
                        ),
                        child: const Icon(Icons.lock_outline, color: Colors.black, size: 32),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Create New Password',
                        style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'For ${widget.email}',
                        style: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 13),
                      ),
                      const SizedBox(height: 12),

                      // Password rules hint
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1A1A),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFF2A2A2A)),
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Password must contain:', style: TextStyle(color: Color(0xFF888888), fontSize: 11, fontWeight: FontWeight.w600)),
                            SizedBox(height: 6),
                            _RuleRow(text: 'At least 8 characters'),
                            _RuleRow(text: 'Uppercase letter (A-Z)'),
                            _RuleRow(text: 'Lowercase letter (a-z)'),
                            _RuleRow(text: 'Number (0-9)'),
                            _RuleRow(text: 'Special character (!@#\$%^&*)'),
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
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Please confirm your password';
                          if (v.trim() != _newPassController.text.trim()) return 'Passwords do not match';
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),

                      // Reset Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _resetPassword,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFC8A84B),
                            disabledBackgroundColor: const Color(0xFFC8A84B).withOpacity(0.5),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            elevation: 0,
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 20, height: 20,
                                  child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2.5),
                                )
                              : const Text(
                                  'Reset Password',
                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 15),
                                ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Text('Cancel', style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 13)),
                      ),
                      const SizedBox(height: 24),
                    ],
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
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF888888), fontSize: 10, letterSpacing: 1.0, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFF2A2A2A)),
          ),
          child: TextFormField(
            controller: controller,
            obscureText: obscure,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            validator: validator,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            inputFormatters: [LengthLimitingTextInputFormatter(50)],
            decoration: InputDecoration(
              hintText: '••••••••',
              hintStyle: const TextStyle(color: Color(0xFF555555)),
              prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF666666), size: 18),
              suffixIcon: GestureDetector(
                onTap: onToggle,
                child: Icon(
                  obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  color: const Color(0xFF666666), size: 18,
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

// ── Password Rule Row ──────────────────────────────────────────
class _RuleRow extends StatelessWidget {
  final String text;
  const _RuleRow({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline, color: Color(0xFFC8A84B), size: 12),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(color: Color(0xFF888888), fontSize: 11)),
        ],
      ),
    );
  }
}