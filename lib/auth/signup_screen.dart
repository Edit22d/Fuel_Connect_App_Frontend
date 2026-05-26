import 'package:flutter/material.dart';
import 'dart:async';
import '../services/auth_service.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _auth = AuthService();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _referralController = TextEditingController();
  final TextEditingController _vehicleTypeController = TextEditingController();
  final TextEditingController _vehicleNumberController = TextEditingController();
  final TextEditingController _licenseController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  String _userType = "customer";
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = false;
  bool _isLoading = false;

  // Regex patterns matching Django backend validation
  static final String _fullNamePattern = r"^[a-zA-Z]+(?: [a-zA-Z]+)+$";
  static final String _phonePattern = r"^\+\d{1,4}[\s\-]?\d{3}[\s\-]?\d{3}[\s\-]?\d{3,4}$";
  static final String _passwordPattern = r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$";

  static final _nameRegex = RegExp(_fullNamePattern);
  static final _phoneRegex = RegExp(_phonePattern);
  static final _passRegex = RegExp(_passwordPattern);

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _referralController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _vehicleTypeController.dispose();
    _vehicleNumberController.dispose();
    _licenseController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  // ──────────────────────────────────────────────────────────────
  // ✅ INTEGRATED SIGN UP HANDLER — Backend Aligned
  // ──────────────────────────────────────────────────────────────
  Future<void> _handleSignUp() async {
    final fullName = _fullNameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();
    final location = _locationController.text.trim();

    // 1️⃣ Empty field validation
    if (fullName.isEmpty || email.isEmpty || phone.isEmpty || 
        password.isEmpty || confirmPassword.isEmpty || location.isEmpty) {
      _showError('All fields are required');
      return;
    }

    // 2️⃣ Format validation with SPECIFIC helpful messages
    if (!_nameRegex.hasMatch(fullName)) {
      _showError('Enter a valid full name (first and last name, letters only)');
      return;
    }
    if (!_phoneRegex.hasMatch(phone)) {
      _showError('Phone must start with + and be 11+ chars. Example: +256 744 692 050');
      return;
    }
    if (!_passRegex.hasMatch(password)) {
      _showError('Password must have 8+ chars, uppercase, lowercase, number, and symbol');
      return;
    }
    if (password != confirmPassword) {
      _showError('Passwords do not match');
      return;
    }

    // 3️⃣ Driver-specific validation (only if userType is driver)
    if (_userType == "driver") {
      final vType = _vehicleTypeController.text.trim();
      final vNum = _vehicleNumberController.text.trim();
      final license = _licenseController.text.trim();
      if (vType.isEmpty) { _showError('Vehicle type is required for drivers'); return; }
      if (vNum.isEmpty) { _showError('Vehicle number is required for drivers'); return; }
      if (license.isEmpty) { _showError('License number is required for drivers'); return; }
    }

    // 4️⃣ Terms agreement check
    if (!_agreeToTerms) {
      _showError('Please agree to the Terms of Service and Privacy Policy');
      return;
    }

    // 5️⃣ Submit to backend with ALL required fields
    setState(() => _isLoading = true);
    
    try {
      final result = await _auth.register(
        fullName: fullName,
        email: email,
        phoneNumber: phone,
        password: password,
        confirmPassword: confirmPassword,
        // ✅ Pass ALL fields that Django RegisterSerializer expects:
        userType: _userType,
        location: location,
        referralCode: _referralController.text.trim(),
        // ✅ Driver fields (only sent when userType is 'driver')
        vehicleType: _userType == 'driver' ? _vehicleTypeController.text.trim() : null,
        vehicleNumber: _userType == 'driver' ? _vehicleNumberController.text.trim() : null,
        licenseNumber: _userType == 'driver' ? _licenseController.text.trim() : null,
      ).timeout(const Duration(seconds: 15));

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (result['success'] == true) {
        _showSuccess(result['message'] ?? 'Account created! Please log in.');
        // Navigate to login after short delay to show success message
        Future.delayed(const Duration(milliseconds: 1500), () {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            );
          }
        });
      } else {
        // Show specific backend error (email/phone already exists, etc.)
        _showError(result['message'] ?? 'Registration failed. Please try again.');
      }
    } on TimeoutException {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showError('Request timed out. Please check your connection and try again.');
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showError('Registration failed: ${e.toString()}');
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _showSuccess(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showTermsSheet(String type) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _TermsBottomSheet(
        type: type,
        onAccept: () {
          setState(() => _agreeToTerms = true);
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
        child: Column(
          children: [
            // ============================================================
            // LAYER 1: Background Layer (Logo top, Sign In bottom)
            // ============================================================
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    width: 80, height: 80, fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.local_gas_station, size: 45, color: Color(0xFFC8A84B)),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'FUEL CONNECT PORTAL',
                    style: TextStyle(color: Color(0xFF888888), fontSize: 9, letterSpacing: 1.5, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
  
            // ============================================================
            // LAYER 2: Premium Card Container (Signup Form)
            // ============================================================
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 420),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFF141414),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF2A2A2A)),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 25, offset: const Offset(0, 12)),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        const Center(
                          child: Text(
                            'Create Account',
                            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800),
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Center(
                          child: Text(
                            'Join the Fuel Connect network and optimise your performance',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Color(0xFF888888), fontSize: 11, height: 1.4),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Form Fields
                        _buildLabel('FULL NAME'),
                        const SizedBox(height: 6),
                        _buildTextField(controller: _fullNameController, hintText: 'John Doe', prefixIcon: Icons.person_outline),
                        const SizedBox(height: 14),

                        _buildLabel('EMAIL ADDRESS'),
                        const SizedBox(height: 6),
                        _buildTextField(controller: _emailController, hintText: 'name@example.com', prefixIcon: Icons.email_outlined, keyboardType: TextInputType.emailAddress),
                        const SizedBox(height: 14),

                        _buildLabel('PHONE NUMBER'),
                        const SizedBox(height: 6),
                        _buildTextField(controller: _phoneController, hintText: '+256 740 000-0000', prefixIcon: Icons.phone_outlined, keyboardType: TextInputType.phone),
                        const SizedBox(height: 14),

                        _buildLabel('PASSWORD'),
                        const SizedBox(height: 6),
                        _buildTextField(
                          controller: _passwordController,
                          hintText: '············',
                          prefixIcon: Icons.lock_outline,
                          obscureText: _obscurePassword,
                          suffixIcon: _buildVisibilityToggle(_obscurePassword, () => setState(() => _obscurePassword = !_obscurePassword)),
                        ),
                        const SizedBox(height: 14),

                        _buildLabel('CONFIRM PASSWORD'),
                        const SizedBox(height: 6),
                        _buildTextField(
                          controller: _confirmPasswordController,
                          hintText: '••••••••',
                          prefixIcon: Icons.lock_outline,
                          obscureText: _obscureConfirmPassword,
                          suffixIcon: _buildVisibilityToggle(_obscureConfirmPassword, () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword)),
                        ),
                        const SizedBox(height: 14),

                        _buildLabel('USER TYPE'),
                        const SizedBox(height: 6),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A1A1A),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFF2A2A2A)),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _userType,
                              dropdownColor: const Color(0xFF1A1A1A),
                              iconEnabledColor: const Color(0xFF666666),
                              isExpanded: true,
                              items: const [
                                DropdownMenuItem(value: "customer", child: Text("Customer", style: TextStyle(color: Colors.white, fontSize: 13))),
                                DropdownMenuItem(value: "driver", child: Text("Driver", style: TextStyle(color: Colors.white, fontSize: 13))),
                              ],
                              onChanged: (val) => setState(() => _userType = val.toString()),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),

                        _buildLabel('LOCATION'),
                        const SizedBox(height: 6),
                        _buildTextField(controller: _locationController, hintText: 'Enter your location', prefixIcon: Icons.location_on_outlined),

                        // ✅ Driver fields shown conditionally
                        if (_userType == "driver") ...[
                          const SizedBox(height: 14),
                          _buildLabel('VEHICLE TYPE'),
                          const SizedBox(height: 6),
                          _buildTextField(controller: _vehicleTypeController, hintText: 'Motorcycle', prefixIcon: Icons.directions_car_outlined),
                          const SizedBox(height: 14),
                          _buildLabel('VEHICLE NUMBER'),
                          const SizedBox(height: 6),
                          _buildTextField(controller: _vehicleNumberController, hintText: 'UAX 123A', prefixIcon: Icons.pin_outlined),
                          const SizedBox(height: 14),
                          _buildLabel('LICENSE NUMBER'),
                          const SizedBox(height: 6),
                          _buildTextField(controller: _licenseController, hintText: 'DL123456', prefixIcon: Icons.badge_outlined),
                        ],

                        const SizedBox(height: 16),
                        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          SizedBox(
                            width: 18, height: 18,
                            child: Checkbox(
                              value: _agreeToTerms,
                              onChanged: (val) => setState(() => _agreeToTerms = val ?? false),
                              activeColor: const Color(0xFFC8A84B),
                              checkColor: Colors.black,
                              side: const BorderSide(color: Color(0xFF555555)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(text: 'I agree to the ', style: TextStyle(color: Color(0xFF888888), fontSize: 11, height: 1.4)),
                                  WidgetSpan(child: GestureDetector(onTap: () => _showTermsSheet('Terms of Service'), child: const Text('Terms of Service', style: TextStyle(color: Color(0xFFC8A84B), fontSize: 11, fontWeight: FontWeight.w500)))),
                                  const TextSpan(text: ' and ', style: TextStyle(color: Color(0xFF888888), fontSize: 11)),
                                  WidgetSpan(child: GestureDetector(onTap: () => _showTermsSheet('Privacy Policy'), child: const Text('Privacy Policy', style: TextStyle(color: Color(0xFFC8A84B), fontSize: 11, fontWeight: FontWeight.w500)))),
                                ],
                              ),
                            ),
                          ),
                        ]),

                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity, height: 44,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleSignUp,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFC8A84B),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              disabledBackgroundColor: const Color(0xFFC8A84B).withOpacity(0.5),
                            ),
                            child: _isLoading
                                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                                : const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                    Text('Sign Up', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                                    SizedBox(width: 6),
                                    Icon(Icons.arrow_forward, size: 16),
                                  ]),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // ============================================================
            // BOTTOM: Sign In Link (Layer 1 continuation)
            // ============================================================
            Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(text: "Already part of the fleet?  ", style: TextStyle(color: Color(0xFF888888), fontSize: 12)),
                      TextSpan(text: 'Sign In', style: TextStyle(color: Color(0xFFC8A84B), fontSize: 12, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget for password visibility toggle
  Widget _buildVisibilityToggle(bool isObscured, VoidCallback onToggle) {
    return IconButton(
      icon: Icon(
        isObscured ? Icons.visibility_off_outlined : Icons.visibility_outlined,
        color: const Color(0xFF666666),
        size: 18,
      ),
      onPressed: onToggle,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
    );
  }

  Widget _buildLabel(String text) {
    return Text(text, style: const TextStyle(color: Color(0xFF888888), fontSize: 10, letterSpacing: 1.0, fontWeight: FontWeight.w600));
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
        style: const TextStyle(color: Colors.white, fontSize: 13),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Color(0xFF555555), fontSize: 13),
          prefixIcon: Icon(prefixIcon, color: const Color(0xFF666666), size: 18),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Bottom Sheet Widget (Unchanged - Terms & Privacy)
// ─────────────────────────────────────────────────────────────────────────────

class _TermsBottomSheet extends StatefulWidget {
  final String type;
  final VoidCallback onAccept;
  const _TermsBottomSheet({required this.type, required this.onAccept});
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
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification notification) {
                if (!_hasScrolledToBottom && 
                    notification.metrics.pixels >= notification.metrics.maxScrollExtent - 10) {
                  setState(() => _hasScrolledToBottom = true);
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
                      Container(height: 1, width: double.infinity, color: const Color(0xFFC8A84B)),
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
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      const SizedBox(height: 24),
                      Container(height: 1, width: double.infinity, color: Colors.white24),
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
                      Container(height: 1, width: double.infinity, color: const Color(0xFFC8A84B)),
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
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      const SizedBox(height: 24),
                      Container(height: 1, width: double.infinity, color: Colors.white24),
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
                            disabledBackgroundColor: const Color(0xFFC8A84B).withValues(alpha: 0.3),
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