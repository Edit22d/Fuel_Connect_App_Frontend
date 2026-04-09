import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '/screens/station_screen.dart';
import '/screens/order_screen.dart';
import '/screens/profile_screen.dart';
import '/screens/support_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  bool _showSearchDropdown = false;
  bool _showBrandsDropdown = false;
  String _searchQuery = '';

  // Map controller for live search and camera movement
  final Completer<GoogleMapController> _mapController = Completer();

  final List<Map<String, String>> _fuelStations = [
    {'name': 'Shell - Waiyaki Way', 'distance': '0.8 km', 'rating': '4.9'},
    {'name': 'Total - Kenyatta Ave', 'distance': '1.2 km', 'rating': '4.7'},
    {'name': 'Rubis - Limuru Rd', 'distance': '1.5 km', 'rating': '4.8'},
    {'name': 'Stabex - Mombasa Rd', 'distance': '2.1 km', 'rating': '4.5'},
    {'name': 'Shell - Thika Rd', 'distance': '2.8 km', 'rating': '4.6'},
  ];

  // Live Bukoto, Kampala, Uganda coordinates
  final LatLng _bukotoKampala = const LatLng(0.3450, 32.5830);

  List<Map<String, String>> get _filteredStations {
    if (_searchQuery.isEmpty) return _fuelStations;
    return _fuelStations
        .where((s) => s['name']!.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  void _onNavTap(int i) {
    if (i == _currentIndex && i != 0) return;
    switch (i) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SupportScreen()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const StationScreen()),
        );
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
         case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ProfileScreen()),
        );
        break;
    }
    setState(() => _currentIndex = i);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Top bar ──────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Row(
                  children: [
                    // Avatar
                    Container(
                      width: 38,
                      height: 38,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF2A2A2A),
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/avatar.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Name + greeting
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Alex Johnson',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            'Good morning, Alex Johnson',
                            style: TextStyle(
                              color: Color(0xFF888888),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Notification bell
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A1A),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.notifications_outlined,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ── Search bar (white background, active) ──────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Container(
                      height: 46,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 12),
                          const Icon(Icons.search, color: Color(0xFF666666), size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              onChanged: (value) {
                                setState(() {
                                  _searchQuery = value;
                                  _showSearchDropdown = value.isNotEmpty;
                                  if (value.isNotEmpty) _showBrandsDropdown = false;
                                });
                              },
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 13,
                              ),
                              decoration: const InputDecoration(
                                hintText: 'Search Fuel stations near you...',
                                hintStyle: TextStyle(
                                  color: Color(0xFF999999),
                                  fontSize: 13,
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(vertical: 14),
                              ),
                            ),
                          ),
                          if (_searchController.text.isNotEmpty)
                            GestureDetector(
                              onTap: () {
                                _searchController.clear();
                                setState(() {
                                  _searchQuery = '';
                                  _showSearchDropdown = false;
                                });
                              },
                              child: const Padding(
                                padding: EdgeInsets.only(right: 12),
                                child: Icon(Icons.close, color: Color(0xFF666666), size: 18),
                              ),
                            ),
                        ],
                      ),
                    ),
                    // Search results dropdown
                    if (_showSearchDropdown)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: _filteredStations.isEmpty
                            ? const Padding(
                                padding: EdgeInsets.all(16),
                                child: Text(
                                  'No stations found',
                                  style: TextStyle(color: Color(0xFF888888), fontSize: 13),
                                ),
                              )
                            : Column(
                                mainAxisSize: MainAxisSize.min,
                                children: List.generate(_filteredStations.length, (index) {
                                  final station = _filteredStations[index];
                                  return InkWell(
                                    onTap: () async {
                                      _searchController.text = station['name']!;
                                      setState(() {
                                        _searchQuery = station['name']!;
                                        _showSearchDropdown = false;
                                      });
                                      // Animate live map to Bukoto, Kampala on search
                                      if (_mapController.isCompleted) {
                                        final ctrl = await _mapController.future;
                                        ctrl.animateCamera(
                                          CameraUpdate.newLatLngZoom(_bukotoKampala, 15.0),
                                        );
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.local_gas_station, color: Color(0xFFC8A84B), size: 18),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  station['name']!,
                                                  style: const TextStyle(
                                                    color: Colors.black87,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  '${station['distance']} away',
                                                  style: const TextStyle(
                                                    color: Color(0xFF888888),
                                                    fontSize: 11,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              const Icon(Icons.star, color: Color(0xFFC8A84B), size: 13),
                                              const SizedBox(width: 3),
                                              Text(
                                                station['rating']!,
                                                style: const TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                              ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ── Live Google Map ─────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: const Color(0xFF1A1A1A),
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: SizedBox(
                          width: double.infinity,
                          height: 200,
                          child: GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: _bukotoKampala,
                              zoom: 14,
                            ),
                            zoomControlsEnabled: true,
                            myLocationButtonEnabled: true,
                            myLocationEnabled: true,
                            mapType: MapType.normal,
                            onMapCreated: (controller) {
                              _mapController.complete(controller);
                            },
                            markers: {
                              Marker(
                                markerId: const MarkerId('station1'),
                                position: _bukotoKampala,
                                infoWindow: const InfoWindow(title: 'Bukoto, Kampala'),
                                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
                              ),
                              Marker(
                                markerId: const MarkerId('station2'),
                                position: const LatLng(0.3460, 32.5840),
                                infoWindow: const InfoWindow(title: 'Station 2'),
                                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
                              ),
                              Marker(
                                markerId: const MarkerId('station3'),
                                position: const LatLng(0.3440, 32.5820),
                                infoWindow: const InfoWindow(title: 'Station 3'),
                                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
                              ),
                            },
                          ),
                        ),
                      ),
                      // Dark gradient overlay at bottom
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          height: 70,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.vertical(
                                bottom: Radius.circular(14)),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.85),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Stations nearby label + View Map button
                      Positioned(
                        left: 14,
                        bottom: 12,
                        right: 14,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.location_on,
                                    color: Color(0xFFC8A84B), size: 16),
                                const SizedBox(width: 6),
                                const Text(
                                  '12 Stations Nearby',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFC8A84B),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'View Map',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ── Quick Fuel Varieties ─────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Quick Fuel Varieties',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Text(
                      'See all',
                      style: TextStyle(
                        color: Color(0xFFC8A84B),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // Fuel variety chips
              SizedBox(
                height: 80,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: const [
                    _FuelVarietyChip(label: 'Petrol', imageName: 'petrol'),
                       SizedBox(width: 12),
                    _FuelVarietyChip(label: 'Petrol', imageName: 'petrol'),
                    SizedBox(width: 12),
                    _FuelVarietyChip(label: 'Diesel', imageName: 'diesel'),
                    SizedBox(width: 12),
                    _FuelVarietyChip(label: 'Kerosene', imageName: 'kerosene'),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ── Top Brands ───────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Top Brands',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _showBrandsDropdown = !_showBrandsDropdown;
                          if (_showBrandsDropdown) _showSearchDropdown = false;
                        });
                      },
                      child: Row(
                        children: [
                          const Text(
                            'View all stations',
                            style: TextStyle(
                              color: Color(0xFFC8A84B),
                              fontSize: 12,
                            ),
                          ),
                          Icon(
                            _showBrandsDropdown
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: const Color(0xFFC8A84B),
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Stations dropdown from "View all stations"
              if (_showBrandsDropdown)
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(_fuelStations.length, (index) {
                      final station = _fuelStations[index];
                      return InkWell(
                        onTap: () {
                          setState(() {
                            _showBrandsDropdown = false;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          child: Row(
                            children: [
                              const Icon(Icons.local_gas_station, color: Color(0xFFC8A84B), size: 18),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      station['name']!,
                                      style: const TextStyle(
                                        color: Colors.black87,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      '${station['distance']} away',
                                      style: const TextStyle(
                                        color: Color(0xFF888888),
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.star, color: Color(0xFFC8A84B), size: 13),
                                  const SizedBox(width: 3),
                                  Text(
                                    station['rating']!,
                                    style: const TextStyle(
                                      color: Colors.black54,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),

              const SizedBox(height: 14),

              // Brand logos row
              SizedBox(
                height: 72,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: const [
                    _BrandChip(label: 'Shell', imageName: 'shell'),
                    SizedBox(width: 12),
                    _BrandChip(label: 'Total', imageName: 'total'),
                    SizedBox(width: 12),
                    _BrandChip(label: 'Rubis', imageName: 'rubis'),
                    SizedBox(width: 12),
                    _BrandChip(label: 'Stabex', imageName: 'stabex'),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ── Recommended for You ──────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Recommended for You',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // Recommended card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      // Station image
                      ClipRRect(
                        borderRadius: const BorderRadius.horizontal(
                            left: Radius.circular(12)),
                        child: Image.asset(
                          'assets/images/station.png',
                          width: 100,
                          height: 90,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Rubis - Limuru Rd',
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.star,
                                    color: Color(0xFFC8A84B), size: 13),
                                const SizedBox(width: 3),
                                const Text(
                                  '4.8',
                                  style: TextStyle(
                                    color: Color(0xFF555555),
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.location_on_outlined,
                                    color: Color(0xFF888888), size: 13),
                                const Text(
                                  '1.2 km',
                                  style: TextStyle(
                                    color: Color(0xFF888888),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFC8A84B).withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: const Color(0xFFC8A84B)
                                        .withOpacity(0.4)),
                              ),
                              child: const Text(
                                'KSh 1.82/L',
                                style: TextStyle(
                                  color: Color(0xFFC8A84B),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 8),
            ],
          ),
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

// ── Fuel Variety Chip ────────────────────────────────────────────────────────
class _FuelVarietyChip extends StatelessWidget {
  final String label;
  final String imageName;
  const _FuelVarietyChip({required this.label, required this.imageName});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/$imageName.png',
            width: 32,
            height: 32,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Brand Chip ───────────────────────────────────────────────────────────────
class _BrandChip extends StatelessWidget {
  final String label;
  final String imageName;
  const _BrandChip({required this.label, required this.imageName});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/$imageName.png',
            width: 32,
            height: 32,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF555555),
              fontSize: 11,
            ),
          ),
        ],
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
      {'icon': Icons.support_agent_outlined, 'label': 'Support'},
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