import 'package:flutter/material.dart';
import '/payment/payment_screen.dart';
import '/screens/station_screen.dart';

class StationDetailScreen2 extends StatelessWidget {
  const StationDetailScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Column(
        children: [
          // ── Header image with overlay ──
          Stack(
            children: [
              SizedBox(
                height: 200,
                width: double.infinity,
                child: Image.asset(
                  'assets/images/total_station.png',
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                height: 200,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Color(0xEE000000)],
                  ),
                ),
              ),
              // Top bar
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(8)),
                          child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                        ),
                      ),
                      // KINETIC badge top-center
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD4A017),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'KINETIC',
                          style: TextStyle(color: Colors.black, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        child: const Icon(Icons.more_vert, color: Colors.white, size: 22),
                      ),
                    ],
                  ),
                ),
              ),
              // Station name bottom-left
              Positioned(
                bottom: 16,
                left: 16,
                child: const Text(
                  'TotalEnergies - Paris\nCentral',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    height: 1.2,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              // Location bottom-right area
              Positioned(
                bottom: 16,
                right: 16,
                child: Row(
                  children: [
                    const Icon(Icons.location_on, color: Color(0xFFD4A017), size: 12),
                    const SizedBox(width: 3),
                    Text(
                      'Kyaliwajjala District',
                      style: TextStyle(color: Colors.grey[400], fontSize: 10),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // ── Content ──
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Fuel Volume + Total Amount row
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('FUEL VOLUME', style: TextStyle(color: Colors.grey[500], fontSize: 10, letterSpacing: 0.5)),
                            const SizedBox(height: 2),
                            const Text(
                              '45.50 Ltrs',
                              style: TextStyle(color: Color(0xFFD4A017), fontSize: 22, fontWeight: FontWeight.w800),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('TOTAL AMOUNT', style: TextStyle(color: Colors.grey[500], fontSize: 10, letterSpacing: 0.5)),
                          const SizedBox(height: 2),
                          const Text(
                            '\$78.25',
                            style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Payment method row (Visa + Change)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFF2A2A2A)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 32,
                              height: 22,
                              decoration: BoxDecoration(
                                color: const Color(0xFF1A1A6E),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Center(
                                child: Text('VISA', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text('Visa Card', style: TextStyle(color: Colors.grey[300], fontSize: 13, fontWeight: FontWeight.w500)),
                          ],
                        ),
                        TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            backgroundColor: const Color(0xFF2A2A2A),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          ),
                          child: const Text('Change', style: TextStyle(color: Color(0xFFD4A017), fontSize: 11, fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Select Fuel
                  const Text('Select Fuel', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),

                  _FuelOrderRow(label: 'Diesel', price: '₦ 865.00/litre'),
                  const SizedBox(height: 8),
                  _FuelOrderRow(label: 'Petrol', price: '₦ 617.00/litre'),
                  const SizedBox(height: 8),
                  _FuelOrderRow(label: 'Kerosene', price: '₦ 730.00/litre'),
                  const SizedBox(height: 20),

                  // Amenities
                  Text('AVAILABLE AMENITIES', style: TextStyle(color: Colors.grey[500], fontSize: 10, letterSpacing: 1)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _AmenityIcon(icon: Icons.atm, label: 'ATM'),
                      _AmenityIcon(icon: Icons.restaurant, label: 'Canteen'),
                      _AmenityIcon(icon: Icons.local_car_wash, label: 'Car Wash'),
                      _AmenityIcon(icon: Icons.wifi, label: 'WiFi'),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // CTA
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD4A017),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const PaymentScreen()),
                      ),
                      child: const Text(
                        'CONFIRM & START FUELING  ▶',
                        style: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w800, letterSpacing: 0.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          _BottomNav(activeIndex: 1),
        ],
      ),
    );
  }
}

class _FuelOrderRow extends StatelessWidget {
  final String label;
  final String price;
  const _FuelOrderRow({required this.label, required this.price});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
              Text(price, style: TextStyle(color: Colors.grey[500], fontSize: 11)),
            ],
          ),
          ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PaymentScreen()),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD4A017),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            ),
            child: const Text('ORDER NOW', style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
  }
}

class _AmenityIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  const _AmenityIcon({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF2A2A2A)),
          ),
          child: Icon(icon, color: const Color(0xFFD4A017), size: 24),
        ),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10)),
      ],
    );
  }
}

class _BottomNav extends StatelessWidget {
  final int activeIndex;
  const _BottomNav({required this.activeIndex});

  @override
  Widget build(BuildContext context) {
    final items = [
      {'icon': Icons.home_outlined, 'label': 'Home'},
      {'icon': Icons.local_gas_station_outlined, 'label': 'Stations'},
      {'icon': Icons.receipt_long_outlined, 'label': 'Orders'},
      {'icon': Icons.person_outline, 'label': 'Profile'},
    ];
    return Container(
      height: 68,
      decoration: const BoxDecoration(
        color: Color(0xFF141414),
        border: Border(top: BorderSide(color: Color(0xFF2A2A2A))),
      ),
      child: Row(
        children: List.generate(items.length, (i) {
          final active = i == activeIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                if (i == 1) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const StationScreen()),
                    (route) => false,
                  );
                }
              },
              behavior: HitTestBehavior.opaque,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(items[i]['icon'] as IconData,
                      color: active ? const Color(0xFFD4A017) : const Color(0xFF555555), size: 22),
                  const SizedBox(height: 4),
                  Text(items[i]['label'] as String,
                      style: TextStyle(
                        color: active ? const Color(0xFFD4A017) : const Color(0xFF555555),
                        fontSize: 10,
                        fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                      )),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
