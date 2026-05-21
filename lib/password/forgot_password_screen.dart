import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '/password/otp_screen.dart';

const String baseUrl = 'http://10.0.2.2:8000';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submitEmail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final String email = _emailController.text.trim();

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/v1/auth/forgot-password/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        String? token = data['debug_token'];
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => OtpScreen(email: email, token: token)),
          );
        }
      } else {
        setState(() => _errorMessage = 'An unexpected error occurred. Please try again.');
      }
    } catch (e) {
      setState(() => _errorMessage = 'Connection error. Please check your internet.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: SafeArea(
        child: Column(
          children: [
            // ============================================================
            // LAYER 1: Background Layer (Logo top, Footer bottom)
            // ============================================================
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.maybePop(context),
                    child: const Row(
                      children: [
                        Icon(Icons.arrow_back_ios, color: Color(0xFFC8A84B), size: 14),
                        SizedBox(width: 6),
    
                      ],
                    ),
                  ),
                  Image.asset(
                    'assets/images/logo.png',
                    width: 120,
                    height: 100,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Text(
                      'FUELCONNECT',
                      style: TextStyle(
                        color: Color(0xFFC8A84B),
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(width: 60),
                ],
              ),
            ),

            // ============================================================
            // LAYER 2: Premium Centered Container with Padlock
            // ============================================================
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
                        // Padlock Icon
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
                            Icons.lock_outline,
                            color: Colors.black,
                            size: 32,
                          ),
                        ),
                        
                        const SizedBox(height: 24),

                        // Title
                        RichText(
                          textAlign: TextAlign.center,
                          text: const TextSpan(
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                              height: 1.3,
                            ),
                            children: [
                              TextSpan(
                                text: 'Forgot your\n',
                                style: TextStyle(color: Colors.white),
                              ),
                              TextSpan(
                                text: 'password?',
                                style: TextStyle(color: Color(0xFFC8A84B)),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Subtitle
                        const Text(
                          'No worries! Enter your email and we\'ll send you instructions to reset it.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF9E9E9E),
                            fontSize: 13,
                            height: 1.6,
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Email Field
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Email',
                            style: TextStyle(
                              color: Color(0xFF888888),
                              fontSize: 11,
                              letterSpacing: 1.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A1A1A),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFF2A2A2A)),
                          ),
                          child: Form(
                            key: _formKey,
                            child: TextFormField(
                              controller: _emailController,
                              style: const TextStyle(color: Colors.white, fontSize: 14),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: 'example@email.com',
                                hintStyle: const TextStyle(color: Color(0xFF555555), fontSize: 14),
                                prefixIcon: const Icon(
                                  Icons.email_outlined,
                                  color: Color(0xFF666666),
                                  size: 20,
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              ),
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ),
                        ),

                        // Error Message
                        if (_errorMessage != null) ...[
                          const SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.red.withOpacity(0.3)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.error_outline, color: Colors.red, size: 18),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _errorMessage!,
                                    style: const TextStyle(color: Colors.red, fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],

                        const SizedBox(height: 28),

                        // Send Reset Link Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _submitEmail,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFC8A84B),
                              disabledBackgroundColor: const Color(0xFFC8A84B).withOpacity(0.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 0,
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                                    ),
                                  )
                                : const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Send Reset Link',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 15,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                     
                                    ],
                                  ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Return to Login
                        GestureDetector(
                          onTap: () => Navigator.maybePop(context),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                           
                              SizedBox(width: 6),
                              Text(
                                'Return to Login',
                                style: TextStyle(
                                  color: Color(0xFF9E9E9E),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // ============================================================
            // FOOTER: Privacy Text
            // ============================================================
            const Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Column(
                children: [
                  Text(
                    'PRIVACY PROTECTED • HELP CENTER',
                    style: TextStyle(
                      color: Color(0xFF555555),
                      fontSize: 9,
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    '© FUELCONNECT. SYSTEM SECURE',
                    style: TextStyle(
                      color: Color(0xFF555555),
                      fontSize: 9,
                      letterSpacing: 1.2,
                    ),
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