import 'package:flutter/material.dart';
import 'home_screen.dart';
import '/screens/order_screen.dart';
import 'profile_screen.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  int _selectedTab = 0;
  int _selectedIndex = 2;

  final List<_NotifItem> _allNotifs = [
    _NotifItem(
      icon: Icons.local_shipping,
      title: 'Order #6829 Shipped',
      body: 'Your golden edition watch has been dispatched and is on its way to your address.',
      time: '2m ago',
      isRead: false,
      category: 'orders',
    ),
    _NotifItem(
      icon: Icons.local_offer,
      title: 'Exclusive Weekend Offer',
      body: 'Get 20% extra credit on all luxury accessories this weekend only. Use code GOLDEN.',
      time: '1h ago',
      isRead: false,
      category: 'offers',
    ),
    _NotifItem(
      icon: Icons.security,
      title: 'Security Alert',
      body: 'A new login was detected from a Chrome browser on Windows 11. Was this you?',
      time: '3h ago',
      isRead: false,
      category: 'all',
    ),
    _NotifItem(
      icon: Icons.check_circle,
      title: 'Order #6812 Delivered',
      body: 'Your package was delivered to the reception desk. Enjoy your purchase!',
      time: '1d ago',
      isRead: true,
      category: 'orders',
    ),
    _NotifItem(
      icon: Icons.account_balance_wallet,
      title: 'Wallet Top-up Successful',
      body: 'Successfully added \$500.00 to your wallet. Your new balance is \$1,240.50.',
      time: '1d ago',
      isRead: true,
      category: 'all',
    ),
  ];

  List<_NotifItem> get _filteredNotifs {
    if (_selectedTab == 0) return _allNotifs;
    if (_selectedTab == 1) {
      return _allNotifs.where((n) => n.category == 'orders').toList();
    }
    if (_selectedTab == 2) {
      return _allNotifs.where((n) => n.category == 'offers').toList();
    }
    return _allNotifs;
  }

  List<_NotifItem> get _recentNotifs {
    return _filteredNotifs.where((n) => n.time.contains('m') || n.time.contains('h')).toList();
  }

  List<_NotifItem> get _yesterdayNotifs {
    return _filteredNotifs.where((n) => n.time.contains('d')).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D0D),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () => _showMoreOptions(),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                _buildTab('All', 0),
                const SizedBox(width: 8),
                _buildTab('Orders', 1),
                const SizedBox(width: 8),
                _buildTab('Offers', 2),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                if (_recentNotifs.isNotEmpty) ...[
                  _sectionLabel('RECENT'),
                  const SizedBox(height: 12),
                  ..._recentNotifs.map((n) => _buildNotifCard(n)),
                  const SizedBox(height: 20),
                ],
                if (_yesterdayNotifs.isNotEmpty) ...[
                  _sectionLabel('YESTERDAY'),
                  const SizedBox(height: 12),
                  ..._yesterdayNotifs.map((n) => _buildNotifCard(n)),
                  const SizedBox(height: 20),
                ],
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF0D0D0D),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFC4963D),
        unselectedItemColor: Colors.white54,
        selectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontSize: 10),
        currentIndex: _selectedIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            activeIcon: Icon(Icons.receipt_long_rounded),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            activeIcon: Icon(Icons.notifications_rounded),
            label: 'Alerts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            activeIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          _navigateToScreen(index);
        },
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    final bool selected = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFC4963D) : const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.black : Colors.white70,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        color: Color(0xFFC4963D),
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildNotifCard(_NotifItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: !item.isRead
            ? Border.all(color: const Color(0xFFC4963D).withOpacity(0.3))
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFF252525),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              item.icon,
              color: const Color(0xFFC4963D),
              size: 22,
            ),
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
                      child: Text(
                        item.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      item.time,
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item.body,
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 12,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _menuOption('Mark all as read', Icons.done_all),
            _menuOption('Notification settings', Icons.settings),
            _menuOption('Clear all', Icons.delete_outline),
          ],
        ),
      ),
    );
  }

  Widget _menuOption(String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFFC4963D)),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 14),
      ),
      onTap: () {
        Navigator.pop(context);
        if (title == 'Mark all as read') {
          setState(() {
            for (var notif in _allNotifs) {
              notif.isRead = true;
            }
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('All notifications marked as read'),
              backgroundColor: Color(0xFFC4963D),
            ),
          );
        } else if (title == 'Clear all') {
          setState(() {
            _allNotifs.clear();
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('All notifications cleared'),
              backgroundColor: Color(0xFFC4963D),
            ),
          );
        }
      },
    );
  }

  void _navigateToScreen(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OrderScreen()),
        );
        break;
      case 2:
        // Already on notifications
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        );
        break;
    }
  }
}

class _NotifItem {
  final IconData icon;
  final String title;
  final String body;
  final String time;
  bool isRead;
  final String category;

  _NotifItem({
    required this.icon,
    required this.title,
    required this.body,
    required this.time,
    required this.isRead,
    required this.category,
  });
}