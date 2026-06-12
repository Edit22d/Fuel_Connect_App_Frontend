import 'package:flutter/material.dart';
import 'package:fuel_app/auth/theme.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final icons = [
      Icons.home_outlined,
      Icons.location_on_outlined,
      Icons.format_list_bulleted,
      Icons.favorite_border,
      Icons.person_outline,
    ];

    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      padding: EdgeInsets.only(bottom: bottomPadding),
      height: 70 + bottomPadding,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.gold.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(icons.length, (i) {
          final isSelected = currentIndex == i;
          return _NavItem(
            icon: icons[i],
            isSelected: isSelected,
            onTap: () => onTap(i),
          );
        }),
      ),
    );
  }
}

class _NavItem extends StatefulWidget {
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.all(12),
          transform: Matrix4.identity()..scale(_isHovering ? 1.15 : 1.0),
          decoration: BoxDecoration(
            color: widget.isSelected 
                ? Colors.white 
                : (_isHovering ? Colors.white.withOpacity(0.2) : Colors.transparent),
            shape: BoxShape.circle,
            boxShadow: widget.isSelected 
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    )
                  ]
                : null,
          ),
          child: Icon(
            widget.icon,
            color: widget.isSelected 
                ? AppTheme.gold // Gold icon when selected
                : (isDark ? Colors.white70 : Colors.black54), // Icons for unselected
            size: 26,
          ),
        ),
      ),
    );
  }
}

