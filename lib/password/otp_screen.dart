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
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  bool _isLoading = false;
  
  Timer? _timer;
  int _secondsRemaining = 300; // 5 minutes
  final AuthService _auth = AuthService();

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _secondsRemaining = 300;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
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
    if (value.length == 1 && index < 5) {
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
            content: Text('✓ Code resent successfully'),
            backgroundColor: AppTheme.gold,
            behavior: SnackBarBehavior.floating,
          ),
        );
        for (var c in _controllers) c.clear();
        _focusNodes[0].requestFocus();
        _startTimer();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result['message'] ?? 'Failed to resend OTP')));
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('An error occurred: $e')));
    }
  }

  void _verifyOtp() {
    if (_secondsRemaining <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('OTP has expired. Please resend a new code.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final otpCode = _controllers.map((c) => c.text).join();
    if (otpCode.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter the full 6-digit OTP.'),
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
                            'SECURITY VERIFICATION',
                            style: TextStyle(
                              color: theme.textTheme.bodyMedium?.color,
                              fontSize: 10,
                              letterSpacing: 2.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Shield Icon
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
                                  spreadRadius: 3,
                                ),
                              ],
                            ),
                            child: const Icon(Icons.shield_outlined, color: Colors.black, size: 32),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Title
                        Text(
                          'OTP Verification',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: theme.textTheme.bodyLarge?.color,
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Subtitle
                        Text(
                          'Enter the OTP you received to',
                          style: TextStyle(color: theme.textTheme.bodyMedium?.color, fontSize: 13),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          widget.email,
                          style: TextStyle(
                            color: theme.textTheme.bodyLarge?.color,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),

                        // OTP Fields
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(6, (index) {
                            return Container(
                              width: 42,
                              height: 50,
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF0F0F0),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: theme.dividerColor, width: 1.5),
                              ),
                              child: TextField(
                                controller: _controllers[index],
                                focusNode: _focusNodes[index],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: theme.textTheme.bodyLarge?.color,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(1),
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  counterText: '',
                                ),
                                onChanged: (value) => _onChanged(value, index),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 32),

                        // Resend
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (_secondsRemaining > 0)
                              Text(
                                "Code expires in ${(_secondsRemaining ~/ 60).toString().padLeft(2, '0')}:${(_secondsRemaining % 60).toString().padLeft(2, '0')}",
                                style: const TextStyle(color: Colors.redAccent, fontSize: 13, fontWeight: FontWeight.bold),
                              )
                            else
                              const Text(
                                "OTP Expired",
                                style: TextStyle(color: Colors.redAccent, fontSize: 13, fontWeight: FontWeight.bold),
                              ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Didn't receive the code? ",
                                  style: TextStyle(color: theme.textTheme.bodyMedium?.color, fontSize: 12),
                                ),
                                GestureDetector(
                                  onTap: _secondsRemaining <= 0 || _isLoading ? _resendOtp : null,
                                  child: Text(
                                    'Resend OTP',
                                    style: TextStyle(
                                      color: _secondsRemaining <= 0 ? AppTheme.gold : theme.textTheme.bodyMedium?.color?.withOpacity(0.5),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Center(
                            child: Text(
                              'Cancel',
                              style: TextStyle(color: theme.textTheme.bodyMedium?.color, fontSize: 13, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Verify Button
                        GoldButton(
                          text: _isLoading ? 'VERIFYING...' : 'VERIFY OTP',
                          onPressed: _isLoading ? () {} : _verifyOtp,
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