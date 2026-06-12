import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../auth/theme.dart';
import '../widgets/theme_toggle_button.dart';
import '../services/auth_service.dart';
import '../auth/login_screen.dart';
import 'settings_screen.dart';
import 'order_screen.dart';
import 'terms_screen.dart';
import 'notification_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  
  bool _notificationsEnabled = true;
  bool _biometricEnabled = false;
  bool _twoFactorEnabled = false;
  bool _loginAlertsEnabled = true;

  String _fullName = 'Loading...';
  String _email = 'Loading...';

  final TextEditingController _editNameController = TextEditingController();
  final TextEditingController _editEmailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPrefs();
    _loadUserData();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _biometricEnabled = prefs.getBool('sec_biometric') ?? false;
      _twoFactorEnabled = prefs.getBool('sec_2fa') ?? false;
      _loginAlertsEnabled = prefs.getBool('sec_login_alerts') ?? true;
      _notificationsEnabled = prefs.getBool('notif_orders') ?? true;
    });
  }

  Future<void> _savePref(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  Future<void> _loadUserData() async {
    try {
      final user = await _authService.getCurrentUser();
      if (user != null) {
        if (mounted) {
          setState(() {
            _fullName = user.fullName;
            _email = user.email;
          });
        }
      }
      
      final userResponse = await _authService.getMe();
      if (userResponse['success'] == true && userResponse['data'] != null) {
        final data = userResponse['data'];
        if (mounted) {
          setState(() {
            _fullName = data['full_name'] ?? _fullName;
            _email = data['email'] ?? _email;
          });
        }
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _fullName = 'Muhammad';
          _email = 'example@gmail.com';
        });
      }
    }
  }

  void _showToast(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppTheme.gold,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _handleLogout() async {
    await _authService.logout();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  void _showEditProfileModal() {
    _editNameController.text = _fullName;
    _editEmailController.text = _email;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Edit Profile',
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              
              // Change Avatar
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: AppTheme.gold.withOpacity(0.2),
                      child: const Icon(Icons.person, color: AppTheme.gold, size: 40),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () => _showToast('Upload Image clicked'),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: AppTheme.gold,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Name Field
              TextFormField(
                controller: _editNameController,
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: isDark ? Colors.white24 : Colors.black12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppTheme.gold),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Email Field
              TextFormField(
                controller: _editEmailController,
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: isDark ? Colors.white24 : Colors.black12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppTheme.gold),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Save Button
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _fullName = _editNameController.text;
                    _email = _editEmailController.text;
                  });
                  Navigator.pop(context);
                  _showToast('Profile updated successfully');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.gold,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Save Changes',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              const SizedBox(height: 16),

              // Delete Account
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showDeleteConfirmation();
                },
                child: const Text(
                  'Delete Account',
                  style: TextStyle(color: Colors.redAccent, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        title: Text(
          'Delete Account',
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
        ),
        content: Text(
          'Are you sure you want to permanently delete your account? This action cannot be undone.',
          style: TextStyle(color: isDark ? Colors.white70 : Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _handleLogout();
              _showToast('Account deleted successfully');
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
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
          icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Profile',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: CustomThemeToggle(
              iconColor: Colors.grey,
              bgColor: Colors.transparent,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Profile Card ──────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: AppTheme.gold.withOpacity(0.2),
                    child: const Icon(Icons.person, color: AppTheme.gold, size: 30),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _fullName,
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _email,
                          style: TextStyle(
                            color: isDark ? Colors.white54 : Colors.black54,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit_outlined, color: isDark ? Colors.white54 : Colors.black54),
                    onPressed: _showEditProfileModal,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // ── General Section ───────────────────────────────────────────
            Text('General', style: TextStyle(color: isDark ? Colors.white : Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: Column(
                children: [
                  _buildListTile(
                    icon: Icons.history_outlined,
                    title: 'Order History',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const OrderScreen())),
                    isDark: isDark,
                  ),
                  _buildDivider(isDark),
                  _buildListTile(
                    icon: Icons.settings_outlined,
                    title: 'Settings',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())),
                    isDark: isDark,
                  ),
                  _buildDivider(isDark),
                  _buildListTile(
                    icon: Icons.notifications_active_outlined,
                    title: 'Notification Center',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationScreen())),
                    isDark: isDark,
                  ),
                  _buildDivider(isDark),
                  ListTile(
                    leading: Icon(Icons.notifications_none_outlined, color: isDark ? Colors.white70 : Colors.black87),
                    title: Text(
                      'Push Notifications',
                      style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    trailing: Switch(
                      value: _notificationsEnabled,
                      activeColor: AppTheme.gold,
                      onChanged: (val) {
                        setState(() => _notificationsEnabled = val);
                        _savePref('notif_orders', val);
                        _showToast(val ? 'Notifications Enabled' : 'Notifications Disabled');
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // ── Security Section ───────────────────────────────────────────
            Text('Security', style: TextStyle(color: isDark ? Colors.white : Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.fingerprint, color: isDark ? Colors.white70 : Colors.black87),
                    title: Text(
                      'Biometric Login',
                      style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    trailing: Switch(
                      value: _biometricEnabled,
                      activeColor: AppTheme.gold,
                      onChanged: (val) {
                        setState(() => _biometricEnabled = val);
                        _savePref('sec_biometric', val);
                      },
                    ),
                  ),
                  _buildDivider(isDark),
                  ListTile(
                    leading: Icon(Icons.security, color: isDark ? Colors.white70 : Colors.black87),
                    title: Text(
                      'Two-Factor Authentication',
                      style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    trailing: Switch(
                      value: _twoFactorEnabled,
                      activeColor: AppTheme.gold,
                      onChanged: (val) {
                        setState(() => _twoFactorEnabled = val);
                        _savePref('sec_2fa', val);
                      },
                    ),
                  ),
                  _buildDivider(isDark),
                  ListTile(
                    leading: Icon(Icons.phonelink_ring, color: isDark ? Colors.white70 : Colors.black87),
                    title: Text(
                      'Login Alerts',
                      style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    trailing: Switch(
                      value: _loginAlertsEnabled,
                      activeColor: AppTheme.gold,
                      onChanged: (val) {
                        setState(() => _loginAlertsEnabled = val);
                        _savePref('sec_login_alerts', val);
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // ── Support & Legal Section ───────────────────────────────────────────
            Text('Support & Legal', style: TextStyle(color: isDark ? Colors.white : Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: Column(
                children: [
                  _buildListTile(
                    icon: Icons.rule,
                    title: 'Terms & Conditions',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TermsScreen(section: 'terms'))),
                    isDark: isDark,
                  ),
                  _buildDivider(isDark),
                  _buildListTile(
                    icon: Icons.privacy_tip_outlined,
                    title: 'Privacy Policy',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TermsScreen(section: 'privacy'))),
                    isDark: isDark,
                  ),
                  _buildDivider(isDark),
                  _buildListTile(
                    icon: Icons.help_outline,
                    title: 'Help Center',
                    onTap: () => _showToast('Opening Help Center...'),
                    isDark: isDark,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // ── Log Out Button ────────────────────────────────────────────
            InkWell(
              onTap: _handleLogout,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
                ),
                child: Row(
                  children: [
                    Icon(Icons.logout, color: isDark ? Colors.white70 : Colors.black87),
                    const SizedBox(width: 16),
                    Text(
                      'Log Out',
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black87,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 100), // padding for bottom nav
          ],
        ),
      ),
    );
  }

  Widget _buildListTile({required IconData icon, required String title, required VoidCallback onTap, required bool isDark}) {
    return ListTile(
      leading: Icon(icon, color: isDark ? Colors.white70 : Colors.black87),
      title: Text(
        title,
        style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontSize: 14, fontWeight: FontWeight.w500),
      ),
      trailing: Icon(Icons.chevron_right, color: isDark ? Colors.white54 : Colors.black38),
      onTap: onTap,
    );
  }

  Widget _buildDivider(bool isDark) {
    return Divider(color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05), height: 1, indent: 50, endIndent: 16);
  }
}