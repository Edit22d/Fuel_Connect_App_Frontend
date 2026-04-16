import 'package:flutter/material.dart';
import '/payment/payment_screen.dart';
import '/screens/station_screen.dart';

class StationDetailScreen1 extends StatelessWidget {
  const StationDetailScreen1({super.key});

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
                  'assets/images/stabex_station.png',
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                height: 200,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Color(0xCC000000)],
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
                          decoration: BoxDecoration(
                            color: Colors.black45,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                        ),
                      ),
                      const Text(
                        'Station Details',
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(8)),
                        child: const Icon(Icons.share_outlined, color: Colors.white, size: 20),
                      ),
                    ],
                  ),
                ),
              ),
              // Station name badge at bottom of image
              Positioned(
                bottom: 16,
                left: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFC8A84B),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'STABEX',
                        style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'KINETIC',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
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
                  // Address + rating
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Color(0xFFC8A84B), size: 14),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '10 Innovation Drive, Silicon Valley, CA',
                          style: TextStyle(color: Colors.grey[400], fontSize: 12),
                        ),
                      ),
                      const Icon(Icons.star, color: Color(0xFFC8A84B), size: 14),
                      const SizedBox(width: 2),
                      Text('4.8', style: TextStyle(color: Colors.grey[300], fontSize: 12)),
                      const SizedBox(width: 8),
                      Text('1,250 miles', style: TextStyle(color: Colors.grey[500], fontSize: 11)),
                    ],
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
                  const SizedBox(height: 24),

                  // Amenities
                  const Text('Amenities', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _AmenityIcon(icon: Icons.atm, label: 'ATM'),
                      _AmenityIcon(icon: Icons.restaurant, label: 'Canteen'),
                      _AmenityIcon(icon: Icons.local_car_wash, label: 'Car Wash'),
                      _AmenityIcon(icon: Icons.wifi, label: 'Wifi'),
                      _AmenityIcon(icon: Icons.wc, label: 'WC'),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // CTA
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFC8A84B),
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

// ── Fuel row with ORDER NOW ──────────────────────────────────────────────────
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
              backgroundColor: const Color(0xFFC8A84B),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            ),
            child: const Text(
              'ORDER NOW',
              style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.w800),
            ),
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
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFF2A2A2A)),
          ),
          child: Icon(icon, color: const Color(0xFFC8A84B), size: 22),
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
                      color: active ? const Color(0xFFC8A84B) : const Color(0xFF555555), size: 22),
                  const SizedBox(height: 4),
                  Text(items[i]['label'] as String,
                      style: TextStyle(
                        color: active ? const Color(0xFFC8A84B) : const Color(0xFF555555),
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
