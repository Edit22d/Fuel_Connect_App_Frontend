import 'package:flutter/material.dart';
import '../auth/theme.dart';
import '../services/notification_service.dart';
import 'home_screen.dart';
import 'order_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  int _selectedTab = 0;
  int _selectedIndex = 2;

  List<AppNotification> get _filtered {
    final all = NotificationService().notifications.value;
    switch (_selectedTab) {
      case 1:
        return all.where((n) => n.type == NotifType.order).toList();
      case 2:
        return all.where((n) => n.type == NotifType.promo).toList();
      case 3:
        return all.where((n) => n.type == NotifType.security).toList();
      default:
        return all;
    }
  }

  List<AppNotification> get _recent =>
      _filtered.where((n) => n.time.isAfter(DateTime.now().subtract(const Duration(hours: 24)))).toList();

  List<AppNotification> get _older =>
      _filtered.where((n) => !n.time.isAfter(DateTime.now().subtract(const Duration(hours: 24)))).toList();

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

        return ValueListenableBuilder<List<AppNotification>>(
          valueListenable: NotificationService().notifications,
          builder: (_, notifs, __) {
            final unreadCount = notifs.where((n) => !n.isRead).length;

            return Scaffold(
              backgroundColor: bg,
              appBar: AppBar(
                backgroundColor: bg,
                elevation: 0,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios_new_rounded, color: textPrimary, size: 18),
                  onPressed: () => Navigator.pop(context),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Notifications', style: TextStyle(color: textPrimary, fontWeight: FontWeight.w700, fontSize: 17)),
                    if (unreadCount > 0)
                      Text('$unreadCount unread', style: const TextStyle(color: AppTheme.gold, fontSize: 11, fontWeight: FontWeight.w500)),
                  ],
                ),
                centerTitle: true,
                actions: [
                  IconButton(
                    icon: Icon(Icons.more_vert_rounded, color: textPrimary),
                    onPressed: () => _showMoreOptions(surface, textPrimary),
                  ),
                ],
              ),
              body: Column(
                children: [
                  // ── Tab bar ────────────────────────────────────────────
                  Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _tab('All', 0, notifs.where((n) => !n.isRead).length, textPrimary),
                        _tab('Orders', 1, notifs.where((n) => n.type == NotifType.order && !n.isRead).length, textPrimary),
                        _tab('Offers', 2, notifs.where((n) => n.type == NotifType.promo && !n.isRead).length, textPrimary),
                        _tab('Security', 3, notifs.where((n) => n.type == NotifType.security && !n.isRead).length, textPrimary),
                      ],
                    ),
                  ),

                  const SizedBox(height: 4),

                  Expanded(
                    child: _filtered.isEmpty
                        ? _emptyState(textSecondary)
                        : ListView(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            children: [
                              if (_recent.isNotEmpty) ...[
                                _sectionLabel('RECENT', textSecondary),
                                const SizedBox(height: 10),
                                ..._recent.map((n) => _notifCard(n, surface, textPrimary, textSecondary, divider)),
                                const SizedBox(height: 16),
                              ],
                              if (_older.isNotEmpty) ...[
                                _sectionLabel('EARLIER', textSecondary),
                                const SizedBox(height: 10),
                                ..._older.map((n) => _notifCard(n, surface, textPrimary, textSecondary, divider)),
                              ],
                            ],
                          ),
                  ),
                ],
              ),
              bottomNavigationBar: Container(
                decoration: BoxDecoration(
                  color: surface,
                  border: Border(top: BorderSide(color: divider, width: 0.5)),
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
                    BottomNavigationBarItem(icon: Icon(Icons.notifications_outlined), activeIcon: Icon(Icons.notifications_rounded), label: 'Alerts'),
                    BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded), activeIcon: Icon(Icons.person_rounded), label: 'Profile'),
                  ],
                  onTap: (index) {
                    setState(() => _selectedIndex = index);
                    switch (index) {
                      case 0:
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const HomeScreen()), (r) => false);
                        break;
                      case 1:
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const OrderScreen()));
                        break;
                      case 2:
                        break;
                      case 3:
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
                        break;
                    }
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _tab(String label, int index, int badge, Color textPrimary) {
    final selected = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 8, top: 6, bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? AppTheme.gold : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? AppTheme.gold : Colors.grey.withOpacity(0.3), width: 1),
        ),
        child: Row(
          children: [
            Text(label, style: TextStyle(
              color: selected ? Colors.black : textPrimary,
              fontSize: 13, fontWeight: FontWeight.w600,
            )),
            if (badge > 0) ...[
              const SizedBox(width: 6),
              Container(
                width: 18, height: 18,
                decoration: BoxDecoration(
                  color: selected ? Colors.black.withOpacity(0.2) : Colors.redAccent,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text('$badge', style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String label, Color textSecondary) {
    return Text(label, style: TextStyle(color: textSecondary, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.2));
  }

  Widget _notifCard(AppNotification notif, Color surface, Color textPrimary, Color textSecondary, Color divider) {
    return Dismissible(
      key: Key(notif.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        NotificationService().removeNotification(notif.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text('Notification removed'), backgroundColor: AppTheme.gold, duration: const Duration(seconds: 2),
            action: SnackBarAction(label: 'Undo', textColor: Colors.black, onPressed: () {}),
          ),
        );
      },
      background: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(14)),
        alignment: Alignment.centerRight,
        child: const Icon(Icons.delete_sweep_rounded, color: Colors.white, size: 26),
      ),
      child: GestureDetector(
        onTap: () {
          NotificationService().markAsRead(notif.id);
          _showNotifDetail(notif, surface, textPrimary, textSecondary);
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: notif.isRead ? divider : notif.color.withOpacity(0.4),
              width: notif.isRead ? 0.5 : 1.5,
            ),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  color: notif.color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(notif.icon, color: notif.color, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(notif.title,
                            style: TextStyle(color: textPrimary, fontWeight: notif.isRead ? FontWeight.w500 : FontWeight.w700, fontSize: 13),
                            maxLines: 1, overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(notif.timeAgo, style: TextStyle(color: textSecondary, fontSize: 10)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(notif.body,
                      style: TextStyle(color: textSecondary, fontSize: 12, height: 1.4),
                      maxLines: 2, overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (!notif.isRead) ...[
                const SizedBox(width: 8),
                Container(
                  width: 8, height: 8,
                  decoration: BoxDecoration(color: notif.color, shape: BoxShape.circle),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _emptyState(Color textSecondary) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.gold.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.notifications_off_rounded, color: AppTheme.gold, size: 48),
          ),
          const SizedBox(height: 16),
          const Text('All Caught Up!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 8),
          Text('No notifications in this category.', style: TextStyle(color: textSecondary, fontSize: 13)),
        ],
      ),
    );
  }

  void _showNotifDetail(AppNotification notif, Color surface, Color textPrimary, Color textSecondary) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: notif.color.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(notif.icon, color: notif.color, size: 32),
            ),
            const SizedBox(height: 16),
            Text(notif.title, style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 17), textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(notif.timeAgo, style: TextStyle(color: textSecondary, fontSize: 12)),
            const SizedBox(height: 16),
            Container(height: 1, color: AppTheme.gold.withOpacity(0.2)),
            const SizedBox(height: 16),
            Text(notif.body, style: TextStyle(color: textSecondary, fontSize: 14, height: 1.6), textAlign: TextAlign.center),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.gold, foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Got it', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showMoreOptions(Color surface, Color textPrimary) {
    showModalBottomSheet(
      context: context,
      backgroundColor: surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Container(width: 36, height: 4, margin: const EdgeInsets.only(bottom: 16), decoration: BoxDecoration(color: Colors.grey.withOpacity(0.3), borderRadius: BorderRadius.circular(2))),
          _menuOption('Mark all as read', Icons.done_all_rounded, AppTheme.gold, () {
            NotificationService().markAllAsRead();
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('All notifications marked as read'), backgroundColor: AppTheme.gold));
          }),
          _menuOption('Clear all notifications', Icons.delete_sweep_rounded, Colors.redAccent, () {
            NotificationService().clearAll();
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('All notifications cleared'), backgroundColor: Colors.redAccent));
          }),
          _menuOption('Notification settings', Icons.tune_rounded, AppTheme.gold, () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
          }),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _menuOption(String title, IconData icon, Color color, VoidCallback onTap) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(title, style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 14)),
      onTap: () { Navigator.pop(context); onTap(); },
    );
  }
}