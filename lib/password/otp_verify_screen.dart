import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/auth/login_screen.dart';

class OtpVerifyScreen extends StatefulWidget {
  final String email;
  final String otp;
  const OtpVerifyScreen({super.key, required this.email, required this.otp});

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  final TextEditingController _newPassController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscureText = true;

  @override
  void dispose() {
    _newPassController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  void _resetPassword() {
    final formState = _formKey.currentState;
    if (formState == null || !formState.validate()) {
      print('❌ Form validation failed');
      return;
    }

    final newPass = _newPassController.text.trim();
    final confirmPass = _confirmPassController.text.trim();

    print('🔍 Debug: newPass="$newPass", confirmPass="$confirmPass"');

    if (newPass != confirmPass) {
      print('❌ Passwords mismatch');
      _showInlinePopup(
        title: 'Password Mismatch',
        message: 'The passwords you entered do not match.',
        isSuccess: false,
      );
      return;
    }
    if (newPass.length < 6) {
      print('❌ Password too short');
      _showInlinePopup(
        title: 'Weak Password',
        message: 'Password must be at least 6 characters long.',
        isSuccess: false,
      );
      return;
    }

    print('✅ Showing success popup');
    _showInlinePopup(
      title: 'Success!',
      message: 'Your password has been reset successfully.',
      isSuccess: true,
      onConfirm: () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        );
      },
    );
  } // ✅ THIS was the missing closing brace

  void _showInlinePopup({
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
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: isSuccess
                ? const Color(0xFFC8A84B)
                : Colors.redAccent.withOpacity(0.5),
            width: 1,
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
                isSuccess ? Icons.check : Icons.error,
                color: isSuccess ? const Color(0xFFC8A84B) : Colors.redAccent,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 17,
              ),
            ),
          ],
        ),
        content: Container(
          width: double.maxFinite,
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            message,
            style: const TextStyle(
                color: Color(0xFFB0B0B0), fontSize: 14, height: 1.4),
          ),
        ),
        actionsPadding: const EdgeInsets.only(bottom: 8, right: 8),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx, rootNavigator: true).pop();
              if (onConfirm != null && mounted) {
                onConfirm();
              }
            },
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFFC8A84B),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            ),
            child: const Text(
              'OK',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    ).then((_) {
      print('🔍 Dialog closed');
    });
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
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.chevron_left,
                          color: Colors.white),
                    ),
                    const Text(
                      'Set Password',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 40),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      const Icon(Icons.lock_outline,
                          color: Color(0xFFC8A84B), size: 48),
                      const SizedBox(height: 32),
                      const Text(
                        'Create New Password',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'For ${widget.email}',
                        style: const TextStyle(
                            color: Color(0xFF9E9E9E), fontSize: 13),
                      ),
                      const SizedBox(height: 40),
                      _buildPasswordField(
                        _newPassController,
                        'New Password',
                        _obscureText,
                        () => setState(() => _obscureText = !_obscureText),
                        (v) {
                          if (v == null || v.trim().isEmpty) return 'Required';
                          if (v.trim().length < 6) return 'Min 6 characters';
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      _buildPasswordField(
                        _confirmPassController,
                        'Confirm Password',
                        _obscureText,
                        () => setState(() => _obscureText = !_obscureText),
                        (v) {
                          if (v == null || v.trim().isEmpty) return 'Required';
                          if (v.trim() != _newPassController.text.trim())
                            return 'Passwords mismatch';
                          return null;
                        },
                      ),
                      const SizedBox(height: 40),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _resetPassword,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFC8A84B),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Text(
                            'Reset Password',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                              color: Color(0xFF9E9E9E), fontSize: 13),
                        ),
                      ),
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

  Widget _buildPasswordField(
    TextEditingController ctrl,
    String label,
    bool obscure,
    VoidCallback onToggle,
    String? Function(String?) validator,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
              color: Color(0xFF888888),
              fontSize: 11,
              fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFF2A2A2A)),
          ),
          child: TextFormField(
            controller: ctrl,
            obscureText: obscure,
            style: const TextStyle(color: Colors.white),
            validator: validator,
            decoration: InputDecoration(
              hintText: '••••••••',
              hintStyle: const TextStyle(color: Color(0xFF555555)),
              prefixIcon: const Icon(Icons.lock_outline,
                  color: Color(0xFF666666), size: 20),
              suffixIcon: GestureDetector(
                onTap: onToggle,
                child: Icon(
                  obscure
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: const Color(0xFF666666),
                  size: 20,
                ),
              ),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
            inputFormatters: [LengthLimitingTextInputFormatter(50)],
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
        ),
      ],
    );
  }
}