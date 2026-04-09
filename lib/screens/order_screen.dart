import 'package:flutter/material.dart';


class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  int _selectedTab = 0;

  final List<_OrderItem> _orders = const [
    _OrderItem(
      name: 'Shell Super Petrol',
      date: 'Daily, Mar 20 – Apr 14, 2024',
      quantity: '48.5 Liters',
      price: 'UGX\n\$64.20',
      status: 'DELIVERED',
      statusColor: Color(0xFF00C853),
    ),
    _OrderItem(
      name: 'TotalEnergies Diesel',
      date: 'Daily, Mar 20 – Mar 14, 2024',
      quantity: '92.5 Liters',
      price: 'UGX\n\$95.20',
      status: 'PENDING',
      statusColor: Color(0xFFFFAA00),
      showTrackOrder: true,
    ),
    _OrderItem(
      name: 'Rubis Kerosene',
      date: 'Daily, Mar 20 – Apr 14, 2024',
      quantity: '15.6 Liters',
      price: 'UGX\n\$10.8',
      status: 'DELIVERED',
      statusColor: Color(0xFF00C853),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D0D),
        elevation: 0,
        title: const Text(
          'ORDER HISTORY',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
            letterSpacing: 1.2,
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
                _buildTab('All Orders', 0),
                const SizedBox(width: 8),
                _buildTab('Ongoing', 1),
                const SizedBox(width: 8),
                _buildTab('Pending', 2),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _orders.length,
              itemBuilder: (context, index) {
                return _buildOrderCard(_orders[index]);
              },
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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
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

  Widget _buildOrderCard(_OrderItem order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFF252525),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.local_gas_station,
                    color: Color(0xFFFFAA00), size: 22),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      order.date,
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: order.statusColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  order.status,
                  style: TextStyle(
                    color: order.statusColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('QUANTITY',
                      style: TextStyle(color: Colors.white38, fontSize: 10)),
                  const SizedBox(height: 2),
                  Text(order.quantity,
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 12)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('TOTAL PRICE',
                      style: TextStyle(color: Colors.white38, fontSize: 10)),
                  const SizedBox(height: 2),
                  Text(
                    order.price,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      color: Color(0xFFFFAA00),
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (order.showTrackOrder) ...[
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFFFAA00)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
                child: const Text(
                  'TRACK ORDER',
                  style: TextStyle(
                    color: Color(0xFFFFAA00),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _OrderItem {
  final String name;
  final String date;
  final String quantity;
  final String price;
  final String status;
  final Color statusColor;
  final bool showTrackOrder;

  const _OrderItem({
    required this.name,
    required this.date,
    required this.quantity,
    required this.price,
    required this.status,
    required this.statusColor,
    this.showTrackOrder = false,
  });
}
