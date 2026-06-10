import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../auth/theme.dart';
import '../services/notification_service.dart';
import 'notification_screen.dart';
import 'terms_screen.dart';
import 'home_screen.dart';
import 'order_screen.dart';
import 'profile_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotifications = true;
  bool _locationServices = true;
  bool _biometrics = false;
  bool _loginAlerts = true;
  bool _marketingEmails = false;
  String _selectedLanguage = 'English';
  String _selectedCurrency = 'UGX - Ugandan Shilling';
  int _selectedIndex = 2;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _pushNotifications = prefs.getBool('setting_push_notif') ?? true;
      _locationServices = prefs.getBool('setting_location') ?? true;
      _biometrics = prefs.getBool('setting_biometrics') ?? false;
      _loginAlerts = prefs.getBool('setting_login_alerts') ?? true;
      _marketingEmails = prefs.getBool('setting_marketing') ?? false;
      _selectedLanguage = prefs.getString('setting_language') ?? 'English';
      _selectedCurrency = prefs.getString('setting_currency') ?? 'UGX - Ugandan Shilling';
    });
  }

  Future<void> _savePref(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) await prefs.setBool(key, value);
    if (value is String) await prefs.setString(key, value);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, mode, _) {
        final isDark = mode == ThemeMode.dark;
        final bg = isDark ? const Color(0xFF0D0D0D) : const Color(0xFFF7F7F9);
        final surface = isDark ? const Color(0xFF1A1A1A) : Colors.white;
        final textPrimary = isDark ? Colors.white : const Color(0xFF111111);
        final textSecondary = isDark ? Colors.white54 : Colors.black54;
        final divider = isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE5E5E5);

        return Scaffold(
          backgroundColor: bg,
          appBar: AppBar(
            backgroundColor: bg,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded, color: textPrimary, size: 18),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text('Settings', style: TextStyle(color: textPrimary, fontWeight: FontWeight.w700, fontSize: 18)),
            centerTitle: true,
            actions: [const ThemeToggleButton()],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // ── Profile card ─────────────────────────────────────────
                GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen())),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.gold.withOpacity(0.3), width: 1),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 52, height: 52,
                          decoration: BoxDecoration(
                            gradient: AppTheme.buttonGradient,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Text('A', style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Alex Johnson', style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 16)),
                              const SizedBox(height: 2),
                              Text('alex.johnson@fuelconnect.ug', style: TextStyle(color: textSecondary, fontSize: 12)),
                              const SizedBox(height: 4),
                              Row(children: const [
                                Icon(Icons.verified_rounded, color: AppTheme.gold, size: 12),
                                SizedBox(width: 4),
                                Text('Verified Member', style: TextStyle(color: AppTheme.gold, fontSize: 11, fontWeight: FontWeight.w600)),
                              ]),
                            ],
                          ),
                        ),
                        Icon(Icons.chevron_right_rounded, color: textSecondary),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // ── Theme ─────────────────────────────────────────────────
                _sectionLabel('APPEARANCE', textSecondary),
                const SizedBox(height: 12),
                _buildThemeToggleTile(isDark, surface, textPrimary, textSecondary, divider),

                const SizedBox(height: 24),

                // ── Notifications ─────────────────────────────────────────
                _sectionLabel('NOTIFICATIONS', textSecondary),
                const SizedBox(height: 12),
                _buildCard(surface, divider, [
                  _toggleTile(
                    icon: Icons.notifications_active_rounded,
                    title: 'Push Notifications',
                    subtitle: 'Order updates, alerts & promotions',
                    value: _pushNotifications,
                    onChanged: (v) async { setState(() => _pushNotifications = v); await _savePref('setting_push_notif', v); },
                    textPrimary: textPrimary, textSecondary: textSecondary, divider: divider,
                  ),
                  _toggleTile(
                    icon: Icons.local_offer_rounded,
                    title: 'Marketing Emails',
                    subtitle: 'Promotions and fuel deals',
                    value: _marketingEmails,
                    onChanged: (v) async { setState(() => _marketingEmails = v); await _savePref('setting_marketing', v); },
                    textPrimary: textPrimary, textSecondary: textSecondary, divider: divider,
                    isLast: true,
                  ),
                ]),

                const SizedBox(height: 24),

                // ── Privacy & Security ────────────────────────────────────
                _sectionLabel('PRIVACY & SECURITY', textSecondary),
                const SizedBox(height: 12),
                _buildCard(surface, divider, [
                  _toggleTile(
                    icon: Icons.gps_fixed_rounded,
                    title: 'Location Services',
                    subtitle: 'Required for delivery tracking',
                    value: _locationServices,
                    onChanged: (v) async { setState(() => _locationServices = v); await _savePref('setting_location', v); },
                    textPrimary: textPrimary, textSecondary: textSecondary, divider: divider,
                  ),
                  _toggleTile(
                    icon: Icons.fingerprint_rounded,
                    title: 'Biometric Authentication',
                    subtitle: 'Fingerprint or face unlock',
                    value: _biometrics,
                    onChanged: (v) async {
                      setState(() => _biometrics = v);
                      await _savePref('setting_biometrics', v);
                      if (v) {
                        NotificationService().showNotification(
                          title: 'Biometric Enabled',
                          body: 'Biometric authentication is now active.',
                          type: NotifType.security,
                        );
                      }
                    },
                    textPrimary: textPrimary, textSecondary: textSecondary, divider: divider,
                  ),
                  _toggleTile(
                    icon: Icons.shield_rounded,
                    title: 'Login Alerts',
                    subtitle: 'Be notified of new device logins',
                    value: _loginAlerts,
                    onChanged: (v) async { setState(() => _loginAlerts = v); await _savePref('setting_login_alerts', v); },
                    textPrimary: textPrimary, textSecondary: textSecondary, divider: divider,
                  ),
                  _arrowTile(
                    icon: Icons.lock_reset_rounded,
                    title: 'Change Password',
                    subtitle: 'Update your account password',
                    onTap: () => _showChangePasswordDialog(surface, textPrimary, textSecondary),
                    textPrimary: textPrimary, textSecondary: textSecondary, divider: divider,
                    isLast: true,
                  ),
                ]),

                const SizedBox(height: 24),

                // ── Preferences ───────────────────────────────────────────
                _sectionLabel('PREFERENCES', textSecondary),
                const SizedBox(height: 12),
                _buildCard(surface, divider, [
                  _arrowTile(
                    icon: Icons.language_rounded,
                    title: 'Language',
                    subtitle: _selectedLanguage,
                    onTap: () => _showLanguagePicker(surface, textPrimary, textSecondary),
                    textPrimary: textPrimary, textSecondary: textSecondary, divider: divider,
                  ),
                  _arrowTile(
                    icon: Icons.currency_exchange_rounded,
                    title: 'Currency',
                    subtitle: _selectedCurrency,
                    onTap: () => _showCurrencyPicker(surface, textPrimary, textSecondary),
                    textPrimary: textPrimary, textSecondary: textSecondary, divider: divider,
                    isLast: true,
                  ),
                ]),

                const SizedBox(height: 24),

                // ── Legal ─────────────────────────────────────────────────
                _sectionLabel('LEGAL', textSecondary),
                const SizedBox(height: 12),
                _buildCard(surface, divider, [
                  _arrowTile(
                    icon: Icons.gavel_rounded,
                    title: 'Terms & Conditions',
                    subtitle: 'Fuel Connect delivery platform terms',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TermsScreen(section: 'terms'))),
                    textPrimary: textPrimary, textSecondary: textSecondary, divider: divider,
                  ),
                  _arrowTile(
                    icon: Icons.privacy_tip_rounded,
                    title: 'Privacy Policy',
                    subtitle: 'How we handle your personal data',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TermsScreen(section: 'privacy'))),
                    textPrimary: textPrimary, textSecondary: textSecondary, divider: divider,
                  ),
                  _arrowTile(
                    icon: Icons.info_outline_rounded,
                    title: 'About Fuel Connect',
                    subtitle: 'Version 2.1.8 (Build 218)',
                    onTap: () => _showAboutDialog(surface, textPrimary, textSecondary),
                    textPrimary: textPrimary, textSecondary: textSecondary, divider: divider,
                    isLast: true,
                  ),
                ]),

                const SizedBox(height: 28),

                // ── Logout ────────────────────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _showLogoutDialog(surface),
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

                const SizedBox(height: 12),

                // ── Delete Account ────────────────────────────────────────
                Center(
                  child: TextButton.icon(
                    onPressed: () => _showDeleteAccountDialog(surface),
                    icon: const Icon(Icons.delete_forever_rounded, size: 16, color: Colors.redAccent),
                    label: const Text('Delete Account', style: TextStyle(color: Colors.redAccent, fontSize: 13, fontWeight: FontWeight.w600)),
                  ),
                ),

                const SizedBox(height: 12),

                // ── Version ───────────────────────────────────────────────
                Center(
                  child: Text('FUEL CONNECT V2.1.8 • BUILD 218',
                      style: TextStyle(color: textSecondary.withOpacity(0.5), fontSize: 10, letterSpacing: 0.5)),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: surface,
              border: Border(top: BorderSide(color: divider, width: 0.5)),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
            ),
            child: BottomNavigationBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: AppTheme.gold,
              unselectedItemColor: textSecondary,
              selectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
              unselectedLabelStyle: const TextStyle(fontSize: 10),
              currentIndex: _selectedIndex,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home_rounded), label: 'Home'),
                BottomNavigationBarItem(icon: Icon(Icons.receipt_long_outlined), activeIcon: Icon(Icons.receipt_long_rounded), label: 'Orders'),
                BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), activeIcon: Icon(Icons.settings_rounded), label: 'Settings'),
                BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded), activeIcon: Icon(Icons.person_rounded), label: 'Profile'),
              ],
              onTap: (index) {
                setState(() => _selectedIndex = index);
                switch (index) {
                  case 0:
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const HomeScreen()), (r) => false);
                    break;
                  case 1:
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const OrderScreen()));
                    break;
                  case 2:
                    break; // Already on settings
                  case 3:
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
                    break;
                }
              },
            ),
          ),
        );
      },
    );
  }

  Widget _sectionLabel(String label, Color textSecondary) {
    return Text(label, style: TextStyle(color: textSecondary, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.1));
  }

  Widget _buildCard(Color surface, Color divider, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: divider, width: 0.5),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildThemeToggleTile(bool isDark, Color surface, Color textPrimary, Color textSecondary, Color divider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: divider, width: 0.5),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: AppTheme.gold.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: Icon(isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded, color: AppTheme.gold, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Theme', style: TextStyle(color: textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
              Text(isDark ? 'Dark Mode' : 'Light Mode', style: TextStyle(color: textSecondary, fontSize: 12)),
            ]),
          ),
          // Animated pill toggle
          GestureDetector(
            onTap: () => themeNotifier.toggleTheme(),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 72,
              height: 34,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE8E8E8),
                borderRadius: BorderRadius.circular(17),
                border: Border.all(color: AppTheme.gold.withOpacity(0.3), width: 1),
              ),
              child: Stack(
                children: [
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    left: isDark ? 38 : 2,
                    top: 2,
                    child: Container(
                      width: 30, height: 30,
                      decoration: BoxDecoration(
                        gradient: AppTheme.buttonGradient,
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: AppTheme.gold.withOpacity(0.3), blurRadius: 8)],
                      ),
                      child: Icon(isDark ? Icons.nightlight_round : Icons.wb_sunny_rounded,
                          color: Colors.black, size: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _toggleTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required Color textPrimary,
    required Color textSecondary,
    required Color divider,
    bool isLast = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      decoration: isLast ? null : BoxDecoration(border: Border(bottom: BorderSide(color: divider, width: 0.5))),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(color: AppTheme.gold.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: AppTheme.gold, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: TextStyle(color: textPrimary, fontSize: 14, fontWeight: FontWeight.w500)),
              Text(subtitle, style: TextStyle(color: textSecondary, fontSize: 11)),
            ]),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppTheme.gold,
            activeTrackColor: AppTheme.gold.withOpacity(0.3),
          ),
        ],
      ),
    );
  }

  Widget _arrowTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color textPrimary,
    required Color textSecondary,
    required Color divider,
    bool isLast = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(isLast ? 14 : 0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        decoration: isLast ? null : BoxDecoration(border: Border(bottom: BorderSide(color: divider, width: 0.5))),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(color: AppTheme.gold.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, color: AppTheme.gold, size: 16),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: TextStyle(color: textPrimary, fontSize: 14, fontWeight: FontWeight.w500)),
                Text(subtitle, style: TextStyle(color: textSecondary, fontSize: 11)),
              ]),
            ),
            Icon(Icons.chevron_right_rounded, color: textSecondary, size: 20),
          ],
        ),
      ),
    );
  }

  // ── Dialogs ─────────────────────────────────────────────────────────────────

  void _showChangePasswordDialog(Color surface, Color textPrimary, Color textSecondary) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentCtrl = TextEditingController();
    final newCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(children: [
          Icon(Icons.lock_reset_rounded, color: AppTheme.gold, size: 20),
          SizedBox(width: 8),
          Text('Change Password', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ]),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          const SizedBox(height: 4),
          _dialogField(currentCtrl, 'Current Password', Icons.lock_outline, true),
          const SizedBox(height: 12),
          _dialogField(newCtrl, 'New Password (min. 8 chars)', Icons.lock_open_rounded, true),
          const SizedBox(height: 12),
          _dialogField(confirmCtrl, 'Confirm New Password', Icons.lock_rounded, true),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppTheme.gold.withOpacity(0.08), borderRadius: BorderRadius.circular(8)),
            child: Row(children: const [
              Icon(Icons.info_outline_rounded, color: AppTheme.gold, size: 14),
              SizedBox(width: 8),
              Expanded(child: Text('Use 8+ chars with uppercase, lowercase, number & symbol.', style: TextStyle(fontSize: 11, color: AppTheme.gold))),
            ]),
          ),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (newCtrl.text.length >= 8 && newCtrl.text == confirmCtrl.text) {
                Navigator.pop(ctx);
                NotificationService().showNotification(title: 'Password Changed', body: 'Your account password was updated successfully.', type: NotifType.security);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password changed successfully'), backgroundColor: Colors.green));
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

  Widget _dialogField(TextEditingController ctrl, String label, IconData icon, bool obscure) {
    return TextField(
      controller: ctrl,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 13),
        prefixIcon: Icon(icon, color: AppTheme.gold, size: 18),
        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppTheme.gold, width: 0.5)),
        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppTheme.gold, width: 2)),
      ),
    );
  }

  void _showLanguagePicker(Color surface, Color textPrimary, Color textSecondary) {
    final languages = ['English', 'Luganda', 'Swahili', 'French', 'Arabic'];
    showModalBottomSheet(
      context: context,
      backgroundColor: surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          const Text('Select Language', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          ...languages.map((lang) => ListTile(
            leading: Icon(Icons.language_rounded, color: AppTheme.gold, size: 20),
            title: Text(lang, style: TextStyle(color: textPrimary, fontWeight: FontWeight.w500)),
            trailing: _selectedLanguage == lang ? const Icon(Icons.check_circle_rounded, color: AppTheme.gold) : null,
            onTap: () async {
              setState(() => _selectedLanguage = lang);
              await _savePref('setting_language', lang);
              if (mounted) Navigator.pop(context);
            },
          )),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _showCurrencyPicker(Color surface, Color textPrimary, Color textSecondary) {
    final currencies = ['UGX - Ugandan Shilling', 'KES - Kenyan Shilling', 'TZS - Tanzanian Shilling', 'USD - US Dollar'];
    showModalBottomSheet(
      context: context,
      backgroundColor: surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          const Text('Select Currency', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          ...currencies.map((cur) => ListTile(
            leading: Icon(Icons.currency_exchange_rounded, color: AppTheme.gold, size: 20),
            title: Text(cur, style: TextStyle(color: textPrimary, fontWeight: FontWeight.w500)),
            trailing: _selectedCurrency == cur ? const Icon(Icons.check_circle_rounded, color: AppTheme.gold) : null,
            onTap: () async {
              setState(() => _selectedCurrency = cur);
              await _savePref('setting_currency', cur);
              if (mounted) Navigator.pop(context);
            },
          )),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _showAboutDialog(Color surface, Color textPrimary, Color textSecondary) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(children: [
          Icon(Icons.local_gas_station_rounded, color: AppTheme.gold, size: 22),
          SizedBox(width: 8),
          Text('Fuel Connect', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppTheme.gold)),
        ]),
        content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Version 2.1.8 (Build 218)', style: TextStyle(color: textSecondary, fontSize: 13)),
          const SizedBox(height: 8),
          Text('Mobile Fuel Delivery Platform', style: TextStyle(color: textPrimary, fontWeight: FontWeight.w600, fontSize: 14)),
          const SizedBox(height: 8),
          Text('Connecting drivers, customers and fuel stations across Uganda for seamless on-demand fuel delivery.', style: TextStyle(color: textSecondary, fontSize: 13, height: 1.5)),
          const SizedBox(height: 12),
          Text('© 2026 Fuel Connect Ltd.', style: TextStyle(color: textSecondary, fontSize: 11)),
          Text('All rights reserved.', style: TextStyle(color: textSecondary, fontSize: 11)),
        ]),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close', style: TextStyle(color: AppTheme.gold)))],
      ),
    );
  }

  void _showLogoutDialog(Color surface) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: surface,
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
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(Color surface) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(children: [
          Icon(Icons.warning_rounded, color: Colors.redAccent, size: 22),
          SizedBox(width: 8),
          Text('Delete Account', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.redAccent)),
        ]),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.redAccent.withOpacity(0.08), borderRadius: BorderRadius.circular(10)),
            child: const Text('⚠️ This action is permanent and cannot be undone. All your data including order history, wallet balance, and account information will be permanently deleted.', style: TextStyle(fontSize: 13, height: 1.5, color: Colors.redAccent)),
          ),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Account deletion request submitted. You will be contacted via email.'), backgroundColor: Colors.redAccent, duration: Duration(seconds: 4)));
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
            child: const Text('Delete Account'),
          ),
        ],
      ),
    );
  }
}