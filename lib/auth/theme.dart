import 'package:flutter/material.dart';

// ── AppTheme (your color system) ──────────────────────────
class AppTheme {
  static const Color black    = Color(0xFF0F0F0F);
  static const Color gold     = Color(0xFFD4AF37);
  static const Color darkGold = Color(0xFF8C6E3F);
  static const Color darkBg   = Color(0xFF1A1200);
  static const Color white    = Colors.white;

  static LinearGradient buttonGradient = LinearGradient(
    colors: [Color(0xFFD4AF37), Color(0xFF8C6E3F)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}

// ── Convenience aliases (used throughout all screens) ─────
Color kGold      = AppTheme.gold;
Color kGoldLight = AppTheme.gold;
Color kDarkBg    = AppTheme.darkBg;
Color kWhite     = AppTheme.white;
Color kBlack     = AppTheme.black;

// ── FUEL CONNECT Logo (image asset) ───────────────────────
class FuelConnectLogo extends StatelessWidget {
  final double fontSize;
  FuelConnectLogo({this.fontSize = 32});

  @override
  Widget build(BuildContext context) {
    final double imgWidth  = fontSize * 5.0;
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
  FuelAppBar({required this.title});

  @override
  Size get preferredSize => Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.buttonGradient,
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: AppTheme.black),
        onPressed: () => Navigator.maybePop(context),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: AppTheme.black,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.home, color: AppTheme.black),
          onPressed: () {},
        ),
      ],
    );
  }
}

// ── Gold Underline Text Field ─────────────────────────────
class GoldUnderlineField extends StatefulWidget {
  final String label;
  final String hint;
  final bool isPassword;
  final TextEditingController? controller;
  final TextInputType keyboardType;

  GoldUnderlineField({
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(color: AppTheme.gold, fontSize: 11),
        ),
        TextField(
          controller: widget.controller,
          obscureText: widget.isPassword ? _obscure : false,
          keyboardType: widget.keyboardType,
          style: TextStyle(color: AppTheme.white, fontSize: 14),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: TextStyle(color: Colors.white38, fontSize: 13),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppTheme.gold),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppTheme.darkGold, width: 2),
            ),
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 6),
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscure ? Icons.visibility_off : Icons.visibility,
                      color: AppTheme.gold,
                      size: 18,
                    ),
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
  GoldButton({required this.text, required this.onPressed});

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
            style: TextStyle(
              color: AppTheme.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

// ── OTP Top Bar (back + home) ─────────────────────────────
class OtpTopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: AppTheme.white),
            onPressed: () => Navigator.maybePop(context),
          ),
          Spacer(),
          IconButton(
            icon: Icon(Icons.home, color: AppTheme.white),
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
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
  OtpInputRow({required this.controllers, required this.focusNodes});

  @override
  State<OtpInputRow> createState() => _OtpInputRowState();
}

class _OtpInputRowState extends State<OtpInputRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (i) {
        return Container(
          width: 54,
          height: 54,
          margin: EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            color: AppTheme.gold.withOpacity(0.25),
            border: Border.all(color: AppTheme.gold, width: 1.5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: widget.controllers[i],
            focusNode: widget.focusNodes[i],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            style: TextStyle(
              color: AppTheme.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
              counterText: '',
              border: InputBorder.none,
            ),
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
  OtpInfoDialog({required this.onOk});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 40),
      child: Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: AppTheme.buttonGradient,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'A 4-digit OTP will be sent\nto your Registered Mobile\nNumber/Email ID',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.black,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                height: 1.5,
              ),
            ),
            SizedBox(height: 22),
            SizedBox(
              width: 80,
              height: 36,
              child: ElevatedButton(
                onPressed: onOk,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  'OK',
                  style: TextStyle(
                    color: AppTheme.gold,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
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






