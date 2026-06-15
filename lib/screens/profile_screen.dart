import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../auth/theme.dart';
import '../widgets/theme_toggle_button.dart';
import '../services/auth_service.dart';
import '../auth/login_screen.dart';
import 'settings_screen.dart';
import '../payment/order_summary_screen.dart';
import 'terms_screen.dart';
import 'notification_screen.dart';
import 'support_screen.dart';

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
  String _phone = '5478312096';
  String _selectedLanguage = 'English';
  bool _isLoading = true;
  bool _isUploadingImage = false;
  String _avatarPath = 'assets/images/avatar.png';

  final TextEditingController _editNameController = TextEditingController();
  final TextEditingController _editEmailController = TextEditingController();
  final TextEditingController _editPhoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPrefs();
    _loadUserData();
  }

  @override
  void dispose() {
    _editNameController.dispose();
    _editEmailController.dispose();
    _editPhoneController.dispose();
    super.dispose();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _biometricEnabled    = prefs.getBool('sec_biometric') ?? false;
      _twoFactorEnabled    = prefs.getBool('sec_2fa') ?? false;
      _loginAlertsEnabled  = prefs.getBool('sec_login_alerts') ?? true;
      _notificationsEnabled = prefs.getBool('notif_orders') ?? true;
      _selectedLanguage    = prefs.getString('language') ?? 'English';
    });
  }

  Future<void> _savePref(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  Future<void> _saveStringPref(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future<void> _loadUserData() async {
    try {
      final user = await _authService.getCurrentUser();
      if (user != null && mounted) {
        setState(() {
          _fullName  = user.fullName;
          _email     = user.email;
          _isLoading = false;
        });
      }
      final userResponse = await _authService.getMe();
      if (userResponse['success'] == true && userResponse['data'] != null) {
        final data = userResponse['data'];
        if (mounted) {
          setState(() {
            _fullName = data['full_name'] ?? _fullName;
            _email    = data['email']     ?? _email;
          });
        }
      }
    } catch (_) {
      if (mounted && _fullName.isEmpty) {
        setState(() {
          _fullName = 'Jane Doe';
          _email    = 'example@gmail.com';
        });
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
    try {
      await _authService.logout();
    } catch (_) {
      // Ignore network errors during logout
    }
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
      (route) => false,
    );
  }

  // ── Image picker ─────────────────────────────────────────────────────────────
  void _showImageSourcePicker() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface    = isDark ? const Color(0xFF1A1A1A) : Colors.white;
    final textPrimary = isDark ? Colors.white : const Color(0xFF111111);

    showModalBottomSheet(
      context: context,
      backgroundColor: surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40, height: 4,
            decoration: BoxDecoration(
              color: isDark ? Colors.white24 : Colors.black12,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Update Profile Picture',
            style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.photo_camera_rounded, color: AppTheme.gold),
            title: Text('Take Photo', style: TextStyle(color: textPrimary)),
            onTap: () { Navigator.pop(ctx); _simulateImageUpload(); },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library_rounded, color: AppTheme.gold),
            title: Text('Choose from Gallery', style: TextStyle(color: textPrimary)),
            onTap: () { Navigator.pop(ctx); _simulateImageUpload(); },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _simulateImageUpload() {
    setState(() => _isUploadingImage = true);
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      setState(() {
        _avatarPath      = 'assets/images/avatar_updated.png';
        _isUploadingImage = false;
      });
      _showToast('Profile picture updated!');
    });
  }

  // ── Edit Profile modal ───────────────────────────────────────────────────────
  void _showEditProfileModal() {
    _editNameController.text  = _fullName;
    _editEmailController.text = _email;
    _editPhoneController.text = _phone;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface    = isDark ? const Color(0xFF1A1A1A) : Colors.white;
    final textPrimary = isDark ? Colors.white : const Color(0xFF111111);
    final textSub    = isDark ? Colors.white54 : Colors.black54;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          top: 20, left: 24, right: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white24 : Colors.black12,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Account Details',
              style: TextStyle(color: textPrimary, fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            // Avatar
            Center(
              child: GestureDetector(
                onTap: _showImageSourcePicker,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 42,
                      backgroundImage: AssetImage(_avatarPath),
                      backgroundColor: isDark ? const Color(0xFF1C1C1E) : Colors.grey.shade200,
                    ),
                    Positioned(
                      bottom: 0, right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(7),
                        decoration: const BoxDecoration(color: AppTheme.gold, shape: BoxShape.circle),
                        child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 15),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            _inputField('Full Name', _editNameController, textPrimary, textSub, isDark),
            const SizedBox(height: 14),
            _inputField('Email', _editEmailController, textPrimary, textSub, isDark, type: TextInputType.emailAddress),
            const SizedBox(height: 14),
            _inputField('Phone Number', _editPhoneController, textPrimary, textSub, isDark, type: TextInputType.phone),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _fullName = _editNameController.text.trim().isNotEmpty ? _editNameController.text.trim() : _fullName;
                  _email    = _editEmailController.text.trim().isNotEmpty ? _editEmailController.text.trim() : _email;
                  _phone    = _editPhoneController.text.trim().isNotEmpty ? _editPhoneController.text.trim() : _phone;
                });
                Navigator.pop(ctx);
                _showToast('Profile updated successfully');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.gold,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              child: const Text('Save Changes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputField(String label, TextEditingController ctrl, Color textColor, Color labelColor, bool isDark, {TextInputType type = TextInputType.text}) {
    return TextField(
      controller: ctrl,
      keyboardType: type,
      style: TextStyle(color: textColor, fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: labelColor, fontSize: 13),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: isDark ? Colors.white12 : Colors.black12),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppTheme.gold, width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  // ── Language picker ───────────────────────────────────────────────────────────
  void _showLanguagePicker() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface    = isDark ? const Color(0xFF1A1A1A) : Colors.white;
    final textPrimary = isDark ? Colors.white : const Color(0xFF111111);

    final languages = ['English', 'French', 'Arabic', 'Swahili', 'Spanish', 'Portuguese'];

    showModalBottomSheet(
      context: context,
      backgroundColor: surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(color: isDark ? Colors.white24 : Colors.black12, borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 16),
            Text('Select Language', style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            ...languages.map((lang) => ListTile(
              leading: Icon(
                Icons.language_rounded,
                color: lang == _selectedLanguage ? AppTheme.gold : (isDark ? Colors.white38 : Colors.black38),
                size: 20,
              ),
              title: Text(lang, style: TextStyle(color: textPrimary, fontSize: 14, fontWeight: lang == _selectedLanguage ? FontWeight.bold : FontWeight.normal)),
              trailing: lang == _selectedLanguage ? const Icon(Icons.check_rounded, color: AppTheme.gold, size: 18) : null,
              onTap: () {
                setSheet(() {});
                setState(() => _selectedLanguage = lang);
                _saveStringPref('language', lang);
                Navigator.pop(ctx);
                _showToast('Language set to $lang');
              },
            )),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ── Delete account dialog ─────────────────────────────────────────────────────
  void _showDeleteConfirmation() {
    final phoneCtrl    = TextEditingController();
    final passwordCtrl = TextEditingController();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialog) => AlertDialog(
          backgroundColor: surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: const Row(children: [
            Icon(Icons.warning_rounded, color: Colors.redAccent, size: 22),
            SizedBox(width: 8),
            Text('Close Account', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.redAccent)),
          ]),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    '⚠️ This action is permanent and cannot be undone. Enter your credentials to confirm.',
                    style: TextStyle(fontSize: 12, height: 1.5, color: Colors.redAccent),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: phoneCtrl,
                  keyboardType: TextInputType.phone,
                  style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    labelStyle: TextStyle(fontSize: 12),
                    prefixIcon: Icon(Icons.phone_outlined, size: 18, color: AppTheme.gold),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppTheme.gold, width: 0.5)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppTheme.gold, width: 2)),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: passwordCtrl,
                  obscureText: true,
                  style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(fontSize: 12),
                    prefixIcon: Icon(Icons.lock_outline_rounded, size: 18, color: AppTheme.gold),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppTheme.gold, width: 0.5)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppTheme.gold, width: 2)),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                if (phoneCtrl.text.trim().isEmpty || passwordCtrl.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Please enter phone and password'),
                    backgroundColor: Colors.redAccent,
                    behavior: SnackBarBehavior.floating,
                  ));
                  return;
                }
                Navigator.pop(ctx);
                _handleLogout();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white, elevation: 0),
              child: const Text('Close Account'),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final isDark       = Theme.of(context).brightness == Brightness.dark;
    final bg           = isDark ? const Color(0xFF0D0D0D) : const Color(0xFFF2F3F5);
    final textPrimary  = isDark ? Colors.white : const Color(0xFF111111);
    final textSub      = isDark ? Colors.white54 : Colors.black45;
    final sectionLabel = isDark ? Colors.white38 : Colors.black38;
    final cardBg       = isDark ? const Color(0xFF161616) : Colors.white;
    final divColor     = isDark ? Colors.white.withOpacity(0.06) : Colors.black.withOpacity(0.05);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          'Profile',
          style: TextStyle(color: textPrimary, fontSize: 17, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: CustomThemeToggle(
              iconColor: isDark ? Colors.white70 : Colors.black54,
              bgColor: Colors.transparent,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Hero Header ──────────────────────────────────────────────
            _buildHeroHeader(isDark, textPrimary, textSub),

            const SizedBox(height: 8),

            // ── Profile Section ──────────────────────────────────────────
            _sectionLabel('Profile', sectionLabel),
            _menuCard(isDark, cardBg, divColor, [
              _navItem(Icons.person_outline_rounded,      'Account details',          textPrimary, isDark, _showEditProfileModal),
              _divider(divColor),
              _navItem(Icons.history_rounded,             'Transaction history',       textPrimary, isDark,
                  () => Navigator.push(context, MaterialPageRoute(builder: (_) => const OrderSummaryScreen()))),
              _divider(divColor),
              _navItem(Icons.description_outlined,        'Documents and statements',  textPrimary, isDark,
                  () => _showToast('Documents feature coming soon')),
              _divider(divColor),
              _navItem(Icons.lock_outline_rounded,        'Change password',           textPrimary, isDark,
                  () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()))),
            ]),

            const SizedBox(height: 20),

            // ── Connected Accounts ───────────────────────────────────────
            _sectionLabel('Connected accounts', sectionLabel),
            _menuCard(isDark, cardBg, divColor, [
              _navItem(Icons.account_balance_outlined,    'Swift Solutions',           textPrimary, isDark,
                  () => _showToast('Connected: Swift Solutions')),
            ]),

            const SizedBox(height: 20),

            // ── General ──────────────────────────────────────────────────
            _sectionLabel('General', sectionLabel),
            _menuCard(isDark, cardBg, divColor, [
              _switchItem(
                Icons.notifications_none_rounded, 'Notifications',
                _notificationsEnabled, textPrimary, isDark,
                (val) {
                  setState(() => _notificationsEnabled = val);
                  _savePref('notif_orders', val);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationScreen()));
                },
              ),
              _divider(divColor),
              // Dark mode toggle — uses app-level themeNotifier
              ValueListenableBuilder<ThemeMode>(
                valueListenable: themeNotifier,
                builder: (ctx, mode, _) {
                  final darkOn = mode == ThemeMode.dark;
                  return _switchItem(
                    Icons.dark_mode_outlined, 'Dark mode',
                    darkOn, textPrimary, isDark,
                    (_) => themeNotifier.toggleTheme(),
                  );
                },
              ),
              _divider(divColor),
              _navItem(Icons.language_rounded, 'Language', textPrimary, isDark, _showLanguagePicker,
                  trailing: Text(_selectedLanguage, style: TextStyle(color: textSub, fontSize: 13))),
            ]),

            const SizedBox(height: 20),

            // ── Help and Support ─────────────────────────────────────────
            _sectionLabel('Help and Support', sectionLabel),
            _menuCard(isDark, cardBg, divColor, [
              _navItem(Icons.help_outline_rounded,        'FAQ',                       textPrimary, isDark,
                  () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SupportScreen()))),
              _divider(divColor),
              _navItem(Icons.email_outlined,              'Contact customer service',  textPrimary, isDark,
                  () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SupportScreen()))),
              _divider(divColor),
              _navItem(Icons.edit_outlined,               'Give us feedback',          textPrimary, isDark,
                  () => _showToast('Thank you! Feedback form coming soon')),
            ]),

            const SizedBox(height: 20),

            // ── Legal ─────────────────────────────────────────────────────
            _sectionLabel('Legal', sectionLabel),
            _menuCard(isDark, cardBg, divColor, [
              _navItem(Icons.article_outlined,            'Terms & Conditions',        textPrimary, isDark,
                  () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TermsScreen(section: 'terms')))),
              _divider(divColor),
              _navItem(Icons.privacy_tip_outlined,        'Privacy policy',            textPrimary, isDark,
                  () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TermsScreen(section: 'privacy')))),
            ]),

            const SizedBox(height: 20),

            // ── Close the account ─────────────────────────────────────────
            _menuCard(isDark, cardBg, divColor, [
              _navItem(Icons.manage_accounts_outlined,    'Close the account',         textPrimary, isDark,
                  _showDeleteConfirmation),
            ]),

            const SizedBox(height: 12),

            // ── Log out ──────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onTap: _handleLogout,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.redAccent.withOpacity(isDark ? 0.15 : 0.12),
                      width: 1,
                    ),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.logout_rounded, color: Colors.redAccent, size: 20),
                      SizedBox(width: 14),
                      Text(
                        'Log out',
                        style: TextStyle(color: Colors.redAccent, fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ── Hero Header ──────────────────────────────────────────────────────────────
  Widget _buildHeroHeader(bool isDark, Color textPrimary, Color textSub) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 12, bottom: 32),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111111) : Colors.white,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.25 : 0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar with gold ring + camera overlay
          GestureDetector(
            onTap: _showImageSourcePicker,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [AppTheme.gold, AppTheme.darkGold],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.gold.withOpacity(0.35),
                    blurRadius: 18,
                    spreadRadius: 2,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(3),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(_avatarPath),
                    backgroundColor: isDark ? const Color(0xFF1C1C1E) : Colors.grey.shade200,
                  ),
                  if (_isUploadingImage)
                    Container(
                      width: 100,
                      height: 100,
                      decoration: const BoxDecoration(color: Colors.black45, shape: BoxShape.circle),
                      child: const Center(
                        child: CircularProgressIndicator(color: AppTheme.gold, strokeWidth: 2),
                      ),
                    ),
                  Positioned(
                    bottom: 2, right: 2,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(color: AppTheme.gold, shape: BoxShape.circle),
                      child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 14),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Full name
          _isLoading && _fullName.isEmpty
              ? const PulseSkeleton(width: 160, height: 20)
              : Text(
                  _fullName.isNotEmpty ? _fullName : 'Jane Doe',
                  style: TextStyle(
                    color: textPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.3,
                  ),
                ),
          const SizedBox(height: 6),

          // Phone
          Text(
            _phone,
            style: TextStyle(color: textSub, fontSize: 13),
          ),
          const SizedBox(height: 12),

          // Account type badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.gold.withOpacity(isDark ? 0.12 : 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.gold.withOpacity(0.3), width: 1),
            ),
            child: const Text(
              'Instant Personal',
              style: TextStyle(
                color: AppTheme.gold,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Section label ─────────────────────────────────────────────────────────────
  Widget _sectionLabel(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, top: 20, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          color: color,
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  // ── Card wrapper ──────────────────────────────────────────────────────────────
  Widget _menuCard(bool isDark, Color bg, Color divColor, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.04),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.18 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  // ── Nav row ───────────────────────────────────────────────────────────────────
  Widget _navItem(
    IconData icon,
    String title,
    Color textPrimary,
    bool isDark,
    VoidCallback onTap, {
    Widget? trailing,
  }) {
    final iconBg    = isDark ? Colors.white.withOpacity(0.07) : Colors.black.withOpacity(0.04);
    final iconColor = isDark ? Colors.white60 : Colors.black45;
    final chevron   = isDark ? Colors.white.withOpacity(0.2) : Colors.black.withOpacity(0.2);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: TextStyle(color: textPrimary, fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
            if (trailing != null) ...[trailing, const SizedBox(width: 6)],
            Icon(Icons.chevron_right_rounded, color: chevron, size: 20),
          ],
        ),
      ),
    );
  }

  // ── Switch row ────────────────────────────────────────────────────────────────
  Widget _switchItem(
    IconData icon,
    String title,
    bool value,
    Color textPrimary,
    bool isDark,
    ValueChanged<bool> onChanged,
  ) {
    final iconBg    = isDark ? Colors.white.withOpacity(0.07) : Colors.black.withOpacity(0.04);
    final iconColor = isDark ? Colors.white60 : Colors.black45;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: TextStyle(color: textPrimary, fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          Switch.adaptive(
            value: value,
            activeColor: AppTheme.gold,
            activeTrackColor: AppTheme.gold.withOpacity(0.35),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _divider(Color color) =>
      Divider(height: 1, thickness: 1, color: color, indent: 52, endIndent: 0);
}

// ── Pulse Skeleton Loader ─────────────────────────────────────────────────────

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
  late AnimationController _ctrl;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000))
      ..repeat(reverse: true);
    _opacity = Tween<double>(begin: 0.2, end: 0.6).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AnimatedBuilder(
      animation: _opacity,
      builder: (_, __) => Opacity(
        opacity: _opacity.value,
        child: Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: isDark ? Colors.white12 : Colors.black12,
            borderRadius: widget.borderRadius,
          ),
        ),
      ),
    );
  }
}