import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' hide Path;
import 'package:fuel_app/auth/theme.dart' hide ThemeToggleButton;
import 'package:fuel_app/widgets/theme_toggle_button.dart';
import 'package:fuel_app/widgets/custom_bottom_nav.dart';

import '/screens/home_screen.dart';
import '/screens/profile_screen.dart';
import '/screens/top_stations_screen.dart';
import '/screens/station_detail_screen1.dart';
import '/screens/station_detail_screen2.dart';
import '/screens/station_detail_screen3.dart';


class StationScreen extends StatefulWidget {
  const StationScreen({super.key});

  @override
  State<StationScreen> createState() => _StationScreenState();
}

class _StationScreenState extends State<StationScreen> {
  final MapController _mapController = MapController();
  int _currentIndex = 1;

  final List<Map<String, dynamic>> _nearbyStations = [
    {
      'name': 'Aloha Petroleum',
      'rating': '4.3',
      'reviews': '(420)',
      'distance': '2 km',
      'time': '5 mins',
      'image': 'assets/images/stabe.png',
      'target': const StationDetailScreen1(),
    },
    {
      'name': 'American Gas',
      'rating': '4.5',
      'reviews': '(670)',
      'distance': '2 km',
      'time': '5 mins',
      'image': 'assets/images/shel.png',
      'target': const StationDetailScreen2(),
    },
    {
      'name': 'Rubis Station',
      'rating': '4.8',
      'reviews': '(890)',
      'distance': '3 km',
      'time': '8 mins',
      'image': 'assets/images/Rubi.png',
      'target': const StationDetailScreen3(),
    },
  ];

  List<Map<String, dynamic>> _filteredNearbyStations = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredNearbyStations = List.from(_nearbyStations);
    _searchController.addListener(() {
      setState(() {
        final query = _searchController.text.toLowerCase();
        _filteredNearbyStations = _nearbyStations.where((station) {
          final name = station['name'].toString().toLowerCase();
          return name.contains(query);
        }).toList();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }


  void _onNavTap(int i) {
    if (i == _currentIndex) return;
    Widget? nextScreen;
    if (i == 0) nextScreen = const HomeScreen();
    if (i == 2) nextScreen = const TopStationsScreen();
    // i == 3 is Favorites (placeholder)
    if (i == 4) nextScreen = const ProfileScreen();

    if (nextScreen != null) {
      if (i == 4) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ProfileScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => nextScreen!,
            transitionDuration: Duration.zero,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppTheme.darkBg : AppTheme.lightBg;
    final textColor = isDark ? Colors.white : Colors.black;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          // Map Background
          Positioned.fill(
            child: FlutterMap(
              mapController: _mapController,
              options: const MapOptions(
                initialCenter: LatLng(0.3476, 32.5825), // Kampala example
                initialZoom: 14,
              ),
              children: [
                TileLayer(
                  urlTemplate: isDark 
                      ? 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png'
                      : 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',
                  subdomains: const ['a', 'b', 'c', 'd'],
                  userAgentPackageName: 'com.fuelconnect.app',
                ),
                MarkerLayer(
                  markers: [
                    _buildStationMarker(const LatLng(0.3476, 32.5825), 'assets/images/shel.png'),
                    _buildStationMarker(const LatLng(0.3520, 32.5800), 'assets/images/stabe.png'),
                    _buildStationMarker(const LatLng(0.3450, 32.5880), 'assets/images/Rubi.png'),
                    _buildStationMarker(const LatLng(0.3410, 32.5750), 'assets/images/Totall.png'),
                  ],
                ),
              ],
            ),
          ),

          // Header & Search Overlays
          SafeArea(
            child: Column(
              children: [
                // Top Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: cardColor,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: Icon(Icons.arrow_back, color: textColor, size: 20),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Station Near You',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      CustomThemeToggle(
                        iconColor: textColor,
                        bgColor: cardColor,
                      ),
                    ],
                  ),
                ),

                // Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(color: Colors.grey.withOpacity(0.3)),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.search, color: Colors.grey[400], size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: _searchController,
                                  style: TextStyle(color: textColor, fontSize: 14),
                                  decoration: InputDecoration(
                                    hintText: 'Find a station by name or...',
                                    hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                                    border: InputBorder.none,
                                    isDense: true,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: cardColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(Icons.tune, color: textColor, size: 20),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Bottom Sheet Overlay
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 380, // Enough height for the bottom nav and the content
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Nearby Petrol Stations',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'See all',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Horizontal Scrollable Cards
                  SizedBox(
                    height: 210, // Increased height to fix overflow
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _filteredNearbyStations.length,
                      itemBuilder: (context, index) {
                        final station = _filteredNearbyStations[index];
                        return _buildStationCard(station, textColor, cardColor);
                      },
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      'Most Nearest',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Bottom Nav space
                ],
              ),
            ),
          ),

          // Custom Bottom Nav
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: CustomBottomNav(
              currentIndex: _currentIndex,
              onTap: _onNavTap,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStationCard(Map<String, dynamic> station, Color textColor, Color cardColor) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => station['target']),
        );
      },
      child: Container(
        width: 220,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: Stack(
                children: [
                  Image.asset(
                    station['image'],
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 100, color: Colors.grey[300],
                      child: const Icon(Icons.image),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'GASOLINE',
                        style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Details
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    station['name'],
                    style: TextStyle(
                      color: textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: AppTheme.gold, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        '${station['rating']} ${station['reviews']}',
                        style: TextStyle(color: Colors.grey[500], fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.grey, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        station['distance'],
                        style: TextStyle(color: Colors.grey[500], fontSize: 12),
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.access_time, color: Colors.grey, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        station['time'],
                        style: TextStyle(color: Colors.grey[500], fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Marker _buildStationMarker(LatLng point, String imageAsset) {
    return Marker(
      point: point,
      width: 50,
      height: 60,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.asset(
                imageAsset,
                width: 36,
                height: 28,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox(
                  width: 36, height: 28, child: Icon(Icons.local_gas_station, size: 20),
                ),
              ),
            ),
          ),
          const SizedBox(height: 2),
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: AppTheme.gold, // Replaced green dot with gold to match theme
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
          ),
        ],
      ),
    );
  }
}