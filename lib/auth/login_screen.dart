// =============================================================================
// login_screen.dart
//
// FLUTTER LAYOUT MODEL (applied throughout this file)
// ────────────────────────────────────────────────────
// "Constraints go down. Sizes go up. Parent sets position."
//
//  Widget     | Main axis  | Key property used here
//  ───────────┼────────────┼───────────────────────────────────────────────
//  Row        | horizontal | mainAxisAlignment, crossAxisAlignment
//  Column     | vertical   | crossAxisAlignment: start (left-align text)
//  Expanded   | —          | fills ALL remaining space on the main axis
//  SizedBox   | —          | fixed gap (vertical inside Column, horizontal inside Row)
//
// NESTED ROUTE MAP
// ────────────────
//  _goToHome()            → HomeScreen          (pushReplacement after login)
//  _goToSignUp()          → SignUpScreen         (footer "Create Account")
//  _goToForgotPassword()  → ForgotPasswordScreen (label row, right side)
// =============================================================================

import 'package:flutter/material.dart';
import 'dart:async';
import '../services/auth_service.dart';
import 'signup_screen.dart';
import '../screens/home_screen.dart';
import '../password/forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // ── Services ───────────────────────────────────────────────────────────────
  final _auth = AuthService();

  // ── Controllers ───────────────────────────────────────────────────────────
  final TextEditingController _emailController    = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // ── UI state ──────────────────────────────────────────────────────────────
  bool _obscurePassword = true;
  bool _isLoading       = false;

  // ── Validation patterns ───────────────────────────────────────────────────
  static final _emailOrPhoneRegex = RegExp(
    r'^(\+\d{1,4}[\s\-]?\d{3}[\s\-]?\d{3}[\s\-]?\d{3,4}|[^@]+@[^@]+\.[^@]+)$',
  );
  static final _passwordRegex = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$',
  );

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ── Named navigation helpers (nested routes) ──────────────────────────────

  void _goToHome() => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );

  void _goToSignUp() => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SignUpScreen()),
      );

  void _goToForgotPassword() => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
      );

  // ── Login handler ─────────────────────────────────────────────────────────
  Future<void> _handleLogin() async {
    final email    = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty && password.isEmpty) {
      _showError('Please enter credentials before continuing');
      return;
    }
    if (email.isEmpty || password.isEmpty) {
      _showError('All fields are required');
      return;
    }
    if (!_emailOrPhoneRegex.hasMatch(email) ||
        !_passwordRegex.hasMatch(password)) {
      _showError('Invalid credentials, please enter correct credentials');
      return;
    }

    setState(() => _isLoading = true);
    try {
      final result = await _auth
          .login(emailOrPhone: email, password: password)
          .timeout(
            const Duration(seconds: 1),
            onTimeout: () => throw TimeoutException('Timed out'),
          );

      if (!mounted) return;
      setState(() => _isLoading = false);

      result['success'] == true
          ? _goToHome()
          : _showError(result['message'] ?? 'Login failed.');
    } on TimeoutException {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showError('Login took too long. Please try again.');
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showError('An error occurred. Please try again.');
    }
  }

  void _showError(String msg) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
        ),
      );

  // ══════════════════════════════════════════════════════════════════════════
  // BUILD
  // ══════════════════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: SafeArea(

        // ╔══════════════════════════════════════════════════════════════════╗
        // ║  LAYER 0 · OUTER ROW                                            ║
        // ║                                                                  ║
        // ║  Purpose : mirrors ProductCard's top-level Row so the single    ║
        // ║            Expanded child absorbs all horizontal screen width.  ║
        // ║                                                                  ║
        // ║  mainAxisSize    : max   → stretches edge-to-edge               ║
        // ║  crossAxisAlign  : stretch (default) → fills full height        ║
        // ╚══════════════════════════════════════════════════════════════════╝
        child: Row(
          children: [

            // Expanded on the main axis (horizontal) → takes ALL width
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),

                // ╔════════════════════════════════════════════════════════╗
                // ║  LAYER 1 · ROOT COLUMN                                 ║
                // ║                                                        ║
                // ║  Stacks every screen section vertically top → bottom. ║
                // ║  crossAxisAlignment: start  →  children align LEFT.   ║
                // ╚════════════════════════════════════════════════════════╝
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const SizedBox(height: 32), // ← vertical gap (Column)

                    // ┌──────────────────────────────────────────────────┐
                    // │  SECTION 1 · LOGO BLOCK                          │
                    // │                                                  │
                    // │  Row(mainAxisAlignment: center)                  │
                    // │  └── Column(crossAxisAlignment: center)          │
                    // │      ├── Image  (logo)                           │
                    // │      ├── SizedBox(h: 8)   ← vertical gap        │
                    // │      └── Text  "FUEL CONNECT PORTAL"             │
                    // │                                                  │
                    // │  Outer Row centres the Column horizontally.      │
                    // │  Inner Column stacks logo above the subtitle.    │
                    // └──────────────────────────────────────────────────┘
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [

                            Image.asset(
                              'assets/images/logo.png',
                              width: 100,
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => const Icon(
                                Icons.local_gas_station,
                                size: 60,
                                color: Colors.white,
                              ),
                            ),

                            const SizedBox(height: 8), // vertical gap

                            const Text(
                              'FUEL CONNECT PORTAL',
                              style: TextStyle(
                                color: Color(0xFF888888),
                                fontSize: 11,
                                letterSpacing: 2.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                          ],
                        ),
                      ],
                    ),
                    // END SECTION 1 ─────────────────────────────────────

                    const SizedBox(height: 36),

                    // ┌──────────────────────────────────────────────────┐
                    // │  SECTION 2 · WELCOME HEADER                      │
                    // │                                                  │
                    // │  Column(crossAxisAlignment: start)               │
                    // │  ├── Text  "Welcome back"                        │
                    // │  ├── SizedBox(h: 6)                              │
                    // │  └── Text  "Please enter your credentials…"      │
                    // │                                                  │
                    // │  start alignment → both texts hug the left edge. │
                    // └──────────────────────────────────────────────────┘
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [

                        Text(
                          'Welcome back',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        SizedBox(height: 6),

                        Text(
                          'Please enter your credentials to access\nyour account.',
                          style: TextStyle(
                            color: Color(0xFF888888),
                            fontSize: 13,
                            height: 1.5,
                          ),
                        ),

                      ],
                    ),
                    // END SECTION 2 ─────────────────────────────────────

                    const SizedBox(height: 28),

                    // ┌──────────────────────────────────────────────────┐
                    // │  SECTION 3 · EMAIL OR PHONE FIELD                │
                    // │                                                  │
                    // │  Column(crossAxisAlignment: start)               │
                    // │  ├── Text  "EMAIL OR PHONE"  ← caps label        │
                    // │  ├── SizedBox(h: 8)                              │
                    // │  └── _buildTextField(...)                        │
                    // │      └── internally: Row(icon | input | suffix) │
                    // └──────────────────────────────────────────────────┘
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        const Text(
                          'EMAIL OR PHONE',
                          style: TextStyle(
                            color: Color(0xFF888888),
                            fontSize: 11,
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 8),

                        _buildTextField(
                          controller: _emailController,
                          hintText: 'name@company.com',
                          prefixIcon: Icons.person_outline,
                          keyboardType: TextInputType.emailAddress,
                        ),

                      ],
                    ),
                    // END SECTION 3 ─────────────────────────────────────

                    const SizedBox(height: 20),

                    // ┌──────────────────────────────────────────────────┐
                    // │  SECTION 4 · PASSWORD FIELD                      │
                    // │                                                  │
                    // │  Column(crossAxisAlignment: start)               │
                    // │  ├── Row(mainAxisAlignment: spaceBetween)        │
                    // │  │   ├── Text "PASSWORD"       ← pushed LEFT     │
                    // │  │   └── GestureDetector       ← pushed RIGHT    │
                    // │  │       └── Text "FORGOT PASSWORD?"             │
                    // │  ├── SizedBox(h: 8)                              │
                    // │  └── _buildTextField(obscure: true, suffix: eye) │
                    // │                                                  │
                    // │  spaceBetween: first child → left, last → right. │
                    // │  GestureDetector.onTap → _goToForgotPassword()   │
                    // │  (nested route)                                  │
                    // └──────────────────────────────────────────────────┘
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // Label row ────────────────────────────────────
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            // Left: field label
                            const Text(
                              'PASSWORD',
                              style: TextStyle(
                                color: Color(0xFF888888),
                                fontSize: 11,
                                letterSpacing: 1.2,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            // Right: forgot-password link (nested route)
                            GestureDetector(
                              onTap: _goToForgotPassword,
                              child: const Text(
                                'FORGOT PASSWORD?',
                                style: TextStyle(
                                  color: Color(0xFFC8A84B),
                                  fontSize: 11,
                                  letterSpacing: 1.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),

                          ],
                        ),

                        const SizedBox(height: 8),

                        // Password input field
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
                            onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword,
                            ),
                          ),
                        ),

                      ],
                    ),
                    // END SECTION 4 ─────────────────────────────────────

                    const SizedBox(height: 32),

                    // ┌──────────────────────────────────────────────────┐
                    // │  SECTION 5 · LOG IN BUTTON                       │
                    // │                                                  │
                    // │  SizedBox(w: ∞, h: 50)                           │
                    // │  └── ElevatedButton                              │
                    // │      └── Row(mainAxisSize: min)                  │
                    // │          ├── Text "LOG IN"                       │
                    // │          ├── SizedBox(w: 8)  ← horizontal gap   │
                    // │          └── Icon(arrow_forward)                 │
                    // │                                                  │
                    // │  mainAxisSize.min → Row wraps tightly around     │
                    // │  its children; ElevatedButton then centres them. │
                    // └──────────────────────────────────────────────────┘
                    _YellowButton(
                      isLoading: _isLoading,
                      onPressed: _isLoading ? null : _handleLogin,
                    ),
                    // END SECTION 5 ─────────────────────────────────────

                    const SizedBox(height: 28),

                    // ┌──────────────────────────────────────────────────┐
                    // │  SECTION 6 · "OR CONTINUE WITH" DIVIDER          │
                    // │                                                  │
                    // │  Row([                                           │
                    // │    Expanded → Divider,   ← fills left space     │
                    // │    Padding  → Text,                              │
                    // │    Expanded → Divider,   ← fills right space    │
                    // │  ])                                              │
                    // │                                                  │
                    // │  Both Expanded widgets share leftover width      │
                    // │  equally after the label takes its natural size. │
                    // └──────────────────────────────────────────────────┘
                    Row(
                      children: const [

                        Expanded(
                          child: Divider(color: Color(0xFF2A2A2A), thickness: 1),
                        ),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            'OR CONTINUE WITH',
                            style: TextStyle(
                              color: Color(0xFF555555),
                              fontSize: 10,
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                        Expanded(
                          child: Divider(color: Color(0xFF2A2A2A), thickness: 1),
                        ),

                      ],
                    ),
                    // END SECTION 6 ─────────────────────────────────────

                    const SizedBox(height: 20),

                    // ┌──────────────────────────────────────────────────┐
                    // │  SECTION 7 · SOCIAL BUTTONS                      │
                    // │                                                  │
                    // │  Row([                                           │
                    // │    Expanded → _SocialButton("GOOGLE"),           │
                    // │    SizedBox(w: 12),  ← horizontal gap            │
                    // │    Expanded → _SocialButton("APPLE"),            │
                    // │  ])                                              │
                    // │                                                  │
                    // │  Each Expanded gets exactly ½ the available row  │
                    // │  width (minus gap) → perfectly equal buttons.   │
                    // │                                                  │
                    // │  Inside _SocialButton:                           │
                    // │    Row(center) → [icon, SizedBox(w:8), Text]    │
                    // └──────────────────────────────────────────────────┘
                    Row(
                      children: [

                        Expanded(
                          child: _SocialButton(
                            label: 'GOOGLE',
                            icon: const _GoogleIcon(),
                            onPressed: () {
                              // TODO: Google sign-in
                            },
                          ),
                        ),

                        const SizedBox(width: 12), // horizontal gap (Row)

                        Expanded(
                          child: _SocialButton(
                            label: 'APPLE',
                            icon: const Icon(
                              Icons.apple,
                              color: Colors.white,
                              size: 18,
                            ),
                            onPressed: () {
                              // TODO: Apple sign-in
                            },
                          ),
                        ),

                      ],
                    ),
                    // END SECTION 7 ─────────────────────────────────────

                    const SizedBox(height: 32),

                    // ┌──────────────────────────────────────────────────┐
                    // │  SECTION 8 · SIGN UP FOOTER                      │
                    // │                                                  │
                    // │  Row(mainAxisAlignment: center)                  │
                    // │  ├── Text  "Don't have an account? "             │
                    // │  └── GestureDetector.onTap → _goToSignUp()      │
                    // │      └── Text  "Create Account"                  │
                    // │                                                  │
                    // │  mainAxisAlignment.center → both items are       │
                    // │  centred together inside the row.                │
                    // │  GestureDetector triggers a nested route push.  │
                    // └──────────────────────────────────────────────────┘
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        const Text(
                          "Don't have an account? ",
                          style: TextStyle(
                            color: Color(0xFF888888),
                            fontSize: 13,
                          ),
                        ),

                        // Nested route → SignUpScreen
                        GestureDetector(
                          onTap: _goToSignUp,
                          child: const Text(
                            'Create Account',
                            style: TextStyle(
                              color: Color(0xFFC8A84B),
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),

                      ],
                    ),
                    // END SECTION 8 ─────────────────────────────────────

                    const SizedBox(height: 24),

                  ],
                ),
                // END ROOT COLUMN ───────────────────────────────────────
              ),
            ),
            // END Expanded ──────────────────────────────────────────────

          ],
        ),
        // END OUTER ROW ─────────────────────────────────────────────────
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  //  HELPER · _buildTextField
  //
  //  Container (dark bg + rounded border)
  //  └── TextField
  //      └── InputDecoration  (Flutter renders this internally as a Row):
  //          ├── prefixIcon  ← left
  //          ├── hint / typed text  ← Expanded centre
  //          └── suffixIcon  ← right (optional, used for password eye)
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Color(0xFF555555), fontSize: 14),
          prefixIcon: Icon(prefixIcon, color: const Color(0xFF666666), size: 20),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }
}

// =============================================================================
//  _YellowButton
//
//  SizedBox(w:∞, h:50)       ← parent constraint forces full width + fixed height
//  └── ElevatedButton
//      └── Row(mainAxisSize: min)   ← shrinks to fit children
//          ├── Text "LOG IN"
//          ├── SizedBox(w:8)        ← horizontal gap (Row child)
//          └── Icon(arrow_forward)
// =============================================================================
class _YellowButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;

  const _YellowButton({this.onPressed, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFC8A84B),
          foregroundColor: Colors.white,
          disabledBackgroundColor: const Color(0xFFC8A84B).withOpacity(0.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            // Row: label ←8px→ arrow  (mainAxisSize.min = no extra space)
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'LOG IN',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward, size: 18, color: Colors.white),
                ],
              ),
      ),
    );
  }
}

// =============================================================================
//  _SocialButton
//
//  SizedBox(h:46)
//  └── OutlinedButton
//      └── Row(mainAxisAlignment: center)
//          ├── icon widget
//          ├── SizedBox(w:8)   ← horizontal gap (Row child)
//          └── Text label
// =============================================================================
class _SocialButton extends StatelessWidget {
  final String label;
  final Widget icon;
  final VoidCallback? onPressed;

  const _SocialButton({
    required this.label,
    required this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFF2A2A2A)),
          backgroundColor: const Color(0xFF1A1A1A),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 12),
        ),
        // Row: icon ←8px→ label, centred inside the full button width
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
//  _GoogleIcon  (SizedBox → CustomPaint → _GooglePainter)
// =============================================================================
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
    final r  = size.width / 2;

    // 1. White background disc
    canvas.drawCircle(Offset(cx, cy), r, Paint()..color = Colors.white);

    // 2. Four coloured arc segments
    const segments = [
      (0.0,  1.57, Color(0xFF4285F4)), // blue
      (1.57, 3.14, Color(0xFF34A853)), // green
      (3.14, 4.71, Color(0xFFFBBC05)), // yellow
      (4.71, 6.28, Color(0xFFEA4335)), // red
    ];
    for (final seg in segments) {
      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: r * 0.7),
        seg.$1, seg.$2 - seg.$1, false,
        Paint()
          ..color = seg.$3
          ..style = PaintingStyle.stroke
          ..strokeWidth = size.width * 0.2,
      );
    }

    // 3. White inner disc — creates the ring hole
    canvas.drawCircle(Offset(cx, cy), r * 0.45, Paint()..color = Colors.white);

    // 4. Blue crossbar (right arm of the G)
    canvas.drawLine(
      Offset(cx, cy), Offset(cx + r * 0.65, cy),
      Paint()
        ..color = const Color(0xFF4285F4)
        ..strokeWidth = size.height * 0.18
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}