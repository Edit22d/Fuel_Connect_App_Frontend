import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '/screens/home_screen.dart';
import '/screens/order_screen.dart';
import '/screens/profile_screen.dart';
import '/screens/support_screen.dart';
import '/screens/station_detail_screen1.dart';
import '/screens/station_detail_screen2.dart';
import '/screens/station_detail_screen3.dart';
import '/screens/station_detail_screen4.dart';



class StationScreen extends StatefulWidget {
  const StationScreen({super.key});

  @override
  State<StationScreen> createState() => _StationScreenState();
}

class _StationScreenState extends State<StationScreen> {
  GoogleMapController? _mapController;
  int _currentIndex = 1;

  final List<_StationData> _stations = const [
    _StationData(
      name: 'Stabex - Waiyaki Way',
      distance: '0.8 km',
      price: 'KSh 1.82/L',
      rating: '4.9',
      imageName: 'stabex',
      tag: 'Open Now',
    ),
    _StationData(
      name: 'Rubis - Limuru Rd',
      distance: '1.2 km',
      price: 'KSh 1.82/L',
      rating: '4.8',
      imageName: 'Rubis',
      tag: 'Open Now',
    ),
    _StationData(
      name: 'Shell - Ntanda Rd',
      distance: '0.6 km',
      price: 'KSh 1.82/L',
      rating: '4.6',
      imageName: 'shell',
      tag: 'Open Now',
    ),
        _StationData(
      name: 'TotalEnergies - kyambando Rd',
      distance: '0.6 km',
      price: 'KSh 1.82/L',
      rating: '4.6',
      imageName: 'total',
      tag: 'Open Now',
    ),
  ];

  void _onNavTap(int i) {
    if (i == _currentIndex && i != 0) return;
    switch (i) {
      case 0:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (route) => false,
        );
        break;
      case 1:
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const OrderScreen()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ProfileScreen()),
        );
        break;
    }
    setState(() => _currentIndex = i);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── App bar ───────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A1A),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Select Station',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 36),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // ── Google Map ────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: SizedBox(
                  height: 200,
                  child: GoogleMap(
                    initialCameraPosition: const CameraPosition(
                      target: LatLng(-1.268, 36.807),
                      zoom: 14,
                    ),
                    onMapCreated: (controller) {
                      _mapController = controller;
                    },
                    zoomControlsEnabled: false,
                    myLocationButtonEnabled: false,
                    markers: {
                      const Marker(
                        markerId: MarkerId('station1'),
                        position: LatLng(-1.268, 36.807),
                      ),
                      const Marker(
                        markerId: MarkerId('station2'),
                        position: LatLng(-1.274, 36.815),
                      ),
                      const Marker(
                        markerId: MarkerId('station3'),
                        position: LatLng(-1.262, 36.800),
                      ),
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(height: 18),

            // ── Recently Stations label ────────────────────────────────
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Recently Stations',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ── Station cards list ────────────────────────────────────
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _stations.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final s = _stations[index];
                  
                  Widget targetScreen;
                  switch (index) {
                    case 0:
                      targetScreen = const StationDetailScreen1();
                      break;
                    case 1:
                      targetScreen = const StationDetailScreen2();
                      break;
                    case 2:
                      targetScreen = const StationDetailScreen3();
                      break;
                    case 3:
                      targetScreen = const StationDetailScreen4();
                      break;
                    default:
                      targetScreen = const StationDetailScreen1();
                  }

                  return _StationCard(station: s, targetScreen: targetScreen);
                },
              ),
            ),

            const SizedBox(height: 12),
          ],
        ),
      ),

      // ── Bottom nav bar ───────────────────────────────────────────────
      bottomNavigationBar: _BottomNav(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }
}

// ── Station Data Model ────────────────────────────────────────────────────────
class _StationData {
  final String name;
  final String distance;
  final String price;
  final String rating;
  final String imageName;
  final String tag;

  const _StationData({
    required this.name,
    required this.distance,
    required this.price,
    required this.rating,
    required this.imageName,
    required this.tag,
  });
}

        class _StationCard extends StatelessWidget {
          final _StationData station;
          final Widget targetScreen;
          const _StationCard({required this.station, required this.targetScreen});

          @override
          Widget build(BuildContext context) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => targetScreen,
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: const Color(0xFF2A2A2A)),
                ),
                child: Row(
                  children: [
                    // Station image
                    ClipRRect(
                      borderRadius:
                          const BorderRadius.horizontal(left: Radius.circular(10)),
                      child: Image.asset(
                        'assets/images/${station.imageName}.png',
                        width: 150,
                        height: 110, 
                        fit: BoxFit.cover,
                      ),
                    ),

                    const SizedBox(width: 25),

                    // Info column
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Name
                            Text(
                              station.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 5),

                            // Rating + distance
                            Row(
                              children: [
                                const Icon(Icons.star,
                                    color: Color(0xFFC8A84B), size: 13),
                                const SizedBox(width: 3),
                                Text(
                                  station.rating,
                                  style: const TextStyle(
                                    color: Color(0xFFCCCCCC),
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Icon(Icons.location_on_outlined,
                                    color: Color(0xFF888888), size: 13),
                                Text(
                                  station.distance,
                                  style: const TextStyle(
                                    color: Color(0xFF888888),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),

                            // Price + Open tag
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFC8A84B).withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color:
                                            const Color(0xFFC8A84B).withOpacity(0.4)),
                                  ),
                                  child: Text(
                                    station.price,
                                    style: const TextStyle(
                                      color: Color(0xFFC8A84B),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color: Colors.green.withOpacity(0.4)),
                                  ),
                                  child: Text(
                                    station.tag,
                                    style: const TextStyle(
                                      color: Color(0xFF4CAF50),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            SizedBox(
                              width: double.infinity,
                              height: 34,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => targetScreen,
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFC8A84B),
                                  foregroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  elevation: 0,
                                ),
                                child: const Text(
                                  'SELECT & ORDER',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    // Arrow
                    const Padding(
                      padding: EdgeInsets.only(right: 12),
                      child: Icon(
                        Icons.chevron_right,
                        color: Color(0xFF555555),
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        }
            

// ── Bottom Nav Bar ───────────────────────────────────────────────────────────
class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  const _BottomNav({required this.currentIndex, required this.onTap});

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
          final selected = i == currentIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => onTap(i),
              behavior: HitTestBehavior.opaque,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    items[i]['icon'] as IconData,
                    color: selected
                        ? const Color(0xFFC8A84B)
                        : const Color(0xFF555555),
                    size: 22,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    items[i]['label'] as String,
                    style: TextStyle(
                      color: selected
                          ? const Color(0xFFC8A84B)
                          : const Color(0xFF555555),
                      fontSize: 10,
                      fontWeight: selected
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}