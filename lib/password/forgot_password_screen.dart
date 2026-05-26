import 'package:flutter/material.dart';
import 'otp_screen.dart'; // ← Import your OtpScreen

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _goToNextScreen() {
    final email = _emailController.text.trim();
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OtpScreen(
          email: email.isNotEmpty ? email : 'user@example.com',
          fromForgotPassword: true, 
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
                          'No worries! We\'ll help you reset your password securely.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF9E9E9E),
                            fontSize: 13,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Email Field (Optional UI)
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Email (Optional)',
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
                          child: TextFormField(
                            controller: _emailController,
                            style: const TextStyle(color: Colors.white, fontSize: 14),
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
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                        const SizedBox(height: 28),

                        // ✅ Next Button — Instant Navigation
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _goToNextScreen,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFC8A84B),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 0,
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Next',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(Icons.arrow_forward_ios, color: Colors.white, size: 14),
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

            // ==================== FOOTER ====================
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