import 'package:flutter/material.dart';
import 'tracking_order_screen.dart';
import '/screens/fuel_type_screen.dart';
import 'package:fuel_app/auth/theme.dart';
import '../services/order_service.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  int _selectedTab = 0;
  int _selectedIndex = 2; // 2 is the 'Orders' tab index in the bottom nav

  final _orderService = OrderService();
  bool _isLoading = true;
  List<_OrderItem> _orders = [];

  List<_OrderItem> get _filteredOrders {
    switch (_selectedTab) {
      case 1:
        return _orders.where((order) => order.status == 'ONGOING').toList();
      case 2:
        return _orders.where((order) => order.status == 'PENDING').toList();
      case 3:
        return _orders.where((order) => order.status == 'DELIVERED').toList();
      default:
        return _orders;
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    setState(() => _isLoading = true);
    final models = await _orderService.getOrders();
    setState(() {
      _orders = models.map((m) {
        Color sColor = const Color(0xFFC4963D); // PENDING
        if (m.status == 'DELIVERED') sColor = const Color(0xFF00C853);
        if (m.status == 'CANCELLED') sColor = Colors.red;
        if (m.status == 'ONGOING') sColor = Colors.blue;

        return _OrderItem(
          name: '${m.stationName} ${m.fuelType}',
          date: m.createdAt.isNotEmpty ? m.createdAt.split('T').first : 'Recent',
          quantity: '${m.quantity} ${m.quantityUnit}',
          price: '${m.currency}\n${m.totalPrice}',
          status: m.status,
          statusColor: sColor,
          showTrackOrder: m.status == 'ONGOING' || m.status == 'PENDING',
          showCancel: m.status == 'PENDING',
          showOrderAgain: m.status == 'DELIVERED' || m.status == 'CANCELLED',
        );
      }).toList();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
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
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {},
          ),
          ThemeToggleButton(),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildTab('All Orders', 0),
                const SizedBox(width: 8),
                _buildTab('Ongoing', 1),
                const SizedBox(width: 8),
                _buildTab('Pending', 2),
                const SizedBox(width: 8),
                _buildTab('Delivered', 3),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _isLoading 
              ? const Center(child: CircularProgressIndicator(color: Color(0xFFC4963D)))
              : _filteredOrders.isEmpty
                  ? const Center(child: Text("No orders found.", style: TextStyle(color: Colors.white54)))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _filteredOrders.length,
                      itemBuilder: (context, index) {
                        return _buildOrderCard(_filteredOrders[index]);
                      },
                    ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFF0D0D0D),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFFC4963D),
      unselectedItemColor: Colors.white54,
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_outlined), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.people_outline), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ''),
      ],
    );
  }

  Widget _buildTab(String label, int index) {
    final bool selected = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFC4963D) : const Color(0xFF1E1E1E),
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
                    color: Color(0xFFC4963D), size: 22),
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
                      color: Color(0xFFC4963D),
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Conditional Buttons based on Order Status
          if (order.showTrackOrder || order.showCancel || order.showOrderAgain) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                // Track Order Button (Filled Yellow)
                if (order.showTrackOrder)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TrackOrderScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFC4963D),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        elevation: 0,
                      ),
                      child: const Text(
                        'TRACK ORDER',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                
                // Spacer if both buttons exist
                if (order.showTrackOrder && order.showCancel) const SizedBox(width: 10),

                // Cancel Button (Text)
                if (order.showCancel)
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        // Handle Cancel Action
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                // Order Again Button (Outlined)
                if (order.showOrderAgain)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                         // Handle Order Again Action (e.g., go to fuel type)
                         Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const FuelTypeScreen(),
                            ),
                          );
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFC4963D)),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      child: const Text(
                        'Order Again',
                        style: TextStyle(
                          color: Color(0xFFC4963D),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
              ],
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
  final bool showCancel;
  final bool showOrderAgain;

  const _OrderItem({
    required this.name,
    required this.date,
    required this.quantity,
    required this.price,
    required this.status,
    required this.statusColor,
    this.showTrackOrder = false,
    this.showCancel = false,
    this.showOrderAgain = false,
  });
}