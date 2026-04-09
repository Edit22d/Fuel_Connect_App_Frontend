import 'package:flutter/material.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _referralController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _agreeToTerms = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _referralController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showTermsSheet(String type) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _TermsBottomSheet(
        type: type,
        onAccept: () {
          setState(() {
            _agreeToTerms = true;
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // Back arrow
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 20,
                ),
              ),

              const SizedBox(height: 24),

              // Logo centered
              Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 100,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 28),

              // Create Account heading
              const Center(
                child: Text(
                  'Create Account',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Subtitle
              const Center(
                child: Text(
                  'Join the Fuel Connect network and\noptimise your performance',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF888888),
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // FULL NAME label
              _buildLabel('FULL NAME'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _fullNameController,
                hintText: 'Sterling Archer',
                prefixIcon: Icons.person_outline,
              ),

              const SizedBox(height: 18),

              // EMAIL ADDRESS label
              _buildLabel('EMAIL ADDRESS'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _emailController,
                hintText: 'name@example.com',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 18),

              // PHONE NUMBER label
              _buildLabel('PHONE NUMBER'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _phoneController,
                hintText: '+1 (555) 000-0000',
                prefixIcon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),

              const SizedBox(height: 18),

              // REFERRAL CODE (OPTIONAL) label
              _buildLabel('PASSWORD'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _referralController,
                hintText: '············',
                prefixIcon: Icons.card_giftcard_outlined,
              ),

              const SizedBox(height: 18),

              // PASSWORD label
              _buildLabel('CONFIRM PASSWORD'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _passwordController,
                hintText: '••••••••',
                prefixIcon: Icons.lock_outline,
                obscureText: _obscurePassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: const Color(0xFF666666),
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),

              const SizedBox(height: 20),

              // Terms & Privacy Policy checkbox row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: Checkbox(
                      value: _agreeToTerms,
                      onChanged: (val) {
                        setState(() {
                          _agreeToTerms = val ?? false;
                        });
                      },
                      activeColor: const Color(0xFFC8A84B),
                      checkColor: Colors.black,
                      side: const BorderSide(color: Color(0xFF555555)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: 'I agree to the ',
                            style: TextStyle(
                              color: Color(0xFF888888),
                              fontSize: 12,
                              height: 1.5,
                            ),
                          ),
                          WidgetSpan(
                            child: GestureDetector(
                              onTap: () => _showTermsSheet('Terms of Service'),
                              child: const Text(
                                'Terms of Service',
                                style: TextStyle(
                                  color: Color(0xFFC8A84B),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          const TextSpan(
                            text: ' and ',
                            style: TextStyle(
                              color: Color(0xFF888888),
                              fontSize: 12,
                            ),
                          ),
                          WidgetSpan(
                            child: GestureDetector(
                              onTap: () => _showTermsSheet('Privacy Policy'),
                              child: const Text(
                                'Privacy Policy',
                                style: TextStyle(
                                  color: Color(0xFFC8A84B),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

                              SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _agreeToTerms
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFC8A84B),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      disabledBackgroundColor:
                          const Color(0xFFC8A84B).withOpacity(0.5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward, size: 18),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 20),

              // Already part of the fleet? Sign In
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: "Already part of the fleet?  ",
                          style: TextStyle(
                            color: Color(0xFF888888),
                            fontSize: 13,
                          ),
                        ),
                        TextSpan(
                          text: 'Sign In',
                          style: TextStyle(
                            color: Color(0xFFC8A84B),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 36),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFF888888),
        fontSize: 11,
        letterSpacing: 1.2,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Color(0xFF555555), fontSize: 14),
          prefixIcon:
              Icon(prefixIcon, color: const Color(0xFF666666), size: 20),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }
}

// Terms Bottom Sheet Widget
class _TermsBottomSheet extends StatefulWidget {
  final String type;
  final VoidCallback onAccept;

  const _TermsBottomSheet({
    required this.type,
    required this.onAccept,
  });

  @override
  State<_TermsBottomSheet> createState() => _TermsBottomSheetState();
}

class _TermsBottomSheetState extends State<_TermsBottomSheet> {
  bool _hasScrolledToBottom = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Color(0xFF0D0D0D),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          // Title
          Text(
            widget.type,
            style: const TextStyle(
              color: Color(0xFFC8A84B),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 1,
            margin: const EdgeInsets.symmetric(horizontal: 24),
            color: Colors.white24,
          ),
          const SizedBox(height: 16),
          // Scrollable content
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification notification) {
                if (!_hasScrolledToBottom &&
                    notification.metrics.pixels >=
                        notification.metrics.maxScrollExtent - 10) {
                  setState(() {
                    _hasScrolledToBottom = true;
                  });
                }
                return false;
              },
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.type == 'Terms of Service') ...[
                      const Center(
                        child: Text(
                          'TERMS & CONDITIONS',
                          style: TextStyle(
                            color: Color(0xFFC8A84B),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        height: 1,
                        width: double.infinity,
                        color: const Color(0xFFC8A84B),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Terms of Service',
                        style: TextStyle(
                          color: Color(0xFFC8A84B),
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Last updated: 2026-01-04',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        height: 1,
                        width: double.infinity,
                        color: Colors.white24,
                      ),
                      const SizedBox(height: 24),
                      _buildTermSection(
                        '1. ACCEPTANCE OF TERMS',
                        'By accessing this app and the FanZone® application, you agree to be bound by these terms. You may not access or use the app if you do not accept these terms. If you continue to access or use the app after reading these terms, your continued access constitutes acceptance of these terms.',
                      ),
                      _buildTermSection(
                        '2. GENERAL DISCLAIMER',
                        'Fan Zone is a platform for fans to share their experiences and connect with other fans. Fan Zone does not endorse any product or service mentioned in the app. Fan Zone is not responsible for any damages that may occur as a result of using the app. Fan Zone disclaims all liability for any losses or damages that may arise from the use of the app.',
                      ),
                      _buildTermSection(
                        '3. USER IDENTIFICATION',
                        'Users are required to provide accurate identification information when registering on the app. Failure to provide accurate identification may result in the temporary suspension of user accounts. Users must also provide accurate contact information when registering on the app.',
                      ),
                      _buildTermSection(
                        '4. PROVIDE AND INTERNET ACCESS',
                        'Fan Zone reserves the right to suspend or terminate an account if it becomes aware of any suspicious activity or if there is evidence of fraudulent behavior. Users are responsible for ensuring they have adequate internet access and connectivity to use the app.',
                      ),
                      _buildTermSection(
                        '5. CANCELLATION POLICY',
                        'Fan Zone has the right to cancel or suspend an account at any time without prior notice. Cancellation policies may vary depending on the type of account and the specific circumstances. Users should review Fan Zone\'s cancellation policy before signing up for an account.',
                      ),
                      _buildTermSection(
                        '6. LIABILITY',
                        'Fan Zone assumes no responsibility for any damages or losses that may occur as a result of using the app. Users should consult with legal professionals before using the app.',
                      ),
                      _buildTermSection(
                        '7. GUARANTEE',
                        'Fan Zone offers a guarantee that the app will work properly for a certain period of time. The length of the guarantee varies depending on the type of account and the specific circumstances. Users should review Fan Zone\'s guarantee policy before using the app.',
                      ),
                      _buildTermSection(
                        '8. TERMINATION',
                        'Fan Zone may terminate or suspend an account if it becomes aware of any violations of these terms. Termination may include the termination of the account and any associated services.',
                      ),
                      _buildTermSection(
                        '9. AGREEMENT TERMS & CONDITIONS',
                        'By using this app, you acknowledge that you have read, understood, and agree to be bound by these Terms & Conditions.',
                      ),
                    ] else ...[
                      const Center(
                        child: Text(
                          'PRIVACY POLICY',
                          style: TextStyle(
                            color: Color(0xFFC8A84B),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        height: 1,
                        width: double.infinity,
                        color: const Color(0xFFC8A84B),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Privacy Policy',
                        style: TextStyle(
                          color: Color(0xFFC8A84B),
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Last updated: 2023-01-05',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        height: 1,
                        width: double.infinity,
                        color: Colors.white24,
                      ),
                      const SizedBox(height: 24),
                      _buildTermSection(
                        '1. INFORMATION WE COLLECT',
                        'We collect information you provide directly to us, such as when you create an account, fill out a form, or communicate with us. This may include your name, email address, phone number, and payment information.',
                      ),
                      _buildTermSection(
                        '2. HOW WE USE YOUR INFORMATION',
                        'We use the information we collect to provide, maintain, and improve our services, to process your transactions, to communicate with you, and to protect against fraud or illegal activity.',
                      ),
                      _buildTermSection(
                        '3. SHARING OF INFORMATION',
                        'We do not share your personal information with third parties except as necessary to provide our services, comply with the law, or protect our rights.',
                      ),
                      _buildTermSection(
                        '4. DATA SECURITY',
                        'We implement appropriate technical and organizational measures to protect your personal information against unauthorized access, alteration, disclosure, or destruction.',
                      ),
                      _buildTermSection(
                        '5. YOUR RIGHTS',
                        'You have the right to access, correct, or delete your personal information. You may also object to or restrict certain processing of your data.',
                      ),
                      _buildTermSection(
                        '6. COOKIES AND TRACKING',
                        'We use cookies and similar tracking technologies to collect information about your browsing activities and to personalize your experience.',
                      ),
                      _buildTermSection(
                        '7. CHILDREN\'S PRIVACY',
                        'Our services are not directed to children under 13. We do not knowingly collect personal information from children under 13.',
                      ),
                      _buildTermSection(
                        '8. CHANGES TO THIS POLICY',
                        'We may update this privacy policy from time to time. We will notify you of any changes by posting the new policy on this page.',
                      ),
                      _buildTermSection(
                        '9. CONTACT US',
                        'If you have any questions about this Privacy Policy, please contact us at privacy@fuelconnect.com.',
                      ),
                    ],
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
          // Accept button
          Padding(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _hasScrolledToBottom ? widget.onAccept : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC8A84B),
                  foregroundColor: Colors.black,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  disabledBackgroundColor: const Color(0xFFC8A84B).withOpacity(0.3),
                ),
                child: const Text(
                  'Accept',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFFC8A84B),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}