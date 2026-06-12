import 'package:flutter/material.dart';
import '../auth/theme.dart';
import '../widgets/theme_toggle_button.dart';
import '../services/auth_service.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  
  bool _notificationsEnabled = true;
  String _fullName = 'Loading...';
  String _email = 'Loading...';

  @override
  void initState() {
    super.initState();
    _loadUserData();
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
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
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
                    onPressed: () => _showToast('Edit Profile clicked'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // ── General Section ───────────────────────────────────────────
            Text(
              'General',
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                children: [
                  _buildListTile(
                    icon: Icons.payment_outlined,
                    title: 'Payment Method',
                    onTap: () => _showToast('Payment Method clicked'),
                    isDark: isDark,
                  ),
                  _buildDivider(isDark),
                  _buildListTile(
                    icon: Icons.location_on_outlined,
                    title: 'Location',
                    onTap: () => _showToast('Location clicked'),
                    isDark: isDark,
                  ),
                  _buildDivider(isDark),
                  _buildListTile(
                    icon: Icons.g_translate_outlined,
                    title: 'Language',
                    onTap: () => _showToast('Language clicked'),
                    isDark: isDark,
                  ),
                  _buildDivider(isDark),
                  ListTile(
                    leading: Icon(Icons.notifications_none_outlined, color: isDark ? Colors.white70 : Colors.black87),
                    title: Text(
                      'Notification',
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black87,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: Switch(
                      value: _notificationsEnabled,
                      activeColor: AppTheme.gold,
                      onChanged: (val) {
                        setState(() => _notificationsEnabled = val);
                        _showToast(val ? 'Notifications Enabled' : 'Notifications Disabled');
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // ── Support Section ───────────────────────────────────────────
            Text(
              'Support',
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                children: [
                  _buildListTile(
                    icon: Icons.feedback_outlined,
                    title: 'Feedback',
                    onTap: () => _showToast('Feedback clicked'),
                    isDark: isDark,
                  ),
                  _buildDivider(isDark),
                  _buildListTile(
                    icon: Icons.share_outlined,
                    title: 'Share',
                    onTap: () => _showToast('Share clicked'),
                    isDark: isDark,
                  ),
                  _buildDivider(isDark),
                  _buildListTile(
                    icon: Icons.help_outline,
                    title: 'Help',
                    onTap: () => _showToast('Help clicked'),
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
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
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
            const SizedBox(height: 100), // padding for bottom nav if any
          ],
        ),
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return ListTile(
      leading: Icon(icon, color: isDark ? Colors.white70 : Colors.black87),
      title: Text(
        title,
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black87,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(Icons.chevron_right, color: isDark ? Colors.white54 : Colors.black38),
      onTap: onTap,
    );
  }

  Widget _buildDivider(bool isDark) {
    return Divider(
      color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05),
      height: 1,
      indent: 50,
      endIndent: 16,
    );
  }
}