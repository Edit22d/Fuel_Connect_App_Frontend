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
  bool _accountInfoExpanded = true; // open by default as seen in screenshot
  
  // Theme state
  bool _isDarkMode = true;
  String _selectedTheme = 'Dark Mode';

  // Account info states for editing/deleting
  String _fullName = 'alex johnson';
  String _phoneNumber = '+256 700 000';
  String _email = 'alex.johnson@contact.com';
  String _location = 'Kampala, UG';

  @override
  Widget build(BuildContext context) {
    // Dynamic theme colors
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

            // ── Avatar + name + email ──
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: cardColor,
                        backgroundImage:
                            const AssetImage('assets/images/avatar.png'),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 22,
                          height: 22,
                          decoration: const BoxDecoration(
                            color: Color(0xFFC8A84B),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.edit,
                              size: 13, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Alex Johnson',
                    style: TextStyle(
                      color: textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'alex.johnson@email.com',
                    style: TextStyle(
                      color: const Color(0xFFC8A84B),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // ── ACCOUNT SETTINGS ──
            _sectionLabel('ACCOUNT SETTINGS', textSecondary),
            const SizedBox(height: 10),

            // ── Account Info expandable/dropdown tile ──
            GestureDetector(
              onTap: () =>
                  setState(() => _accountInfoExpanded = !_accountInfoExpanded),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 14),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header row
                    Row(
                      children: [
                        const Icon(Icons.person_outline,
                            color: Color(0xFFC8A84B), size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Account Info',
                            style: TextStyle(
                              color: textPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        AnimatedRotation(
                          turns: _accountInfoExpanded ? 0.25 : 0,
                          duration: const Duration(milliseconds: 200),
                          child: Icon(Icons.chevron_right,
                              color: textSecondary, size: 20),
                        ),
                      ],
                    ),

                    // Dropdown expanded content
                    AnimatedCrossFade(
                      firstChild: const SizedBox.shrink(),
                      secondChild: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 14),
                          Divider(color: dividerColor, height: 1),
                          const SizedBox(height: 14),
                          _editableInfoRow(
                            label: 'Full Name',
                            value: _fullName,
                            textSecondary: textSecondary,
                            textTertiary: textTertiary,
                            onEdit: () => _showEditDialog(
                              'Full Name',
                              _fullName,
                              (newValue) => setState(() => _fullName = newValue),
                            ),
                            onDelete: () => _showDeleteDialog(
                              'Full Name',
                              () => setState(() => _fullName = ''),
                            ),
                          ),
                          const SizedBox(height: 12),
                          _editableInfoRow(
                            label: 'Phone Number',
                            value: _phoneNumber,
                            textSecondary: textSecondary,
                            textTertiary: textTertiary,
                            onEdit: () => _showEditDialog(
                              'Phone Number',
                              _phoneNumber,
                              (newValue) => setState(() => _phoneNumber = newValue),
                            ),
                            onDelete: () => _showDeleteDialog(
                              'Phone Number',
                              () => setState(() => _phoneNumber = ''),
                            ),
                          ),
                          const SizedBox(height: 12),
                          _editableInfoRow(
                            label: 'Email',
                            value: _email,
                            textSecondary: textSecondary,
                            textTertiary: textTertiary,
                            onEdit: () => _showEditDialog(
                              'Email',
                              _email,
                              (newValue) => setState(() => _email = newValue),
                            ),
                            onDelete: () => _showDeleteDialog(
                              'Email',
                              () => setState(() => _email = ''),
                            ),
                          ),
                          const SizedBox(height: 12),
                          _editableInfoRow(
                            label: 'Location',
                            value: _location,
                            textSecondary: textSecondary,
                            textTertiary: textTertiary,
                            onEdit: () => _showEditDialog(
                              'Location',
                              _location,
                              (newValue) => setState(() => _location = newValue),
                            ),
                            onDelete: () => _showDeleteDialog(
                              'Location',
                              () => setState(() => _location = ''),
                            ),
                          ),
                          const SizedBox(height: 4),
                        ],
                      ),
                      crossFadeState: _accountInfoExpanded
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      duration: const Duration(milliseconds: 250),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const OrderScreen()),
              ),
              child: _profileTile(
                icon: Icons.receipt_long_outlined,
                title: 'Order History',
                textPrimary: textPrimary,
                textSecondary: textSecondary,
                cardColor: cardColor,
              ),
            ),

            const SizedBox(height: 28),

            // ── PREFERENCES ──
            _sectionLabel('PREFERENCES', textSecondary),
            const SizedBox(height: 10),

            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const NotificationScreen()),
              ),
              child: _profileTile(
                icon: Icons.notifications_none_outlined,
                title: 'Notifications',
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

            const SizedBox(height: 28),

            // ── THEME PREFERENCES ──
            _sectionLabel('THEME PREFERENCES', textSecondary),
            const SizedBox(height: 10),

            _themeDropdownTile(
              textPrimary: textPrimary,
              textSecondary: textSecondary,
              cardColor: cardColor,
            ),

            const SizedBox(height: 10),

            // ── Logout ──
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFC8A84B)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 13),
                ),
                icon: const Icon(Icons.logout,
                    color: Color(0xFFC8A84B), size: 18),
                label: const Text(
                  'Logout',
                  style: TextStyle(
                    color: Color(0xFFC8A84B),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
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
              borderSide: BorderSide(color: const Color(0xFFC8A84B).withOpacity(0.5)),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFC8A84B)),
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
            child: const Text('Save', style: TextStyle(color: Color(0xFFC8A84B), fontWeight: FontWeight.bold)),
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

  // ── Widget Builders ──

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

  Widget _editableInfoRow({
    required String label,
    required String value,
    required Color textSecondary,
    required Color textTertiary,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.4,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value.isEmpty ? '—' : value,
                style: TextStyle(
                  color: value.isEmpty ? textSecondary : textTertiary,
                  fontSize: 13,
                  fontStyle: value.isEmpty ? FontStyle.italic : FontStyle.normal,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: onEdit,
          child: Icon(
            Icons.edit_outlined,
            color: const Color(0xFFC8A84B).withOpacity(0.8),
            size: 18,
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: onDelete,
          child: Icon(
            Icons.delete_outline,
            color: Colors.redAccent.withOpacity(0.8),
            size: 18,
          ),
        ),
      ],
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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFC8A84B), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Icon(Icons.chevron_right, color: textSecondary, size: 20),
        ],
      ),
    );
  }

  Widget _themeDropdownTile({
    required Color textPrimary,
    required Color textSecondary,
    required Color cardColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            _isDarkMode ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
            color: const Color(0xFFC8A84B),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Theme',
              style: TextStyle(
                color: textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: _isDarkMode ? const Color(0xFF2A2A2A) : const Color(0xFFEEEEEE),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButton<String>(
              value: _selectedTheme,
              underline: const SizedBox(),
              isDense: true,
              icon: const Icon(Icons.arrow_drop_down, color: Color(0xFFC8A84B), size: 20),
              dropdownColor: _isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
              borderRadius: BorderRadius.circular(8),
              style: TextStyle(
                color: textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              items: const [
                DropdownMenuItem(value: 'Dark Mode', child: Text('Dark Mode')),
                DropdownMenuItem(value: 'Light Mode', child: Text('Light Mode')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedTheme = value;
                    _isDarkMode = value == 'Dark Mode';
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}