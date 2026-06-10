import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../auth/theme.dart';
import '../services/notification_service.dart';
import 'notification_screen.dart';
import 'settings_screen.dart';
import 'order_screen.dart';
import 'home_screen.dart';
import 'terms_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  // Expanded states
  bool _accountInfoExpanded = false;
  bool _orderHistoryExpanded = false;
  bool _notificationsExpanded = false;
  bool _settingsExpanded = false;
  bool _securityExpanded = false;

  // Notification prefs
  bool _orderUpdatesEnabled = true;
  bool _promotionsEnabled = false;
  bool _securityAlertsEnabled = true;

  // Security
  bool _biometricEnabled = false;
  bool _twoFactorEnabled = false;
  bool _loginAlertsEnabled = true;

  // User data
  String _fullName = 'Alex Johnson';
  String _email = 'alex.johnson@fuelconnect.ug';
  String _phone = '+256 744 692 050';
  String _location = 'Kampala, Uganda';
  String _memberSince = 'March 2024';

  // Stats
  int _totalOrders = 24;
  String _totalLitres = '487L';
  String _totalSavings = 'UGX 12,400';

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _orderUpdatesEnabled = prefs.getBool('notif_orders') ?? true;
      _promotionsEnabled = prefs.getBool('notif_promos') ?? false;
      _securityAlertsEnabled = prefs.getBool('notif_security') ?? true;
      _biometricEnabled = prefs.getBool('sec_biometric') ?? false;
      _twoFactorEnabled = prefs.getBool('sec_2fa') ?? false;
      _loginAlertsEnabled = prefs.getBool('sec_login_alerts') ?? true;
    });
  }

  Future<void> _saveNotifPref(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, mode, _) {
        final isDark = mode == ThemeMode.dark;
        final bg = isDark ? const Color(0xFF0D0D0D) : const Color(0xFFF7F7F9);
        final cardColor = isDark ? const Color(0xFF1A1A1A) : Colors.white;
        final textPrimary = isDark ? Colors.white : const Color(0xFF111111);
        final textSecondary = isDark ? Colors.white54 : Colors.black54;
        final dividerColor = isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE5E5E5);
        const gold = AppTheme.gold;

        return Scaffold(
          backgroundColor: bg,
          appBar: AppBar(
            backgroundColor: bg,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: textPrimary),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text('Profile', style: TextStyle(color: textPrimary, fontWeight: FontWeight.w700, fontSize: 18)),
            centerTitle: true,
            actions: [
              const ThemeToggleButton(),
              ValueListenableBuilder<List<AppNotification>>(
                valueListenable: NotificationService().notifications,
                builder: (_, notifs, __) {
                  final unread = notifs.where((n) => !n.isRead).length;
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      IconButton(
                        icon: Icon(Icons.notifications_outlined, color: textPrimary),
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationScreen())),
                      ),
                      if (unread > 0)
                        Positioned(
                          top: 8, right: 8,
                          child: Container(
                            width: 14, height: 14,
                            decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
                            child: Center(child: Text('$unread', style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold))),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Profile Header ────────────────────────────────────────
                Center(
                  child: Column(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: AppTheme.buttonGradient,
                              boxShadow: [BoxShadow(color: gold.withOpacity(0.3), blurRadius: 20, spreadRadius: 2)],
                            ),
                            padding: const EdgeInsets.all(3),
                            child: CircleAvatar(
                              radius: 48,
                              backgroundColor: cardColor,
                              child: Text(
                                _fullName.isNotEmpty ? _fullName[0].toUpperCase() : 'U',
                                style: TextStyle(color: gold, fontSize: 36, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: -2,
                            right: -2,
                            child: GestureDetector(
                              onTap: _changeAvatar,
                              child: Container(
                                width: 34, height: 34,
                                decoration: BoxDecoration(
                                  color: gold, shape: BoxShape.circle,
                                  border: Border.all(color: bg, width: 2.5),
                                ),
                                child: const Icon(Icons.camera_alt_rounded, size: 16, color: Colors.black),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Text(_fullName, style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 22)),
                      const SizedBox(height: 4),
                      Text(_email, style: TextStyle(color: textSecondary, fontSize: 13)),
                      const SizedBox(height: 8),
                      // Verified badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: gold.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: gold.withOpacity(0.4), width: 1),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.verified_rounded, color: AppTheme.gold, size: 14),
                            const SizedBox(width: 6),
                            Text('Verified Member • Since $_memberSince',
                                style: const TextStyle(color: AppTheme.gold, fontSize: 11, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ── Stats Row ─────────────────────────────────────────────
                Row(
                  children: [
                    _buildStatCard('Orders', '$_totalOrders', Icons.local_shipping_rounded, cardColor, textPrimary, textSecondary),
                    const SizedBox(width: 10),
                    _buildStatCard('Delivered', _totalLitres, Icons.local_gas_station_rounded, cardColor, textPrimary, textSecondary),
                    const SizedBox(width: 10),
                    _buildStatCard('Savings', _totalSavings, Icons.savings_rounded, cardColor, textPrimary, textSecondary),
                  ],
                ),

                const SizedBox(height: 20),

                // ── Account Info ──────────────────────────────────────────
                _buildExpandableSection(
                  title: 'Account Info',
                  isExpanded: _accountInfoExpanded,
                  onToggle: () => setState(() => _accountInfoExpanded = !_accountInfoExpanded),
                  icon: Icons.person_rounded,
                  cardColor: cardColor,
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                  dividerColor: dividerColor,
                  children: [
                    _buildEditableItem(icon: Icons.email_rounded, label: 'Email', value: _email,
                        onEdit: () => _editField('Email', _email, (v) => setState(() => _email = v)),
                        onDelete: () => _deleteField('Email', () => setState(() => _email = '')),
                        textPrimary: textPrimary, textSecondary: textSecondary, dividerColor: dividerColor),
                    _buildEditableItem(icon: Icons.phone_rounded, label: 'Phone', value: _phone,
                        onEdit: () => _editField('Phone', _phone, (v) => setState(() => _phone = v)),
                        onDelete: () => _deleteField('Phone', () => setState(() => _phone = '')),
                        textPrimary: textPrimary, textSecondary: textSecondary, dividerColor: dividerColor),
                    _buildEditableItem(icon: Icons.location_on_rounded, label: 'Location', value: _location,
                        onEdit: () => _editField('Location', _location, (v) => setState(() => _location = v)),
                        onDelete: () => _deleteField('Location', () => setState(() => _location = '')),
                        textPrimary: textPrimary, textSecondary: textSecondary, dividerColor: dividerColor),
                  ],
                ),

                const SizedBox(height: 12),

                // ── Order History ─────────────────────────────────────────
                _buildExpandableSection(
                  title: 'Order History',
                  isExpanded: _orderHistoryExpanded,
                  onToggle: () => setState(() => _orderHistoryExpanded = !_orderHistoryExpanded),
                  icon: Icons.receipt_long_rounded,
                  cardColor: cardColor,
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                  dividerColor: dividerColor,
                  children: [
                    _buildOrderItem('#FC-2024-0891', 'Jun 8, 2026', '20L Petrol', 'UGX 97,000', 'Delivered', cardColor, textPrimary, textSecondary),
                    _buildOrderItem('#FC-2024-0876', 'Jun 3, 2026', '15L Diesel', 'UGX 71,250', 'Delivered', cardColor, textPrimary, textSecondary),
                    _buildOrderItem('#FC-2024-0865', 'May 29, 2026', '30L Petrol', 'UGX 145,500', 'Processing', cardColor, textPrimary, textSecondary),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: TextButton.icon(
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const OrderScreen())),
                        icon: const Icon(Icons.history_rounded, size: 16, color: AppTheme.gold),
                        label: const Text('View All Orders', style: TextStyle(color: AppTheme.gold, fontWeight: FontWeight.w600, fontSize: 13)),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // ── Security ──────────────────────────────────────────────
                _buildExpandableSection(
                  title: 'Security',
                  isExpanded: _securityExpanded,
                  onToggle: () => setState(() => _securityExpanded = !_securityExpanded),
                  icon: Icons.security_rounded,
                  cardColor: cardColor,
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                  dividerColor: dividerColor,
                  children: [
                    _buildToggleItem(
                      icon: Icons.fingerprint_rounded,
                      title: 'Biometric Login',
                      subtitle: 'Use fingerprint or face to sign in',
                      value: _biometricEnabled,
                      onChanged: (v) async {
                        setState(() => _biometricEnabled = v);
                        await _saveNotifPref('sec_biometric', v);
                        if (v) {
                          NotificationService().showNotification(
                            title: 'Biometric Enabled',
                            body: 'Biometric authentication has been activated for your account.',
                            type: NotifType.security,
                          );
                        }
                      },
                      textPrimary: textPrimary, textSecondary: textSecondary, dividerColor: dividerColor,
                    ),
                    _buildToggleItem(
                      icon: Icons.shield_rounded,
                      title: 'Two-Factor Authentication',
                      subtitle: 'Adds an extra layer of security',
                      value: _twoFactorEnabled,
                      onChanged: (v) async {
                        setState(() => _twoFactorEnabled = v);
                        await _saveNotifPref('sec_2fa', v);
                        if (v) {
                          NotificationService().showNotification(
                            title: '2FA Activated',
                            body: 'Two-factor authentication is now active on your account.',
                            type: NotifType.security,
                          );
                        }
                      },
                      textPrimary: textPrimary, textSecondary: textSecondary, dividerColor: dividerColor,
                    ),
                    _buildToggleItem(
                      icon: Icons.notifications_active_rounded,
                      title: 'Login Alerts',
                      subtitle: 'Get notified on new logins',
                      value: _loginAlertsEnabled,
                      onChanged: (v) async {
                        setState(() => _loginAlertsEnabled = v);
                        await _saveNotifPref('sec_login_alerts', v);
                      },
                      textPrimary: textPrimary, textSecondary: textSecondary, dividerColor: dividerColor,
                    ),
                    _buildArrowItem(
                      icon: Icons.lock_reset_rounded,
                      title: 'Change Password',
                      subtitle: 'Update your account password',
                      onTap: () => _showChangePasswordDialog(),
                      textPrimary: textPrimary, textSecondary: textSecondary, dividerColor: dividerColor,
                    ),
                    _buildArrowItem(
                      icon: Icons.devices_rounded,
                      title: 'Active Sessions',
                      subtitle: 'Manage devices logged into your account',
                      onTap: () => _showActiveSessionsDialog(textPrimary, cardColor),
                      textPrimary: textPrimary, textSecondary: textSecondary, dividerColor: dividerColor,
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // ── Notifications ─────────────────────────────────────────
                _buildExpandableSection(
                  title: 'Notifications',
                  isExpanded: _notificationsExpanded,
                  onToggle: () => setState(() => _notificationsExpanded = !_notificationsExpanded),
                  icon: Icons.notifications_rounded,
                  cardColor: cardColor,
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                  dividerColor: dividerColor,
                  children: [
                    _buildToggleItem(
                      icon: Icons.local_shipping_rounded,
                      title: 'Order Updates',
                      subtitle: 'Driver location, ETA and delivery status',
                      value: _orderUpdatesEnabled,
                      onChanged: (v) async {
                        setState(() => _orderUpdatesEnabled = v);
                        await _saveNotifPref('notif_orders', v);
                      },
                      textPrimary: textPrimary, textSecondary: textSecondary, dividerColor: dividerColor,
                    ),
                    _buildToggleItem(
                      icon: Icons.local_offer_rounded,
                      title: 'Promotions & Offers',
                      subtitle: 'Fuel discounts and cashback deals',
                      value: _promotionsEnabled,
                      onChanged: (v) async {
                        setState(() => _promotionsEnabled = v);
                        await _saveNotifPref('notif_promos', v);
                      },
                      textPrimary: textPrimary, textSecondary: textSecondary, dividerColor: dividerColor,
                    ),
                    _buildToggleItem(
                      icon: Icons.security_rounded,
                      title: 'Security Alerts',
                      subtitle: 'Login attempts and account changes',
                      value: _securityAlertsEnabled,
                      onChanged: (v) async {
                        setState(() => _securityAlertsEnabled = v);
                        await _saveNotifPref('notif_security', v);
                      },
                      textPrimary: textPrimary, textSecondary: textSecondary, dividerColor: dividerColor,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: TextButton.icon(
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationScreen())),
                        icon: const Icon(Icons.tune_rounded, size: 16, color: AppTheme.gold),
                        label: const Text('View All Notifications', style: TextStyle(color: AppTheme.gold, fontWeight: FontWeight.w600, fontSize: 13)),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // ── Settings ──────────────────────────────────────────────
                _buildExpandableSection(
                  title: 'App Settings',
                  isExpanded: _settingsExpanded,
                  onToggle: () => setState(() => _settingsExpanded = !_settingsExpanded),
                  icon: Icons.settings_rounded,
                  cardColor: cardColor,
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                  dividerColor: dividerColor,
                  children: [
                    _buildArrowItem(
                      icon: Icons.settings_rounded,
                      title: 'All Settings',
                      subtitle: 'Language, privacy, preferences',
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())),
                      textPrimary: textPrimary, textSecondary: textSecondary, dividerColor: dividerColor,
                    ),
                    _buildArrowItem(
                      icon: Icons.gavel_rounded,
                      title: 'Terms & Conditions',
                      subtitle: 'Fuel Connect delivery platform terms',
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TermsScreen(section: 'terms'))),
                      textPrimary: textPrimary, textSecondary: textSecondary, dividerColor: dividerColor,
                    ),
                    _buildArrowItem(
                      icon: Icons.privacy_tip_rounded,
                      title: 'Privacy Policy',
                      subtitle: 'How we handle your data',
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TermsScreen(section: 'privacy'))),
                      textPrimary: textPrimary, textSecondary: textSecondary, dividerColor: dividerColor,
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // ── Dark Mode Toggle ──────────────────────────────────────
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: dividerColor, width: 0.5),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppTheme.gold.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                          color: AppTheme.gold, size: 22,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Dark Mode', style: TextStyle(color: textPrimary, fontSize: 15, fontWeight: FontWeight.w600)),
                            Text(isDark ? 'Currently enabled' : 'Currently disabled', style: TextStyle(color: textSecondary, fontSize: 11)),
                          ],
                        ),
                      ),
                      Switch(
                        value: isDark,
                        onChanged: (_) => themeNotifier.toggleTheme(),
                        activeColor: AppTheme.gold,
                        activeTrackColor: AppTheme.gold.withOpacity(0.3),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // ── Logout Button ─────────────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _showLogoutDialog,
                    icon: const Icon(Icons.logout_rounded, size: 20),
                    label: const Text('Sign Out', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent.withOpacity(0.1),
                      foregroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: BorderSide(color: Colors.redAccent.withOpacity(0.3), width: 1),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // ── Bottom Nav ────────────────────────────────────────────
                _buildBottomNav(cardColor, textPrimary, dividerColor),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon,
      Color cardColor, Color textPrimary, Color textSecondary) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.gold.withOpacity(0.15), width: 0.5),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppTheme.gold, size: 20),
            const SizedBox(height: 6),
            Text(value, style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(color: textSecondary, fontSize: 10)),
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
    required Color cardColor,
    required Color textPrimary,
    required Color textSecondary,
    required Color dividerColor,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: dividerColor, width: 0.5),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.gold.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, color: AppTheme.gold, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(title, style: TextStyle(color: textPrimary, fontWeight: FontWeight.w600, fontSize: 15)),
                  ),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 250),
                    child: Icon(Icons.keyboard_arrow_down_rounded,
                        color: textSecondary, size: 22),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Column(
              children: [
                Divider(height: 1, color: AppTheme.gold.withOpacity(0.2)),
                ...children,
              ],
            ),
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
    required Color textPrimary,
    required Color textSecondary,
    required Color dividerColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: dividerColor, width: 0.5))),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.gold, size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(color: textSecondary, fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
                const SizedBox(height: 3),
                Text(value.isEmpty ? 'Not set' : value,
                    style: TextStyle(color: textPrimary, fontSize: 14, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          Row(mainAxisSize: MainAxisSize.min, children: [
            GestureDetector(
              onTap: onEdit,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: AppTheme.gold.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                child: const Icon(Icons.edit_rounded, size: 14, color: AppTheme.gold),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onDelete,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: Colors.redAccent.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                child: const Icon(Icons.delete_outline_rounded, size: 14, color: Colors.redAccent),
              ),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildToggleItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
    required Color textPrimary,
    required Color textSecondary,
    required Color dividerColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: dividerColor, width: 0.5))),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.gold, size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: textPrimary, fontSize: 14, fontWeight: FontWeight.w500)),
                Text(subtitle, style: TextStyle(color: textSecondary, fontSize: 11)),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged, activeColor: AppTheme.gold, activeTrackColor: AppTheme.gold.withOpacity(0.3)),
        ],
      ),
    );
  }

  Widget _buildArrowItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color textPrimary,
    required Color textSecondary,
    required Color dividerColor,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: dividerColor, width: 0.5))),
        child: Row(
          children: [
            Icon(icon, color: AppTheme.gold, size: 18),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(color: textPrimary, fontSize: 14, fontWeight: FontWeight.w500)),
                  Text(subtitle, style: TextStyle(color: textSecondary, fontSize: 11)),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: textSecondary, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItem(String id, String date, String desc, String amount,
      String status, Color cardColor, Color textPrimary, Color textSecondary) {
    final isDelivered = status == 'Delivered';
    return GestureDetector(
      onTap: () => _showOrderDetail(id, date, desc, amount, status, textPrimary, cardColor, textSecondary),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cardColor.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppTheme.gold.withOpacity(0.1), width: 0.5),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDelivered ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                isDelivered ? Icons.check_circle_rounded : Icons.hourglass_top_rounded,
                color: isDelivered ? Colors.green : Colors.orange, size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(id, style: TextStyle(color: textPrimary, fontWeight: FontWeight.w700, fontSize: 13)),
                  Text('$desc  •  $date', style: TextStyle(color: textSecondary, fontSize: 11)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(amount, style: const TextStyle(color: AppTheme.gold, fontWeight: FontWeight.bold, fontSize: 12)),
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: isDelivered ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(status, style: TextStyle(color: isDelivered ? Colors.green : Colors.orange, fontSize: 10, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav(Color cardColor, Color textPrimary, Color dividerColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: dividerColor, width: 0.5),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 16, offset: const Offset(0, 4))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavBtn(Icons.home_rounded, false, () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const HomeScreen()), (r) => false)),
          _buildNavBtn(Icons.receipt_long_rounded, false, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const OrderScreen()))),
          Container(
            width: 50, height: 50,
            decoration: BoxDecoration(gradient: AppTheme.buttonGradient, shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: AppTheme.gold.withOpacity(0.4), blurRadius: 12, spreadRadius: 1)]),
            child: IconButton(
              icon: const Icon(Icons.local_gas_station_rounded, color: Colors.black, size: 22),
              onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const HomeScreen()), (r) => false),
            ),
          ),
          ValueListenableBuilder<List<AppNotification>>(
            valueListenable: NotificationService().notifications,
            builder: (_, notifs, __) {
              final unread = notifs.where((n) => !n.isRead).length;
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  _buildNavBtn(Icons.notifications_outlined, false, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationScreen()))),
                  if (unread > 0)
                    Positioned(top: 0, right: 0,
                      child: Container(width: 12, height: 12,
                        decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
                        child: Center(child: Text('$unread', style: const TextStyle(color: Colors.white, fontSize: 7, fontWeight: FontWeight.bold))),
                      ),
                    ),
                ],
              );
            },
          ),
          _buildNavBtn(Icons.person_rounded, true, null),
        ],
      ),
    );
  }

  Widget _buildNavBtn(IconData icon, bool active, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(icon, color: active ? AppTheme.gold : Colors.grey, size: 24),
    );
  }

  // ── Dialog Methods ──────────────────────────────────────────────────────────

  void _changeAvatar() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('Change Profile Photo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 20),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            _photoOption(Icons.camera_alt_rounded, 'Camera', () => Navigator.pop(context)),
            _photoOption(Icons.photo_library_rounded, 'Gallery', () => Navigator.pop(context)),
            _photoOption(Icons.delete_rounded, 'Remove', () => Navigator.pop(context)),
          ]),
          const SizedBox(height: 16),
        ]),
      ),
    );
  }

  Widget _photoOption(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(children: [
        Container(
          width: 56, height: 56,
          decoration: BoxDecoration(color: AppTheme.gold.withOpacity(0.1), shape: BoxShape.circle),
          child: Icon(icon, color: AppTheme.gold, size: 24),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
      ]),
    );
  }

  void _editField(String field, String currentValue, Function(String) onSave) {
    final controller = TextEditingController(text: currentValue);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(children: [
          const Icon(Icons.edit_rounded, color: AppTheme.gold, size: 20),
          const SizedBox(width: 8),
          Text('Edit $field', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ]),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Enter new $field',
            enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppTheme.gold)),
            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppTheme.gold, width: 2)),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) onSave(controller.text.trim());
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.gold, foregroundColor: Colors.black),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _deleteField(String field, VoidCallback onDelete) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(children: [
          const Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 24),
          const SizedBox(width: 8),
          Text('Remove $field', style: const TextStyle(fontWeight: FontWeight.bold)),
        ]),
        content: Text('Are you sure you want to remove your $field information?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () { onDelete(); Navigator.pop(ctx); },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentCtrl = TextEditingController();
    final newCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(children: [
          Icon(Icons.lock_reset_rounded, color: AppTheme.gold, size: 20),
          SizedBox(width: 8),
          Text('Change Password', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ]),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: currentCtrl, obscureText: true, decoration: const InputDecoration(labelText: 'Current Password', prefixIcon: Icon(Icons.lock_outline, color: AppTheme.gold))),
          const SizedBox(height: 12),
          TextField(controller: newCtrl, obscureText: true, decoration: const InputDecoration(labelText: 'New Password', prefixIcon: Icon(Icons.lock_open_rounded, color: AppTheme.gold))),
          const SizedBox(height: 12),
          TextField(controller: confirmCtrl, obscureText: true, decoration: const InputDecoration(labelText: 'Confirm New Password', prefixIcon: Icon(Icons.lock_rounded, color: AppTheme.gold))),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (newCtrl.text.length >= 8 && newCtrl.text == confirmCtrl.text) {
                Navigator.pop(ctx);
                NotificationService().showNotification(title: 'Password Changed', body: 'Your account password has been updated successfully.', type: NotifType.security);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password updated successfully'), backgroundColor: Colors.green));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Passwords must match and be 8+ characters'), backgroundColor: Colors.redAccent));
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.gold, foregroundColor: Colors.black),
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showActiveSessionsDialog(Color textPrimary, Color cardColor) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(children: [
          Icon(Icons.devices_rounded, color: AppTheme.gold, size: 20),
          SizedBox(width: 8),
          Text('Active Sessions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ]),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          _sessionTile('This device', 'Chrome • Windows 11', 'Active now', true),
          const Divider(),
          _sessionTile('Unknown device', 'Safari • iOS 17', '2 days ago', false),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              NotificationService().showNotification(title: 'Sessions Cleared', body: 'All other sessions have been signed out.', type: NotifType.security);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
            child: const Text('Sign Out Others'),
          ),
        ],
      ),
    );
  }

  Widget _sessionTile(String device, String details, String time, bool isCurrent) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: AppTheme.gold.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
        child: Icon(isCurrent ? Icons.computer_rounded : Icons.phone_android_rounded, color: AppTheme.gold, size: 18),
      ),
      title: Text(device, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
      subtitle: Text('$details\n$time', style: const TextStyle(fontSize: 11)),
      trailing: isCurrent
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
              child: const Text('Current', style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.w600)),
            )
          : IconButton(
              icon: const Icon(Icons.close_rounded, color: Colors.redAccent, size: 18),
              onPressed: () {},
            ),
    );
  }

  void _showOrderDetail(String id, String date, String desc, String amount,
      String status, Color textPrimary, Color cardColor, Color textSecondary) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(id, style: const TextStyle(color: AppTheme.gold, fontWeight: FontWeight.bold, fontSize: 15)),
        content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          _orderDetailRow(Icons.calendar_today_rounded, 'Date', date),
          _orderDetailRow(Icons.local_gas_station_rounded, 'Fuel', desc),
          _orderDetailRow(Icons.payments_rounded, 'Amount', amount),
          _orderDetailRow(Icons.info_rounded, 'Status', status),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
          ElevatedButton(
            onPressed: () { Navigator.pop(ctx); },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.gold, foregroundColor: Colors.black),
            child: const Text('Reorder'),
          ),
        ],
      ),
    );
  }

  Widget _orderDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(children: [
        Icon(icon, color: AppTheme.gold, size: 16),
        const SizedBox(width: 10),
        Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 13))),
      ]),
    );
  }

  void _showLogoutDialog() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(children: [
          Icon(Icons.logout_rounded, color: Colors.redAccent, size: 22),
          SizedBox(width: 8),
          Text('Sign Out', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ]),
        content: const Text('Are you sure you want to sign out of your Fuel Connect account?', style: TextStyle(fontSize: 14, height: 1.5)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushNamedAndRemoveUntil(context, '/login', (r) => false);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}