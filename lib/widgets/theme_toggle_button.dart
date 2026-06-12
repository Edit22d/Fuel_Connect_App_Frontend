import 'package:flutter/material.dart';
import 'package:fuel_app/auth/theme.dart';

class CustomThemeToggle extends StatelessWidget {
  final Color iconColor;
  final Color bgColor;

  const CustomThemeToggle({
    super.key,
    this.iconColor = Colors.white,
    this.bgColor = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, mode, _) {
        final isDark = mode == ThemeMode.dark;
        return GestureDetector(
          onTap: () => themeNotifier.toggleTheme(),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isDark ? Icons.dark_mode : Icons.light_mode,
              color: iconColor,
              size: 20,
            ),
          ),
        );
      },
    );
  }
}
