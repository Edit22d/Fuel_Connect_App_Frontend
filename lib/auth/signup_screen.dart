import 'package:flutter/material.dart';
import 'dart:async';
import '../services/auth_service.dart';
import 'login_screen.dart';
import 'theme.dart';

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

  Future<void> _handleSignUp() async {
    final fullName = _fullNameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();
    final location = _locationController.text.trim();

    // DEMO BYPASS: Register directly for offline click-through testing.
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() => _isLoading = false);
    _showSuccess('Account created! (Demo Mode)');
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
    return;

    /* Original Integration:
    if (fullName.isEmpty || email.isEmpty || phone.isEmpty || 
        password.isEmpty || confirmPassword.isEmpty || location.isEmpty) {
      _showError('All fields are required');
      return;
    }

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

    if (_userType == "driver") {
      final vType = _vehicleTypeController.text.trim();
      final vNum = _vehicleNumberController.text.trim();
      final license = _licenseController.text.trim();
      if (vType.isEmpty) { _showError('Vehicle type is required for drivers'); return; }
      if (vNum.isEmpty) { _showError('Vehicle number is required for drivers'); return; }
      if (license.isEmpty) { _showError('License number is required for drivers'); return; }
    }

    if (!_agreeToTerms) {
      _showError('Please agree to the Terms of Service and Privacy Policy');
      return;
    }

    setState(() => _isLoading = true);
    
    try {
      final result = await _auth.register(
        fullName: fullName,
        email: email,
        phoneNumber: phone,
        password: password,
        confirmPassword: confirmPassword,
        userType: _userType,
        location: location,
        referralCode: _referralController.text.trim(),
        vehicleType: _userType == 'driver' ? _vehicleTypeController.text.trim() : null,
        vehicleNumber: _userType == 'driver' ? _vehicleNumberController.text.trim() : null,
        licenseNumber: _userType == 'driver' ? _licenseController.text.trim() : null,
      ).timeout(const Duration(seconds: 15));

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (result['success'] == true) {
        _showSuccess(result['message'] ?? 'Account created! Please log in.');
        Future.delayed(const Duration(milliseconds: 1500), () {
          if (mounted) {
            Navigator.pushReplacementNamed(context, '/login');
          }
        });
      } else {
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
    */
  }

  Future<void> _handleGoogleSignUp() async {
    _showError('Google Sign-Up coming soon!');
  }

  Future<void> _handleAppleSignUp() async {
    _showError('Apple Sign-Up coming soon!');
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.redAccent, behavior: SnackBarBehavior.floating, duration: const Duration(seconds: 4)),
    );
  }

  void _showSuccess(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green, behavior: SnackBarBehavior.floating, duration: const Duration(seconds: 3)),
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.iconTheme.color),
          onPressed: () => Navigator.pop(context),
        ),
        actions: const [
          ThemeToggleButton(),
        ],
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
                    constraints: const BoxConstraints(maxWidth: 420),
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Center(child: FuelConnectLogo(fontSize: 32)),
                        const SizedBox(height: 8),
                        Center(
                          child: Text(
                            'FUEL CONNECT PORTAL',
                            style: TextStyle(
                              color: theme.textTheme.bodyMedium?.color,
                              fontSize: 9,
                              letterSpacing: 1.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          'Create Account',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: theme.textTheme.bodyLarge?.color,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Join the Fuel Connect network and optimise your performance',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: theme.textTheme.bodyMedium?.color,
                            fontSize: 12,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Form Fields
                        _buildLabel('FULL NAME', theme),
                        const SizedBox(height: 6),
                        _buildTextField(controller: _fullNameController, hintText: 'John Doe', prefixIcon: Icons.person_outline, theme: theme),
                        const SizedBox(height: 16),

                        _buildLabel('EMAIL ADDRESS', theme),
                        const SizedBox(height: 6),
                        _buildTextField(controller: _emailController, hintText: 'name@example.com', prefixIcon: Icons.email_outlined, keyboardType: TextInputType.emailAddress, theme: theme),
                        const SizedBox(height: 16),

                        _buildLabel('PHONE NUMBER', theme),
                        const SizedBox(height: 6),
                        _buildTextField(controller: _phoneController, hintText: '+256 740 000-0000', prefixIcon: Icons.phone_outlined, keyboardType: TextInputType.phone, theme: theme),
                        const SizedBox(height: 16),

                        _buildLabel('PASSWORD', theme),
                        const SizedBox(height: 6),
                        _buildTextField(
                          controller: _passwordController,
                          hintText: '············',
                          prefixIcon: Icons.lock_outline,
                          obscureText: _obscurePassword,
                          theme: theme,
                          suffixIcon: _buildVisibilityToggle(_obscurePassword, () => setState(() => _obscurePassword = !_obscurePassword), theme),
                        ),
                        const SizedBox(height: 16),

                        _buildLabel('CONFIRM PASSWORD', theme),
                        const SizedBox(height: 6),
                        _buildTextField(
                          controller: _confirmPasswordController,
                          hintText: '••••••••',
                          prefixIcon: Icons.lock_outline,
                          obscureText: _obscureConfirmPassword,
                          theme: theme,
                          suffixIcon: _buildVisibilityToggle(_obscureConfirmPassword, () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword), theme),
                        ),
                        const SizedBox(height: 16),

                        _buildLabel('USER TYPE', theme),
                        const SizedBox(height: 6),
                        Container(
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF0F0F0),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: theme.dividerColor),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _userType,
                              dropdownColor: theme.colorScheme.surface,
                              iconEnabledColor: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                              isExpanded: true,
                              items: [
                                DropdownMenuItem(value: "customer", child: Text("Customer", style: TextStyle(color: theme.textTheme.bodyLarge?.color, fontSize: 14))),
                                DropdownMenuItem(value: "driver", child: Text("Driver", style: TextStyle(color: theme.textTheme.bodyLarge?.color, fontSize: 14))),
                              ],
                              onChanged: (val) => setState(() => _userType = val.toString()),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        _buildLabel('LOCATION', theme),
                        const SizedBox(height: 6),
                        _buildTextField(controller: _locationController, hintText: 'Enter your location', prefixIcon: Icons.location_on_outlined, theme: theme),

                        if (_userType == "driver") ...[
                          const SizedBox(height: 16),
                          _buildLabel('VEHICLE TYPE', theme),
                          const SizedBox(height: 6),
                          _buildTextField(controller: _vehicleTypeController, hintText: 'Motorcycle', prefixIcon: Icons.directions_car_outlined, theme: theme),
                          const SizedBox(height: 16),
                          _buildLabel('VEHICLE NUMBER', theme),
                          const SizedBox(height: 6),
                          _buildTextField(controller: _vehicleNumberController, hintText: 'UAX 123A', prefixIcon: Icons.pin_outlined, theme: theme),
                          const SizedBox(height: 16),
                          _buildLabel('LICENSE NUMBER', theme),
                          const SizedBox(height: 6),
                          _buildTextField(controller: _licenseController, hintText: 'DL123456', prefixIcon: Icons.badge_outlined, theme: theme),
                        ],

                        const SizedBox(height: 24),
                        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          SizedBox(
                            width: 20, height: 20,
                            child: Checkbox(
                              value: _agreeToTerms,
                              onChanged: (val) => setState(() => _agreeToTerms = val ?? false),
                              activeColor: AppTheme.gold,
                              checkColor: Colors.white,
                              side: BorderSide(color: theme.dividerColor, width: 2),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(text: 'I agree to the ', style: TextStyle(color: theme.textTheme.bodyMedium?.color, fontSize: 12, height: 1.4)),
                                  WidgetSpan(child: GestureDetector(onTap: () => _showTermsSheet('Terms of Service'), child: const Text('Terms of Service', style: TextStyle(color: AppTheme.gold, fontSize: 12, fontWeight: FontWeight.w700)))),
                                  TextSpan(text: ' and ', style: TextStyle(color: theme.textTheme.bodyMedium?.color, fontSize: 12)),
                                  WidgetSpan(child: GestureDetector(onTap: () => _showTermsSheet('Privacy Policy'), child: const Text('Privacy Policy', style: TextStyle(color: AppTheme.gold, fontSize: 12, fontWeight: FontWeight.w700)))),
                                ],
                              ),
                            ),
                          ),
                        ]),

                        const SizedBox(height: 28),
                        GoldButton(
                          text: _isLoading ? 'SIGNING UP...' : 'SIGN UP',
                          onPressed: _isLoading ? () {} : _handleSignUp,
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(child: Divider(color: theme.dividerColor, thickness: 1)),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                'OR SIGN UP WITH',
                                style: TextStyle(
                                  color: theme.textTheme.bodyMedium?.color,
                                  fontSize: 10,
                                  letterSpacing: 1.2,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Expanded(child: Divider(color: theme.dividerColor, thickness: 1)),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: _SocialButton(
                                label: 'GOOGLE',
                                icon: const _GoogleIcon(),
                                theme: theme,
                                onPressed: _handleGoogleSignUp,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _SocialButton(
                                label: 'APPLE',
                                icon: _AppleIcon(isDark: isDark),
                                theme: theme,
                                onPressed: _handleAppleSignUp,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Center(
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(text: "Already part of the fleet?  ", style: TextStyle(color: theme.textTheme.bodyMedium?.color, fontSize: 13)),
                                  const TextSpan(text: 'Sign In', style: TextStyle(color: AppTheme.gold, fontSize: 13, fontWeight: FontWeight.w800)),
                                ],
                              ),
                            ),
                          ),
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

  Widget _buildVisibilityToggle(bool isObscured, VoidCallback onToggle, ThemeData theme) {
    return IconButton(
      icon: Icon(
        isObscured ? Icons.visibility_off_outlined : Icons.visibility_outlined,
        color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
        size: 18,
      ),
      onPressed: onToggle,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
    );
  }

  Widget _buildLabel(String text, ThemeData theme) {
    return Text(text, style: TextStyle(color: theme.textTheme.bodyMedium?.color, fontSize: 10, letterSpacing: 1.2, fontWeight: FontWeight.w700));
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    required ThemeData theme,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    final isDark = theme.brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF0F0F0);

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: theme.dividerColor),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: TextStyle(color: theme.textTheme.bodyLarge?.color, fontSize: 14),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5), fontSize: 14),
          prefixIcon: Icon(prefixIcon, color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6), size: 20),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Bottom Sheet Widget (Terms & Privacy)
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.dividerColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            widget.type,
            style: const TextStyle(
              color: AppTheme.gold,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 1,
            margin: const EdgeInsets.symmetric(horizontal: 24),
            color: theme.dividerColor,
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
                            color: AppTheme.gold,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(height: 1, width: double.infinity, color: AppTheme.gold),
                      const SizedBox(height: 20),
                      const Text(
                        'Terms of Service',
                        style: TextStyle(
                          color: AppTheme.gold,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Last updated: 2026-01-04',
                        style: TextStyle(color: theme.textTheme.bodyMedium?.color, fontSize: 14),
                      ),
                      const SizedBox(height: 24),
                      Container(height: 1, width: double.infinity, color: theme.dividerColor),
                      const SizedBox(height: 24),
                      _buildTermSection(
                        '1. ACCEPTANCE OF TERMS',
                        'By accessing this app and the FanZone® application, you agree to be bound by these terms. You may not access or use the app if you do not accept these terms. If you continue to access or use the app after reading these terms, your continued access constitutes acceptance of these terms.',
                        theme,
                      ),
                      _buildTermSection(
                        '2. GENERAL DISCLAIMER',
                        'Fan Zone is a platform for fans to share their experiences and connect with other fans. Fan Zone does not endorse any product or service mentioned in the app. Fan Zone is not responsible for any damages that may occur as a result of using the app. Fan Zone disclaims all liability for any losses or damages that may arise from the use of the app.',
                        theme,
                      ),
                      _buildTermSection(
                        '3. USER IDENTIFICATION',
                        'Users are required to provide accurate identification information when registering on the app. Failure to provide accurate identification may result in the temporary suspension of user accounts. Users must also provide accurate contact information when registering on the app.',
                        theme,
                      ),
                      _buildTermSection(
                        '4. PROVIDE AND INTERNET ACCESS',
                        'Fan Zone reserves the right to suspend or terminate an account if it becomes aware of any suspicious activity or if there is evidence of fraudulent behavior. Users are responsible for ensuring they have adequate internet access and connectivity to use the app.',
                        theme,
                      ),
                      _buildTermSection(
                        '5. CANCELLATION POLICY',
                        'Fan Zone has the right to cancel or suspend an account at any time without prior notice. Cancellation policies may vary depending on the type of account and the specific circumstances. Users should review Fan Zone\'s cancellation policy before signing up for an account.',
                        theme,
                      ),
                      _buildTermSection(
                        '6. LIABILITY',
                        'Fan Zone assumes no responsibility for any damages or losses that may occur as a result of using the app. Users should consult with legal professionals before using the app.',
                        theme,
                      ),
                      _buildTermSection(
                        '7. GUARANTEE',
                        'Fan Zone offers a guarantee that the app will work properly for a certain period of time. The length of the guarantee varies depending on the type of account and the specific circumstances. Users should review Fan Zone\'s guarantee policy before using the app.',
                        theme,
                      ),
                      _buildTermSection(
                        '8. TERMINATION',
                        'Fan Zone may terminate or suspend an account if it becomes aware of any violations of these terms. Termination may include the termination of the account and any associated services.',
                        theme,
                      ),
                      _buildTermSection(
                        '9. AGREEMENT TERMS & CONDITIONS',
                        'By using this app, you acknowledge that you have read, understood, and agree to be bound by these Terms & Conditions.',
                        theme,
                      ),
                    ] else ...[
                      const Center(
                        child: Text(
                          'PRIVACY POLICY',
                          style: TextStyle(
                            color: AppTheme.gold,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(height: 1, width: double.infinity, color: AppTheme.gold),
                      const SizedBox(height: 20),
                      const Text(
                        'Privacy Policy',
                        style: TextStyle(
                          color: AppTheme.gold,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Last updated: 2026-06-04',
                        style: TextStyle(color: theme.textTheme.bodyMedium?.color, fontSize: 14),
                      ),
                      const SizedBox(height: 24),
                      Container(height: 1, width: double.infinity, color: theme.dividerColor),
                      const SizedBox(height: 24),
                      _buildTermSection(
                        '1. INFORMATION WE COLLECT',
                        'We collect information you provide directly to us, such as when you create an account, fill out a form, or communicate with us. This may include your name, email address, phone number, and payment information.',
                        theme,
                      ),
                      _buildTermSection(
                        '2. HOW WE USE YOUR INFORMATION',
                        'We use the information we collect to provide, maintain, and improve our services, to process your transactions, to communicate with you, and to protect against fraud or illegal activity.',
                        theme,
                      ),
                      _buildTermSection(
                        '3. SHARING OF INFORMATION',
                        'We do not share your personal information with third parties except as necessary to provide our services, comply with the law, or protect our rights.',
                        theme,
                      ),
                      _buildTermSection(
                        '4. DATA SECURITY',
                        'We implement appropriate technical and organizational measures to protect your personal information against unauthorized access, alteration, disclosure, or destruction.',
                        theme,
                      ),
                      _buildTermSection(
                        '5. YOUR RIGHTS',
                        'You have the right to access, correct, or delete your personal information. You may also object to or restrict certain processing of your data.',
                        theme,
                      ),
                      _buildTermSection(
                        '6. COOKIES AND TRACKING',
                        'We use cookies and similar tracking technologies to collect information about your browsing activities and to personalize your experience.',
                        theme,
                      ),
                      _buildTermSection(
                        '7. CHILDREN\'S PRIVACY',
                        'Our services are not directed to children under 13. We do not knowingly collect personal information from children under 13.',
                        theme,
                      ),
                      _buildTermSection(
                        '8. CHANGES TO THIS POLICY',
                        'We may update this privacy policy from time to time. We will notify you of any changes by posting the new policy on this page.',
                        theme,
                      ),
                      _buildTermSection(
                        '9. CONTACT US',
                        'If you have any questions about this Privacy Policy, please contact us at privacy@fuelconnect.com.',
                        theme,
                      ),
                    ],
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: GoldButton(
                        text: 'Accept',
                        onPressed: _hasScrolledToBottom ? widget.onAccept : () {},
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

  Widget _buildTermSection(String title, String content, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppTheme.gold,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: TextStyle(
            color: theme.textTheme.bodyMedium?.color,
            fontSize: 14,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String label;
  final Widget icon;
  final ThemeData theme;
  final VoidCallback? onPressed;

  const _SocialButton({
    required this.label,
    required this.icon,
    required this.theme,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = theme.brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF0F0F0);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 44,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: theme.dividerColor),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: theme.textTheme.bodyLarge?.color,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GoogleIcon extends StatelessWidget {
  const _GoogleIcon();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 18,
      height: 18,
      child: CustomPaint(painter: _GooglePainter()),
    );
  }
}

class _GooglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2;

    canvas.drawCircle(Offset(cx, cy), r, Paint()..color = Colors.white);

    const segments = [
      (0.0, 1.57, Color(0xFF4285F4)),
      (1.57, 3.14, Color(0xFF34A853)),
      (3.14, 4.71, Color(0xFFFBBC05)),
      (4.71, 6.28, Color(0xFFEA4335)),
    ];
    for (final seg in segments) {
      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: r * 0.7),
        seg.$1,
        seg.$2 - seg.$1,
        false,
        Paint()
          ..color = seg.$3
          ..style = PaintingStyle.stroke
          ..strokeWidth = size.width * 0.2,
      );
    }

    canvas.drawCircle(Offset(cx, cy), r * 0.45, Paint()..color = Colors.white);

    canvas.drawLine(
      Offset(cx, cy),
      Offset(cx + r * 0.65, cy),
      Paint()
        ..color = const Color(0xFF4285F4)
        ..strokeWidth = size.height * 0.18
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _AppleIcon extends StatelessWidget {
  final bool isDark;
  const _AppleIcon({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 18,
      height: 18,
      child: CustomPaint(painter: _ApplePainter(isDark: isDark)),
    );
  }
}

class _ApplePainter extends CustomPainter {
  final bool isDark;
  _ApplePainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    final color = isDark ? Colors.white : Colors.black;

    path.moveTo(size.width * 0.5, size.height * 0.15);
    path.cubicTo(
      size.width * 0.5, size.height * 0.15,
      size.width * 0.42, size.height * 0.05,
      size.width * 0.3, size.height * 0.08,
    );
    path.cubicTo(
      size.width * 0.18, size.height * 0.11,
      size.width * 0.12, size.height * 0.25,
      size.width * 0.15, size.height * 0.38,
    );
    path.cubicTo(
      size.width * 0.18, size.height * 0.51,
      size.width * 0.32, size.height * 0.62,
      size.width * 0.45, size.height * 0.6,
    );
    path.cubicTo(
      size.width * 0.58, size.height * 0.58,
      size.width * 0.7, size.height * 0.48,
      size.width * 0.72, size.height * 0.4,
    );
    path.cubicTo(
      size.width * 0.74, size.height * 0.32,
      size.width * 0.68, size.height * 0.22,
      size.width * 0.58, size.height * 0.2,
    );
    path.cubicTo(
      size.width * 0.48, size.height * 0.18,
      size.width * 0.5, size.height * 0.15,
      size.width * 0.5, size.height * 0.15,
    );
    path.close();

    path.moveTo(size.width * 0.58, size.height * 0.18);
    path.cubicTo(
      size.width * 0.65, size.height * 0.12,
      size.width * 0.75, size.height * 0.1,
      size.width * 0.8, size.height * 0.15,
    );
    path.cubicTo(
      size.width * 0.85, size.height * 0.2,
      size.width * 0.78, size.height * 0.3,
      size.width * 0.7, size.height * 0.32,
    );
    path.close();

    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}