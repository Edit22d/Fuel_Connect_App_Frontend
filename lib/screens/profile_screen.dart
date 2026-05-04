import 'package:flutter/material.dart';
import 'notification_screen.dart';
import 'settings_screen.dart';
import 'order_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _accountInfoExpanded = true; 
  
  bool _isDarkMode = true;
  String _selectedTheme = 'Dark Mode';

  String _fullName = 'Dmytro Shevchenko';
  String _phoneNumber = '+38 067 123 45 16';
  String _email = 'dmytro.shevchenko@email.com';
  String _location = 'Kyiv, Ukraine';

  @override
  Widget build(BuildContext context) {
    final bgColor = _isDarkMode ? const Color(0xFF0D0D0D) : const Color(0xFFF5F5F5);
    final cardColor = _isDarkMode ? const Color(0xFF1A1A1A) : Colors.white;
    final textPrimary = _isDarkMode ? Colors.white : Colors.black87;
    final textSecondary = _isDarkMode ? Colors.white38 : Colors.black38;
    final textTertiary = _isDarkMode ? Colors.white70 : Colors.black54;
    final dividerColor = _isDarkMode ? const Color(0xFF2A2A2A) : const Color(0xFFE0E0E0);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        leading: Icon(Icons.arrow_back, color: textPrimary),
        title: Text(
          'Profile',
          style: TextStyle(
            color: textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            // Profile Header with Photo
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 45,
                        backgroundColor: cardColor,
                        backgroundImage: const AssetImage('assets/images/avatar.png'),
                        child: const CircleAvatar(
                          radius: 45,
                          backgroundImage: AssetImage('assets/images/avatar.png'),
                        ),
                      ),
                      Positioned(
                        bottom: 5,
                        right: 5,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: const BoxDecoration(
                            color: Color(0xFFC4963D),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.edit, size: 14, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Dmytro Shevchenko',
                    style: TextStyle(
                      color: textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '+38 067 123 45 16',
                    style: TextStyle(
                      color: textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Chat Bubble - Sandy
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A4A),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hi, I\'m Sandy!',
                          style: TextStyle(
                            color: textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Let me know more about you',
                          style: TextStyle(
                            color: textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFF3A3A5A),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.chat_bubble_outline,
                      color: Color(0xFFC4963D),
                      size: 35,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Menu Items
            _sectionLabel('MENU', textSecondary),
            const SizedBox(height: 12),

            GestureDetector(
              onTap: () {},
              child: _profileTile(
                icon: Icons.person_outline,
                title: 'My profile',
                textPrimary: textPrimary,
                textSecondary: textSecondary,
                cardColor: cardColor,
              ),
            ),

            const SizedBox(height: 10),

            GestureDetector(
              onTap: () {},
              child: _profileTile(
                icon: Icons.credit_card_outlined,
                title: 'Payments and auto write-offs',
                textPrimary: textPrimary,
                textSecondary: textSecondary,
                cardColor: cardColor,
              ),
            ),

            const SizedBox(height: 10),

            GestureDetector(
              onTap: () {},
              child: _profileTile(
                icon: Icons.phone_outlined,
                title: 'Phone codes',
                textPrimary: textPrimary,
                textSecondary: textSecondary,
                cardColor: cardColor,
              ),
            ),

            const SizedBox(height: 10),

            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              ),
              child: _profileTile(
                icon: Icons.settings_outlined,
                title: 'Settings',
                textPrimary: textPrimary,
                textSecondary: textSecondary,
                cardColor: cardColor,
              ),
            ),

            const SizedBox(height: 10),

            GestureDetector(
              onTap: () {},
              child: _profileTile(
                icon: Icons.error_outline,
                title: 'Report an error',
                textPrimary: textPrimary,
                textSecondary: textSecondary,
                cardColor: cardColor,
              ),
            ),

            const SizedBox(height: 10),

            GestureDetector(
              onTap: () {},
              child: _profileTile(
                icon: Icons.support_outlined,
                title: 'Support',
                textPrimary: textPrimary,
                textSecondary: textSecondary,
                cardColor: cardColor,
              ),
            ),

            const SizedBox(height: 30),

            // Bottom Navigation Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _bottomNavItem(Icons.home_outlined, false),
                  _bottomNavItem(Icons.chat_bubble_outline, false),
                  _bottomNavItem(Icons.add_circle, true, isCenter: true),
                  _bottomNavItem(Icons.notifications_outlined, false),
                  _bottomNavItem(Icons.person_outline, true),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _bottomNavItem(IconData icon, bool isActive, {bool isCenter = false}) {
    if (isCenter) {
      return Container(
        width: 56,
        height: 56,
        decoration: const BoxDecoration(
          color: Color(0xFFC4963D),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.black, size: 28),
      );
    }
    return Icon(
      icon,
      color: isActive ? const Color(0xFFC4963D) : Colors.white38,
      size: 24,
    );
  }

  Widget _sectionLabel(String label, Color color) {
    return Text(
      label,
      style: TextStyle(
        color: color,
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.1,
      ),
    );
  }

  Widget _profileTile({
    required IconData icon,
    required String title,
    required Color textPrimary,
    required Color textSecondary,
    required Color cardColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFC4963D), size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Icon(Icons.chevron_right, color: textSecondary, size: 20),
        ],
      ),
    );
  }

  void _showEditDialog(String field, String currentValue, ValueChanged<String> onSave) {
    final controller = TextEditingController(text: currentValue);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _isDarkMode ? const Color(0xFF1A1A1A) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text('Edit $field', style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black87, fontWeight: FontWeight.bold)),
        content: TextField(
          controller: controller,
          style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black87),
          decoration: InputDecoration(
            hintText: 'Enter new $field',
            hintStyle: TextStyle(color: _isDarkMode ? Colors.white38 : Colors.black38),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: const Color(0xFFC4963D).withOpacity(0.5)),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFC4963D)),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: TextStyle(color: _isDarkMode ? Colors.white38 : Colors.black38)),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                onSave(controller.text.trim());
              }
              Navigator.pop(ctx);
            },
            child: const Text('Save', style: TextStyle(color: Color(0xFFC4963D), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(String field, VoidCallback onDelete) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _isDarkMode ? const Color(0xFF1A1A1A) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text('Delete $field', style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black87, fontWeight: FontWeight.bold)),
        content: Text('Are you sure you want to delete this $field?', style: TextStyle(color: _isDarkMode ? Colors.white70 : Colors.black54)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: TextStyle(color: _isDarkMode ? Colors.white38 : Colors.black38)),
          ),
          TextButton(
            onPressed: () {
              onDelete();
              Navigator.pop(ctx);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}