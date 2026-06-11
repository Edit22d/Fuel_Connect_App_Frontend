import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ── Theme State Notifier ──────────────────────────────────
class ThemeNotifier extends ValueNotifier<ThemeMode> {
  static const String _themePrefKey = 'theme_pref';

  ThemeNotifier() : super(ThemeMode.dark) {
    _loadTheme();
  }

  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool(_themePrefKey) ?? true;
    value = isDark ? ThemeMode.dark : ThemeMode.light;
  }

  void toggleTheme() async {
    value = value == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_themePrefKey, value == ThemeMode.dark);
  }
}

// Global singleton notifier for the app
final themeNotifier = ThemeNotifier();

// ── AppTheme (Color System & ThemeData) ───────────────────
class AppTheme {
  // Shared Gold Colors
  static const Color gold = Color(0xFFC8A84B);
  static const Color darkGold = Color(0xFF8C6E3F);
  
  // Dark Mode Colors
  static const Color darkBg = Color(0xFF0D0D0D);
  static const Color darkSurface = Color(0xFF141414);
  static const Color darkBorder = Color(0xFF2A2A2A);
  static const Color darkTextPrimary = Colors.white;
  static const Color darkTextSecondary = Color(0xFF888888);
  
  // Light Mode Colors
  static const Color lightBg = Color(0xFFF7F7F9);
  static const Color lightSurface = Colors.white;
  static const Color lightBorder = Color(0xFFE5E5E5);
  static const Color lightTextPrimary = Color(0xFF111111);
  static const Color lightTextSecondary = Color(0xFF666666);

  static LinearGradient buttonGradient = const LinearGradient(
    colors: [gold, darkGold],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );



  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: lightBg,
      primaryColor: gold,
      colorScheme: const ColorScheme.light(
        primary: gold,
        surface: lightSurface,
        onSurface: lightTextPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: lightBg,
        elevation: 0,
        iconTheme: IconThemeData(color: lightTextPrimary),
        titleTextStyle: TextStyle(color: lightTextPrimary, fontSize: 18, fontWeight: FontWeight.bold),
      ),
      iconTheme: const IconThemeData(color: gold),
      textTheme: GoogleFonts.interTextTheme(),
      dividerColor: lightBorder,
      fontFamily: null,
    );
  }



  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBg,
      primaryColor: gold,
      iconTheme: const IconThemeData(color: darkGold),
      colorScheme: const ColorScheme.dark(
        primary: gold,
        surface: darkSurface,
        onSurface: darkTextPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: darkBg,
        elevation: 0,
        iconTheme: IconThemeData(color: darkTextPrimary),
        titleTextStyle: TextStyle(color: darkTextPrimary, fontSize: 18, fontWeight: FontWeight.bold),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: darkTextPrimary),
        bodyMedium: TextStyle(color: darkTextSecondary),
      ),
      dividerColor: darkBorder,
      fontFamily: 'sans-serif',
    );
  }
}

// ── Convenience aliases (Legacy support) ──────────────────
Color kGold = AppTheme.gold;
Color kGoldLight = AppTheme.gold;
Color kDarkBg = AppTheme.darkBg;
Color kWhite = Colors.white;
Color kBlack = Colors.black;

// ── Theme Toggle Button ───────────────────────────────────
class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, mode, child) {
        final isDark = mode == ThemeMode.dark;
        return IconButton(
          icon: Icon(
            isDark ? Icons.light_mode : Icons.dark_mode,
            color: isDark ? AppTheme.gold : AppTheme.darkGold,
          ),
          onPressed: themeNotifier.toggleTheme,
          tooltip: 'Toggle Theme',
        );
      },
    );
  }
}

// ── FUEL CONNECT Logo ─────────────────────────────────────
class FuelConnectLogo extends StatelessWidget {
  final double fontSize;
  const FuelConnectLogo({super.key, this.fontSize = 32});

  @override
  Widget build(BuildContext context) {
    final double imgWidth = fontSize * 5.0;
    final double imgHeight = fontSize * 3.75;
    return Image.asset(
      'assets/images/logo.png',
      width: imgWidth,
      height: imgHeight,
      fit: BoxFit.contain,
    );
  }
}

// ── Gold AppBar ────────────────────────────────────────────
class FuelAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const FuelAppBar({super.key, required this.title});


  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(gradient: AppTheme.buttonGradient),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Theme.of(context).iconTheme.color ?? Colors.black),
        onPressed: () => Navigator.maybePop(context),
      ),
      title: Text(
        title,
        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.home, color: Colors.black),
          onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
        ),
      ],
    );
  }
}

// ── Gold Underline Text Field (Legacy) ────────────────────
class GoldUnderlineField extends StatefulWidget {
  final String label;
  final String hint;
  final bool isPassword;
  final TextEditingController? controller;
  final TextInputType keyboardType;

  GoldUnderlineField({
    super.key,
    required this.label,
    String? hint,
    this.isPassword = false,
    this.controller,
    this.keyboardType = TextInputType.text,
  }) : hint = hint ?? label;

  @override
  State<GoldUnderlineField> createState() => _GoldUnderlineFieldState();
}

class _GoldUnderlineFieldState extends State<GoldUnderlineField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final hintColor = isDark ? Colors.white38 : Colors.black38;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: const TextStyle(color: AppTheme.gold, fontSize: 11)),
        TextField(
          controller: widget.controller,
          obscureText: widget.isPassword ? _obscure : false,
          keyboardType: widget.keyboardType,
          style: TextStyle(color: textColor, fontSize: 14),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: TextStyle(color: hintColor, fontSize: 13),
            enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppTheme.gold)),
            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppTheme.darkGold, width: 2)),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 6),
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility, color: AppTheme.gold, size: 18),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}

// ── Full-width Gradient Gold Button ───────────────────────
class GoldButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const GoldButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: AppTheme.buttonGradient,
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      ),
    );
  }
}

// ── OTP Top Bar ───────────────────────────────────────────
class OtpTopBar extends StatelessWidget {
  const OtpTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    final iconColor = Theme.of(context).iconTheme.color;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: iconColor),
            onPressed: () => Navigator.maybePop(context),
          ),
          const Spacer(),
          ThemeToggleButton(),
          IconButton(
            icon: Icon(Icons.home, color: iconColor),
            onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
          ),
        ],
      ),
    );
  }
}

// ── OTP 4-box Input Row ───────────────────────────────────
class OtpInputRow extends StatefulWidget {
  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;
  const OtpInputRow({super.key, required this.controllers, required this.focusNodes});

  @override
  State<OtpInputRow> createState() => _OtpInputRowState();
}

class _OtpInputRowState extends State<OtpInputRow> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (i) {
        return Container(
          width: 54,
          height: 54,
          margin: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            color: AppTheme.gold.withOpacity(0.15),
            border: Border.all(color: AppTheme.gold, width: 1.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: widget.controllers[i],
            focusNode: widget.focusNodes[i],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            style: TextStyle(color: textColor, fontSize: 24, fontWeight: FontWeight.bold),
            decoration: const InputDecoration(counterText: '', border: InputBorder.none),
            onChanged: (val) {
              if (val.isNotEmpty && i < 3) {
                widget.focusNodes[i + 1].requestFocus();
              } else if (val.isEmpty && i > 0) {
                widget.focusNodes[i - 1].requestFocus();
              }
              setState(() {});
            },
          ),
        );
      }),
    );
  }
}

// ── OTP Info Dialog ───────────────────────────────────────
class OtpInfoDialog extends StatelessWidget {
  final VoidCallback onOk;
  const OtpInfoDialog({super.key, required this.onOk});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 40),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: AppTheme.buttonGradient,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'A 4-digit OTP will be sent\nto your Registered Mobile\nNumber/Email ID',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w600, height: 1.5),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 100,
              height: 40,
              child: ElevatedButton(
                onPressed: onOk,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: const Text(
                  'OK',
                  style: TextStyle(color: AppTheme.gold, fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}







