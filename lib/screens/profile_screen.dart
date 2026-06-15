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

  String _fullName = '';
  String _email = '';
  bool _isLoading = true;

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
      // First, try loading the locally cached user info for instantaneous UX
      final user = await _authService.getCurrentUser();
      if (user != null) {
        if (mounted) {
          setState(() {
            _fullName = user.fullName;
            _email = user.email;
            _isLoading = false; // Disable skeleton loading if we have cached details
          });
        }
      }
      
      // Then, query the remote backend to refresh details
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
      if (mounted && _fullName.isEmpty) {
        setState(() {
          _fullName = 'Muhammad';
          _email = 'example@gmail.com';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
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
              // Pull Bar indicator
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white24 : Colors.black12,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
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
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark 
                      ? [const Color(0xFF1E1E1E), const Color(0xFF141414)] 
                      : [Colors.white, const Color(0xFFFAFAFA)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isDark ? Colors.white.withOpacity(0.04) : Colors.black.withOpacity(0.04),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  )
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Glow Ring around Avatar
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [AppTheme.gold, AppTheme.darkGold],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.gold.withOpacity(0.2),
                              blurRadius: 8,
                              spreadRadius: 1,
                            )
                          ],
                        ),
                        padding: const EdgeInsets.all(2),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: isDark ? const Color(0xFF1C1C1E) : Colors.white,
                          child: Icon(
                            Icons.person_outline, 
                            color: isDark ? Colors.white : Colors.black87, 
                            size: 30,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Shimmer / Pulse skeleton loader or real name
                            _isLoading && _fullName.isEmpty
                                ? const PulseSkeleton(width: 140, height: 16)
                                : Text(
                                    _fullName,
                                    style: TextStyle(
                                      color: isDark ? Colors.white : Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                            const SizedBox(height: 6),
                            _isLoading && _email.isEmpty
                                ? const PulseSkeleton(width: 180, height: 12)
                                : Text(
                                    _email,
                                    style: TextStyle(
                                      color: isDark ? Colors.white60 : Colors.black54,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.03),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.edit_outlined, 
                            color: isDark ? Colors.white70 : Colors.black87,
                            size: 18,
                          ),
                        ),
                        onPressed: _showEditProfileModal,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Divider(
                    color: isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.08),
                    height: 1,
                  ),
                  const SizedBox(height: 16),
                  
                  // Statistics Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem(
                        value: '15',
                        label: 'Total Orders',
                        icon: Icons.local_gas_station_outlined,
                        isDark: isDark,
                      ),
                      _buildStatDivider(isDark),
                      _buildStatItem(
                        value: '240 L',
                        label: 'Fuel Saved',
                        icon: Icons.water_drop_outlined,
                        isDark: isDark,
                      ),
                      _buildStatDivider(isDark),
                      _buildStatItem(
                        value: '450',
                        label: 'Loyalty Points',
                        icon: Icons.star_outline_rounded,
                        isDark: isDark,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // ── General Section ───────────────────────────────────────────
            _buildSectionHeader('GENERAL SETTINGS', isDark),
            const SizedBox(height: 12),
            Container(
              decoration: _buildSectionDecoration(isDark),
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
                  _buildSwitchTile(
                    icon: Icons.notifications_none_outlined,
                    title: 'Push Notifications',
                    value: _notificationsEnabled,
                    onChanged: (val) {
                      setState(() => _notificationsEnabled = val);
                      _savePref('notif_orders', val);
                      _showToast(val ? 'Notifications Enabled' : 'Notifications Disabled');
                    },
                    isDark: isDark,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // ── Security Section ───────────────────────────────────────────
            _buildSectionHeader('SECURITY', isDark),
            const SizedBox(height: 12),
            Container(
              decoration: _buildSectionDecoration(isDark),
              child: Column(
                children: [
                  _buildSwitchTile(
                    icon: Icons.fingerprint_rounded,
                    title: 'Biometric Login',
                    value: _biometricEnabled,
                    onChanged: (val) {
                      setState(() => _biometricEnabled = val);
                      _savePref('sec_biometric', val);
                      _showToast(val ? 'Biometrics Enabled' : 'Biometrics Disabled');
                    },
                    isDark: isDark,
                  ),
                  _buildDivider(isDark),
                  _buildSwitchTile(
                    icon: Icons.security_rounded,
                    title: 'Two-Factor Authentication',
                    value: _twoFactorEnabled,
                    onChanged: (val) {
                      setState(() => _twoFactorEnabled = val);
                      _savePref('sec_2fa', val);
                      _showToast(val ? '2FA Enabled' : '2FA Disabled');
                    },
                    isDark: isDark,
                  ),
                  _buildDivider(isDark),
                  _buildSwitchTile(
                    icon: Icons.phonelink_ring_rounded,
                    title: 'Login Alerts',
                    value: _loginAlertsEnabled,
                    onChanged: (val) {
                      setState(() => _loginAlertsEnabled = val);
                      _savePref('sec_login_alerts', val);
                      _showToast(val ? 'Login Alerts Enabled' : 'Login Alerts Disabled');
                    },
                    isDark: isDark,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // ── Support & Legal Section ───────────────────────────────────────────
            _buildSectionHeader('SUPPORT & LEGAL', isDark),
            const SizedBox(height: 12),
            Container(
              decoration: _buildSectionDecoration(isDark),
              child: Column(
                children: [
                  _buildListTile(
                    icon: Icons.rule_rounded,
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
                    icon: Icons.help_outline_rounded,
                    title: 'Help Center',
                    onTap: () => _showToast('Opening Help Center...'),
                    isDark: isDark,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // ── Log Out Button ────────────────────────────────────────────
            InkWell(
              onTap: _handleLogout,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2C1E1E) : const Color(0xFFFFF5F5),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? Colors.redAccent.withOpacity(0.15) : Colors.redAccent.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.logout_rounded, color: Colors.redAccent, size: 20),
                    const SizedBox(width: 12),
                    Text(
                      'Log Out',
                      style: TextStyle(
                        color: isDark ? const Color(0xFFFF6B6B) : Colors.redAccent,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20), // padding for bottom nav
          ],
        ),
      ),
    );
  }

  // ── Helper Widgets ─────────────────────────────────────────────────────────

  Widget _buildSectionHeader(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Text(
        title,
        style: TextStyle(
          color: isDark ? Colors.white60 : Colors.black54,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  BoxDecoration _buildSectionDecoration(bool isDark) {
    return BoxDecoration(
      color: isDark ? const Color(0xFF141414) : Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: isDark ? Colors.white.withOpacity(0.03) : Colors.black.withOpacity(0.03),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
          blurRadius: 10,
          offset: const Offset(0, 4),
        )
      ],
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required bool isDark,
    Color? iconColor,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (iconColor ?? AppTheme.gold).withOpacity(isDark ? 0.1 : 0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor ?? AppTheme.gold, size: 18),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black87,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right, 
        color: isDark ? Colors.white30 : Colors.black38,
        size: 18,
      ),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
    required bool isDark,
    Color? iconColor,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (iconColor ?? AppTheme.gold).withOpacity(isDark ? 0.1 : 0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor ?? AppTheme.gold, size: 18),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black87,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: Switch.adaptive(
        value: value,
        activeColor: AppTheme.gold,
        activeTrackColor: AppTheme.gold.withOpacity(0.4),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildStatItem({
    required String value,
    required String label,
    required IconData icon,
    required bool isDark,
  }) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.gold, size: 18),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: isDark ? Colors.white54 : Colors.black54,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildStatDivider(bool isDark) {
    return Container(
      height: 24,
      width: 1,
      color: isDark ? Colors.white12 : Colors.black12,
    );
  }

  Widget _buildDivider(bool isDark) {
    return Divider(
      color: isDark ? Colors.white10 : Colors.black.withOpacity(0.04), 
      height: 1, 
      indent: 52, 
      endIndent: 16,
    );
  }
}

// ── Pulse Skeleton Loader Widget ─────────────────────────────────────────────

class PulseSkeleton extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius borderRadius;

  const PulseSkeleton({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(6)),
  });

  @override
  State<PulseSkeleton> createState() => _PulseSkeletonState();
}

class _PulseSkeletonState extends State<PulseSkeleton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _opacityAnimation = Tween<double>(begin: 0.2, end: 0.6).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AnimatedBuilder(
      animation: _opacityAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              color: isDark ? Colors.white12 : Colors.black12,
              borderRadius: widget.borderRadius,
            ),
          ),
        );
      },
    );
  }
}