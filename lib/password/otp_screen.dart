import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'otp_verify_screen.dart';
import '../auth/theme.dart';
import '../services/auth_service.dart';

class OtpScreen extends StatefulWidget {
  final String email;
  final String? token;
  final bool fromForgotPassword;
  
  const OtpScreen({
    super.key, 
    required this.email, 
    this.token,
    this.fromForgotPassword = false,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  // CONFIGURATION: Set the OTP length to match the screenshot (6 digits).
  // If your backend expects a 6-digit OTP, change this constant to 6.
  static const int otpLength = 6;

  final List<TextEditingController> _controllers = List.generate(otpLength, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(otpLength, (_) => FocusNode());
  bool _isLoading = false;
  
  Timer? _timer;
  int _secondsRemaining = 300; // 5 minutes
  final AuthService _auth = AuthService();

  @override
  void initState() {
    super.initState();
    _startTimer();
    // Auto-focus the first box after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_focusNodes.isNotEmpty && mounted) {
        _focusNodes[0].requestFocus();
      }
    });
  }

  void _startTimer() {
    _secondsRemaining = 300;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        if (mounted) {
          setState(() {
            _secondsRemaining--;
          });
        }
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) c.dispose();
    for (final f in _focusNodes) f.dispose();
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.length == 1 && index < otpLength - 1) {
      _focusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  void _resendOtp() async {
    setState(() => _isLoading = true);
    
    try {
      final result = await _auth.forgotPassword(email: widget.email);
      if (!mounted) return;
      setState(() => _isLoading = false);

      if (result['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✓ Verification code resent successfully'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        for (var c in _controllers) c.clear();
        _focusNodes[0].requestFocus();
        _startTimer();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Failed to resend OTP'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: $e'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _verifyOtp() {
    if (_secondsRemaining <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('OTP has expired. Please resend a new code.'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final otpCode = _controllers.map((c) => c.text).join();
    if (otpCode.length < otpLength) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter the full $otpLength-digit verification code.'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    // Pass the entered OTP to the next screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OtpVerifyScreen(
          email: widget.email,
          otp: otpCode,
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
      appBar: WavyHeader(title: 'OTP Verification'),
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
                          
                          // Subtitle: "Get Your Code"
                          Text(
                            'Get Your Code',
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
                            'Please enter the $otpLength digit code sent to\nyour email address.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: isDark ? Colors.white70 : const Color(0xFF757575),
                              fontSize: 14,
                              height: 1.5,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 40),

                          // OTP Fields Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(otpLength, (index) {
                              return Container(
                                width: 56,
                                height: 60,
                                margin: const EdgeInsets.symmetric(horizontal: 6),
                                decoration: BoxDecoration(
                                  color: isDark 
                                      ? const Color(0xFF141414) 
                                      : const Color(0xFFECEEF5),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: _focusNodes[index].hasFocus 
                                        ? AppTheme.gold 
                                        : (isDark ? AppTheme.darkBorder : const Color(0xFFD3D7E0)),
                                    width: _focusNodes[index].hasFocus ? 2.0 : 1.5,
                                  ),
                                ),
                                child: Center(
                                  child: TextField(
                                    controller: _controllers[index],
                                    focusNode: _focusNodes[index],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: isDark ? Colors.white : const Color(0xFF2C2C2C),
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(1),
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      counterText: '',
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                    onChanged: (value) {
                                      _onChanged(value, index);
                                      // Trigger rebuild for border color changes
                                      setState(() {});
                                    },
                                  ),
                                ),
                              );
                            }),
                          ),
                          const SizedBox(height: 32),

                          // Resend layout
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "If you don't receive code! ",
                                    style: TextStyle(
                                      color: isDark ? Colors.white60 : const Color(0xFF757575),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: _secondsRemaining <= 0 && !_isLoading ? _resendOtp : null,
                                    child: Text(
                                      'Resend',
                                      style: TextStyle(
                                        color: _secondsRemaining <= 0 ? AppTheme.gold : (isDark ? Colors.white30 : Colors.black38),
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        decoration: _secondsRemaining <= 0 ? TextDecoration.underline : TextDecoration.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              
                              // Timer status
                              if (_secondsRemaining > 0)
                                Text(
                                  "Code expires in ${(_secondsRemaining ~/ 60).toString().padLeft(2, '0')}:${(_secondsRemaining % 60).toString().padLeft(2, '0')}",
                                  style: const TextStyle(
                                    color: Colors.redAccent,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.2,
                                  ),
                                )
                              else
                                const Text(
                                  "Code has expired",
                                  style: TextStyle(
                                    color: Colors.redAccent,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 32),

                          // Verify and Proceed Button
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
                              onPressed: _isLoading ? () {} : _verifyOtp,
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
                                      'Verify and Proceed',
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
                      
                      // Bottom navigation helper
                      Padding(
                        padding: const EdgeInsets.only(top: 32.0),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.maybePop(context),
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
    );
  }
}
