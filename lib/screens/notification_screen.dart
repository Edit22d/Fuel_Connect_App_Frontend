import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  int _selectedTab = 0; 
  final List<_NotifItem> _recentNotifs = const [
    _NotifItem(
      icon: Icons.local_shipping_outlined,
      title: 'Order #4520 Shipped',
      body:
          'Your order #4520 has been shipped and is on its way to your delivery address.',
      time: '2 min ago',
      isRead: false,
      section: 'RECENT',
    ),
    _NotifItem(
      icon: Icons.local_offer_outlined,
      title: 'Exclusive Weekend Offer',
      body:
          'Get 20% on any product all every accesses this weekend only. Expires',
      time: '1 hr ago',
      isRead: false,
      section: 'RECENT',
    ),
    _NotifItem(
      icon: Icons.security_outlined,
      title: 'Security Alert',
      body:
          'Your account was accessed from a new device in Kisumu. If this was not you, please',
      time: '3 hrs ago',
      isRead: false,
      section: 'RECENT',
    ),
  ];

  final List<_NotifItem> _yesterdayNotifs = const [
    _NotifItem(
      icon: Icons.receipt_long_outlined,
      title: 'Order #4519 Delivered',
      body:
          'Your package #4519 has been delivered to Banana tree House, Kampala. You can now',
      time: 'Yesterday',
      isRead: true,
      section: 'YESTERDAY',
    ),
    _NotifItem(
      icon: Icons.account_balance_wallet_outlined,
      title: 'Wallet Top-up Successful',
      body: 'Successfully added \$200.00 to your wallet. New balance: \$1,456.00',
      time: 'Yesterday',
      isRead: true,
      section: 'YESTERDAY',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D0D),
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _buildTab('Recent', 0),
                const SizedBox(width: 8),
                _buildTab('Offers', 1),
              ],
            ),
          ),
          const SizedBox(height: 4),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
            
                _sectionLabel('RECENT'),
                const SizedBox(height: 8),
                ..._recentNotifs.map((n) => _buildNotifCard(n)),

                const SizedBox(height: 16),

               
                _sectionLabel('YESTERDAY'),
                const SizedBox(height: 8),
                ..._yesterdayNotifs.map((n) => _buildNotifCard(n)),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    final bool selected = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFFFAA00) : const Color(0xFF1E1E1E),
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
        color: Colors.white38,
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.1,
      ),
    );
  }

  Widget _buildNotifCard(_NotifItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: item.isRead
            ? null
            : Border.all(color: const Color(0xFFFFAA00).withOpacity(0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF252525),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(item.icon,
                color: const Color(0xFFFFAA00), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    Text(
                      item.time,
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item.body,
                  style: const TextStyle(
                    color: Colors.white54,
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
}

class _NotifItem {
  final IconData icon;
  final String title;
  final String body;
  final String time;
  final bool isRead;
  final String section;

  const _NotifItem({
    required this.icon,
    required this.title,
    required this.body,
    required this.time,
    required this.isRead,
    required this.section,
  });
}
