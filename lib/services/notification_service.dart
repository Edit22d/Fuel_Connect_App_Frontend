import 'dart:async';
import 'package:flutter/material.dart';

// ── Notification Types ──────────────────────────────────────────────────────
enum NotifType { order, security, promo, system }

// ── App Notification Model ──────────────────────────────────────────────────
class AppNotification {
  final String id;
  final String title;
  final String body;
  final NotifType type;
  final DateTime time;
  bool isRead;

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.time,
    this.isRead = false,
  });

  IconData get icon {
    switch (type) {
      case NotifType.order:
        return Icons.local_shipping_rounded;
      case NotifType.security:
        return Icons.security_rounded;
      case NotifType.promo:
        return Icons.local_offer_rounded;
      case NotifType.system:
        return Icons.info_rounded;
    }
  }

  Color get color {
    switch (type) {
      case NotifType.order:
        return const Color(0xFFC4963D);
      case NotifType.security:
        return Colors.redAccent;
      case NotifType.promo:
        return Colors.green;
      case NotifType.system:
        return Colors.blueAccent;
    }
  }

  String get timeAgo {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}

// ── Notification Service (Singleton) ───────────────────────────────────────
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal() {
    _loadDemoNotifications();
  }

  final ValueNotifier<List<AppNotification>> notifications =
      ValueNotifier<List<AppNotification>>([]);

  // Queue of popup notifications to show
  final _popupController = StreamController<AppNotification>.broadcast();
  Stream<AppNotification> get popupStream => _popupController.stream;

  int get unreadCount => notifications.value.where((n) => !n.isRead).length;

  void _loadDemoNotifications() {
    final now = DateTime.now();
    notifications.value = [
      AppNotification(
        id: 'n1',
        title: 'Order #FC-2024-0891 Assigned',
        body: 'Driver Emmanuel Okello has accepted your fuel delivery order. ETA: 18 minutes.',
        type: NotifType.order,
        time: now.subtract(const Duration(minutes: 2)),
        isRead: false,
      ),
      AppNotification(
        id: 'n2',
        title: 'Security Alert',
        body: 'A new login was detected from Chrome on Windows. Was this you? Tap to review.',
        type: NotifType.security,
        time: now.subtract(const Duration(hours: 1)),
        isRead: false,
      ),
      AppNotification(
        id: 'n3',
        title: 'Weekend Fuel Promo 🎉',
        body: 'Get 5% cashback on all petrol deliveries this weekend. Use code: FUEL5.',
        type: NotifType.promo,
        time: now.subtract(const Duration(hours: 3)),
        isRead: false,
      ),
      AppNotification(
        id: 'n4',
        title: 'Order #FC-2024-0876 Delivered',
        body: '20L of Petrol delivered successfully. Thank you for using Fuel Connect!',
        type: NotifType.order,
        time: now.subtract(const Duration(days: 1)),
        isRead: true,
      ),
      AppNotification(
        id: 'n5',
        title: 'Fuel Price Update',
        body: 'Petrol prices have been updated in your area. Current price: UGX 4,850/L.',
        type: NotifType.system,
        time: now.subtract(const Duration(days: 1)),
        isRead: true,
      ),
      AppNotification(
        id: 'n6',
        title: 'Payment Confirmed',
        body: 'UGX 97,000 payment received for Order #FC-2024-0876. Receipt sent to your email.',
        type: NotifType.order,
        time: now.subtract(const Duration(days: 2)),
        isRead: true,
      ),
    ];
  }

  /// Adds a notification and shows popup banner
  void showNotification({
    required String title,
    required String body,
    required NotifType type,
  }) {
    final notif = AppNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      body: body,
      type: type,
      time: DateTime.now(),
    );
    final updated = [notif, ...notifications.value];
    notifications.value = List.from(updated);
    _popupController.add(notif);
  }

  void markAsRead(String id) {
    final updated = notifications.value.map((n) {
      if (n.id == id) n.isRead = true;
      return n;
    }).toList();
    notifications.value = List.from(updated);
  }

  void markAllAsRead() {
    for (var n in notifications.value) {
      n.isRead = true;
    }
    notifications.value = List.from(notifications.value);
  }

  void removeNotification(String id) {
    notifications.value =
        notifications.value.where((n) => n.id != id).toList();
  }

  void clearAll() {
    notifications.value = [];
  }

  void triggerDemoPopup() {
    Future.delayed(const Duration(seconds: 3), () {
      showNotification(
        title: 'Order Being Prepared 🛵',
        body: 'Your fuel delivery is being prepared. Driver will depart soon.',
        type: NotifType.order,
      );
    });
  }

  void dispose() {
    _popupController.close();
    notifications.dispose();
  }
}

// ── In-App Popup Banner Widget ──────────────────────────────────────────────
class NotificationPopupOverlay extends StatefulWidget {
  final Widget child;
  const NotificationPopupOverlay({super.key, required this.child});

  @override
  State<NotificationPopupOverlay> createState() =>
      _NotificationPopupOverlayState();
}

class _NotificationPopupOverlayState extends State<NotificationPopupOverlay>
    with SingleTickerProviderStateMixin {
  StreamSubscription<AppNotification>? _sub;
  AppNotification? _currentPopup;
  late AnimationController _animCtrl;
  late Animation<Offset> _slideAnim;
  Timer? _dismissTimer;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, -1.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOutBack));

    _sub = NotificationService().popupStream.listen(_showPopup);
  }

  void _showPopup(AppNotification notif) {
    _dismissTimer?.cancel();
    setState(() => _currentPopup = notif);
    _animCtrl.forward(from: 0);
    _dismissTimer = Timer(const Duration(seconds: 4), _dismiss);
  }

  void _dismiss() {
    _animCtrl.reverse().then((_) {
      if (mounted) setState(() => _currentPopup = null);
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    _animCtrl.dispose();
    _dismissTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_currentPopup != null)
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 16,
            right: 16,
            child: SlideTransition(
              position: _slideAnim,
              child: GestureDetector(
                onTap: _dismiss,
                onVerticalDragUpdate: (d) {
                  if (d.primaryDelta! < -5) _dismiss();
                },
                child: _PopupBanner(notif: _currentPopup!),
              ),
            ),
          ),
      ],
    );
  }
}

class _PopupBanner extends StatelessWidget {
  final AppNotification notif;
  const _PopupBanner({required this.notif});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      elevation: 16,
      borderRadius: BorderRadius.circular(16),
      shadowColor: Colors.black54,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: notif.color.withOpacity(0.4),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: notif.color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(notif.icon, color: notif.color, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    notif.title,
                    style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF111111),
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    notif.body,
                    style: TextStyle(
                      color: isDark ? Colors.white60 : Colors.black54,
                      fontSize: 11.5,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              children: [
                Text(
                  'now',
                  style: TextStyle(
                    color: isDark ? Colors.white38 : Colors.black38,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 8),
                Icon(Icons.close, size: 14,
                    color: isDark ? Colors.white38 : Colors.black38),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Notification Badge ─────────────────────────────────────────────────────
class NotificationBadge extends StatelessWidget {
  final Widget child;
  const NotificationBadge({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<AppNotification>>(
      valueListenable: NotificationService().notifications,
      builder: (_, notifs, __) {
        final count = notifs.where((n) => !n.isRead).length;
        return Stack(
          clipBehavior: Clip.none,
          children: [
            child,
            if (count > 0)
              Positioned(
                top: -4,
                right: -4,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: const BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      count > 9 ? '9+' : count.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
