import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ❌ REMOVED: import 'package:http/http.dart' as http;
// ❌ REMOVED: import 'dart:convert';
import 'otp_verify_screen.dart';

// ❌ REMOVED: const String baseUrl = 'http://10.0.2.2:8000';

class OtpScreen extends StatefulWidget {
  final String email;
  final String? token;
  final bool fromForgotPassword; // Optional flag for flow tracking
  
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
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  // ❌ REMOVED: bool _isLoading = false;
  // ❌ REMOVED: bool _isResending = false;

  @override
  void dispose() {
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

  // ✅ MOCK: Resend OTP — UI feedback only, no API call
  void _resendOtp() {
    // Show instant UI feedback
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✓ Code resent (Mock)'),
        backgroundColor: Color(0xFFC8A84B),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
    
    // Clear fields for demo
    for (var c in _controllers) c.clear();
    _focusNodes[0].requestFocus();
  }

  // ✅ MOCK: Verify OTP — Navigate directly, no API validation
  void _verifyOtp() {
    final otpCode = _controllers.map((c) => c.text).join();

    if (otpCode.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter all 6 digits'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // ✅ Instant navigation to next screen — no backend call
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OtpVerifyScreen(
          email: widget.email,
          otp: otpCode, // Passed for UI continuity; ignored in mock mode
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: SafeArea(
        child: Column(
          children: [
            // ==================== HEADER ====================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A1A),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFF2A2A2A)),
                      ),
                      child: const Icon(
                        Icons.chevron_left,
                        color: Color(0xFFC8A84B),
                        size: 22,
                      ),
                    ),
                  ),
                  const Text(
                    'Verification',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFC8A84B).withOpacity(0.5)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.lock, color: Color(0xFFC8A84B), size: 11),
                        SizedBox(width: 4),
                        Text(
                          'SECURE',
                          style: TextStyle(
                            color: Color(0xFFC8A84B),
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ==================== CARD ====================
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 420),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF141414),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF2A2A2A)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 25,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Shield Icon
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Color(0xFFC8A84B), Color(0xFFB8983B)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFC8A84B).withOpacity(0.4),
                                blurRadius: 20,
                                spreadRadius: 3,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.shield_outlined,
                            color: Colors.black,
                            size: 32,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Title
                        const Text(
                          'OTP Verification',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Subtitle + Email
                        const Text(
                          'Enter the OTP you received to',
                          style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 13),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          widget.email,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
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
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1A1A1A),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: const Color(0xFF2A2A2A), width: 1.5),
                              ),
                              child: TextField(
                                controller: _controllers[index],
                                focusNode: _focusNodes[index],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
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
                        const SizedBox(height: 24),

                        // Resend OTP — Mock Only
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Didn't receive the code? ",
                              style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 12),
                            ),
                            GestureDetector(
                              onTap: _resendOtp, // ✅ Direct call, no loading
                              child: const Text(
                                'Resend OTP',
                                style: TextStyle(
                                  color: Color(0xFFC8A84B),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Cancel
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.close, color: Color(0xFF9E9E9E), size: 14),
                              SizedBox(width: 6),
                              Text(
                                'Cancel',
                                style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),

                        // ✅ Verify Button — Instant Navigation
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _verifyOtp, // ✅ No loading state
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFC8A84B),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 0,
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.lock_outline, color: Colors.black, size: 18),
                                SizedBox(width: 8),
                                Text(
                                  'Verify OTP',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    letterSpacing: 0.5,
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}