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
  bool _isDarkMode = true;
  
  // Expanded states for sections
  bool _accountInfoExpanded = false;
  bool _orderHistoryExpanded = false;
  bool _notificationsExpanded = false;
  bool _settingsExpanded = false;

  // User data
  String _fullName = 'Alex Johnson';
  String _email = 'alex.johnson@email.com';
  String _phone = '+1 (234) 567 890';
  String _location = 'New York, USA';

  // Controllers for editing
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = _isDarkMode ? const Color(0xFF0D0D0D) : const Color(0xFFF5F5F5);
    final cardColor = _isDarkMode ? const Color(0xFF1A1A1A) : Colors.white;
    final textPrimary = _isDarkMode ? Colors.white : Colors.black87;
    final textSecondary = _isDarkMode ? Colors.white54 : Colors.black54;
    final dividerColor = _isDarkMode ? const Color(0xFF2A2A2A) : const Color(0xFFE0E0E0);
    final accentColor = const Color(0xFFC4963D);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          color: textPrimary,
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Profile',
          style: TextStyle(
            color: textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, size: 24),
            color: textPrimary,
            onPressed: () => _showMoreOptions(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            // Profile Header
            Center(
              child: Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: cardColor,
                        child: CircleAvatar(
                          radius: 48,
                          backgroundImage: const AssetImage('assets/images/avatar.png'),
                          onBackgroundImageError: (_, __) {},
                        ),
                      ),
                      Positioned(
                        bottom: -5,
                        right: -5,
                        child: GestureDetector(
                          onTap: () => _changeAvatar(),
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: accentColor,
                              shape: BoxShape.circle,
                              border: Border.all(color: bgColor, width: 3),
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              size: 18,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _fullName,
                    style: TextStyle(
                      color: textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _email,
                    style: TextStyle(
                      color: textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Account Info Section
            _buildExpandableSection(
              title: 'Account Info',
              isExpanded: _accountInfoExpanded,
              onToggle: () => setState(() => _accountInfoExpanded = !_accountInfoExpanded),
              icon: Icons.person_outline,
              children: [
                _buildEditableItem(
                  icon: Icons.email_outlined,
                  label: 'Email',
                  value: _email,
                  onEdit: () => _editField('Email', _email, (val) => setState(() => _email = val)),
                  onDelete: () => _deleteField('Email', () => setState(() => _email = '')),
                  accentColor: accentColor,
                  cardColor: cardColor,
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                  dividerColor: dividerColor,
                ),
                _buildEditableItem(
                  icon: Icons.phone_outlined,
                  label: 'Phone',
                  value: _phone,
                  onEdit: () => _editField('Phone', _phone, (val) => setState(() => _phone = val)),
                  onDelete: () => _deleteField('Phone', () => setState(() => _phone = '')),
                  accentColor: accentColor,
                  cardColor: cardColor,
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                  dividerColor: dividerColor,
                ),
                _buildEditableItem(
                  icon: Icons.location_on_outlined,
                  label: 'Location',
                  value: _location,
                  onEdit: () => _editField('Location', _location, (val) => setState(() => _location = val)),
                  onDelete: () => _deleteField('Location', () => setState(() => _location = '')),
                  accentColor: accentColor,
                  cardColor: cardColor,
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                  dividerColor: dividerColor,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Order History Section
            _buildExpandableSection(
              title: 'Order History',
              isExpanded: _orderHistoryExpanded,
              onToggle: () {
                setState(() => _orderHistoryExpanded = !_orderHistoryExpanded);
                if (!_orderHistoryExpanded) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const OrderScreen()),
                  );
                }
              },
              icon: Icons.shopping_bag_outlined,
              children: [
                _buildOrderItem(
                  orderId: '#ORD-2024-001',
                  date: 'May 15, 2024',
                  amount: '\$125.00',
                  status: 'Delivered',
                  accentColor: accentColor,
                  cardColor: cardColor,
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                ),
                _buildOrderItem(
                  orderId: '#ORD-2024-002',
                  date: 'May 20, 2024',
                  amount: '\$89.99',
                  status: 'Processing',
                  accentColor: accentColor,
                  cardColor: cardColor,
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Notifications Section
            _buildExpandableSection(
              title: 'Notifications',
              isExpanded: _notificationsExpanded,
              onToggle: () {
                setState(() => _notificationsExpanded = !_notificationsExpanded);
              },
              icon: Icons.notifications_outlined,
              children: [
                _buildNotificationItem(
                  title: 'Order Updates',
                  subtitle: 'Get notified about your orders',
                  isEnabled: true,
                  onToggle: (val) {},
                  accentColor: accentColor,
                  cardColor: cardColor,
                  textPrimary: textPrimary,
                ),
                _buildNotificationItem(
                  title: 'Promotions',
                  subtitle: 'Receive promotional offers',
                  isEnabled: false,
                  onToggle: (val) {},
                  accentColor: accentColor,
                  cardColor: cardColor,
                  textPrimary: textPrimary,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  child: TextButton.icon(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const NotificationScreen()),
                    ),
                    icon: Icon(Icons.settings, size: 18, color: accentColor),
                    label: Text(
                      'Notification Settings',
                      style: TextStyle(color: accentColor, fontWeight: FontWeight.w500),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Settings Section
            _buildExpandableSection(
              title: 'Settings',
              isExpanded: _settingsExpanded,
              onToggle: () => setState(() => _settingsExpanded = !_settingsExpanded),
              icon: Icons.settings_outlined,
              children: [
                _buildSettingsItem(
                  icon: Icons.language,
                  title: 'Language',
                  value: 'English',
                  onTap: () => _showLanguageSelector(),
                  accentColor: accentColor,
                  cardColor: cardColor,
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                ),
                _buildSettingsItem(
                  icon: Icons.lock_outline,
                  title: 'Privacy',
                  value: '',
                  onTap: () => _showPrivacySettings(),
                  accentColor: accentColor,
                  cardColor: cardColor,
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                ),
                _buildSettingsItem(
                  icon: Icons.security,
                  title: 'Security',
                  value: '',
                  onTap: () => _showSecuritySettings(),
                  accentColor: accentColor,
                  cardColor: cardColor,
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Dark Mode Toggle
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      _isDarkMode ? Icons.dark_mode : Icons.light_mode,
                      color: accentColor,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      'Dark Mode',
                      style: TextStyle(
                        color: textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Switch(
                    value: _isDarkMode,
                    onChanged: (val) => setState(() => _isDarkMode = val),
                    activeColor: accentColor,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Logout Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showLogoutDialog(),
                icon: const Icon(Icons.logout, size: 20),
                label: const Text(
                  'Log Out',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.withOpacity(0.1),
                  foregroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Bottom Navigation Bar
            _buildBottomNavigationBar(cardColor, accentColor),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableSection({
    required String title,
    required bool isExpanded,
    required VoidCallback onToggle,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: _isDarkMode ? const Color(0xFF1A1A1A) : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          ListTile(
            leading: Icon(icon, color: const Color(0xFFC4963D), size: 22),
            title: Text(
              title,
              style: TextStyle(
                color: _isDarkMode ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            trailing: AnimatedRotation(
              turns: isExpanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 200),
              child: const Icon(
                Icons.keyboard_arrow_down,
                color: Colors.white54,
                size: 24,
              ),
            ),
            onTap: onToggle,
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Column(children: children),
            crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableItem({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
    required Color accentColor,
    required Color cardColor,
    required Color textPrimary,
    required Color textSecondary,
    required Color dividerColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: dividerColor, width: 0.5)),
      ),
      child: Row(
        children: [
          Icon(icon, color: textSecondary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: textSecondary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value.isEmpty ? 'Not set' : value,
                  style: TextStyle(
                    color: textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, size: 18),
                color: accentColor,
                onPressed: onEdit,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 20),
                color: Colors.red,
                onPressed: onDelete,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItem({
    required String orderId,
    required String date,
    required String amount,
    required String status,
    required Color accentColor,
    required Color cardColor,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  orderId,
                  style: TextStyle(
                    color: textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: TextStyle(
                    color: textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: TextStyle(
                  color: accentColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: status == 'Delivered' 
                      ? Colors.green.withOpacity(0.1)
                      : Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: status == 'Delivered' ? Colors.green : Colors.orange,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem({
    required String title,
    required String subtitle,
    required bool isEnabled,
    required Function(bool) onToggle,
    required Color accentColor,
    required Color cardColor,
    required Color textPrimary,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: textPrimary,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: isEnabled,
            onChanged: onToggle,
            activeColor: accentColor,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
    required Color accentColor,
    required Color cardColor,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    return ListTile(
      leading: Icon(icon, color: accentColor, size: 20),
      title: Text(
        title,
        style: TextStyle(
          color: textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: value.isNotEmpty ? Text(
        value,
        style: TextStyle(
          color: textSecondary,
          fontSize: 12,
        ),
      ) : null,
      trailing: const Icon(
        Icons.chevron_right,
        color: Colors.white54,
        size: 20,
      ),
      onTap: onTap,
    );
  }

  Widget _buildBottomNavigationBar(Color cardColor, Color accentColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home_outlined, false, accentColor),
          _buildNavItem(Icons.chat_bubble_outline, false, accentColor),
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: Color(0xFFC4963D),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.add, color: Colors.black, size: 28),
          ),
          _buildNavItem(Icons.notifications_outlined, false, accentColor),
          _buildNavItem(Icons.person_outline, true, accentColor),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, bool isActive, Color accentColor) {
    return Icon(
      icon,
      color: isActive ? accentColor : Colors.white38,
      size: 24,
    );
  }

  // Dialog and Action Methods
  void _editField(String field, String currentValue, Function(String) onSave) {
    final controller = TextEditingController(text: currentValue);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _isDarkMode ? const Color(0xFF1A1A1A) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Edit $field',
          style: TextStyle(
            color: _isDarkMode ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
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
              borderSide: BorderSide(color: Color(0xFFC4963D), width: 2),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: TextStyle(color: _isDarkMode ? Colors.white54 : Colors.black54),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                onSave(controller.text.trim());
              }
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC4963D),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Save', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  void _deleteField(String field, VoidCallback onDelete) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _isDarkMode ? const Color(0xFF1A1A1A) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.warning, color: Colors.red, size: 24),
            const SizedBox(width: 8),
            Text(
              'Delete $field',
              style: TextStyle(
                color: _isDarkMode ? Colors.white : Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to delete this $field?',
          style: TextStyle(color: _isDarkMode ? Colors.white70 : Colors.black54),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: TextStyle(color: _isDarkMode ? Colors.white54 : Colors.black54),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              onDelete();
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$field deleted successfully'),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _changeAvatar() {
    showModalBottomSheet(
      context: context,
      backgroundColor: _isDarkMode ? const Color(0xFF1A1A1A) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white38,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Color(0xFFC4963D)),
                title: Text(
                  'Take Photo',
                  style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black87),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  // Implement camera functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Camera opened'), behavior: SnackBarBehavior.floating),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Color(0xFFC4963D)),
                title: Text(
                  'Choose from Gallery',
                  style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black87),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  // Implement gallery functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Gallery opened'), behavior: SnackBarBehavior.floating),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Remove Photo', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Photo removed'), behavior: SnackBarBehavior.floating),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLanguageSelector() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _isDarkMode ? const Color(0xFF1A1A1A) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Select Language',
          style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black87),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['English', 'Spanish', 'French', 'German', 'Ukrainian']
              .map((lang) => RadioListTile<String>(
                    title: Text(lang, style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black87)),
                    value: lang,
                    groupValue: 'English',
                    onChanged: (val) {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Language changed to $lang'), behavior: SnackBarBehavior.floating),
                      );
                    },
                    activeColor: const Color(0xFFC4963D),
                  ))
              .toList(),
        ),
      ),
    );
  }

  void _showPrivacySettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SettingsScreen()),
    );
  }

  void _showSecuritySettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Security settings opened'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: _isDarkMode ? const Color(0xFF1A1A1A) : Colors.white,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.share, color: Color(0xFFC4963D)),
              title: Text('Share Profile', style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black87)),
              onTap: () => Navigator.pop(ctx),
            ),
            ListTile(
              leading: const Icon(Icons.help_outline, color: Color(0xFFC4963D)),
              title: Text('Help & Support', style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black87)),
              onTap: () => Navigator.pop(ctx),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline, color: Color(0xFFC4963D)),
              title: Text('About', style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black87)),
              onTap: () => Navigator.pop(ctx),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _isDarkMode ? const Color(0xFF1A1A1A) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.logout, color: Colors.red, size: 24),
            const SizedBox(width: 8),
            Text(
              'Log Out',
              style: TextStyle(
                color: _isDarkMode ? Colors.white : Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to log out?',
          style: TextStyle(color: _isDarkMode ? Colors.white70 : Colors.black54),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: TextStyle(color: _isDarkMode ? Colors.white54 : Colors.black54),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              // Navigate to login screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Logged out successfully'),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Log Out', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}