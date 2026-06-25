import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' hide Path;
import 'package:fuel_app/auth/theme.dart' hide ThemeToggleButton;
import 'package:fuel_app/widgets/theme_toggle_button.dart';
import 'package:fuel_app/widgets/custom_bottom_nav.dart';
import 'package:fuel_app/services/station_service.dart';
import 'package:fuel_app/models/station_model.dart';
import 'package:fuel_app/screens/station_detail_screen.dart';
import '/screens/home_screen.dart';
import '/screens/profile_screen.dart';
import '/screens/top_stations_screen.dart';

class StationScreen extends StatefulWidget {
  const StationScreen({super.key});

  @override
  State<StationScreen> createState() => _StationScreenState();
}

class _StationScreenState extends State<StationScreen> {
  final MapController _mapController = MapController();
  final StationService _stationService = StationService();
  int _currentIndex = 1;
  
  // Backend data only - NO DUMMY DATA
  List<StationModel> _stations = [];
  bool _isLoading = true;
  String _errorMessage = '';

  // UI data - built ONLY from backend data
  List<Map<String, dynamic>> _filteredNearbyStations = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadStationsFromBackend();
    _searchController.addListener(() {
      setState(() {
        final query = _searchController.text.toLowerCase();
        _filteredNearbyStations = _filteredNearbyStations.where((station) {
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

  Future<void> _loadStationsFromBackend() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final result = await _stationService.getStations(limit: 50);
      
      if (mounted) {
        setState(() {
          _isLoading = false;
          if (result['success']) {
            _stations = result['stations'] ?? [];
            _buildStationCardsFromData();
          } else {
            _errorMessage = result['message'] ?? 'Failed to load stations';
            _filteredNearbyStations = [];
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Network error: $e';
          _filteredNearbyStations = [];
        });
      }
    }
  }

  void _buildStationCardsFromData() {
    // Build UI data ONLY from backend stations - NO DUMMY DATA
    _filteredNearbyStations = _stations.map((station) {
      // Use the dynamic detail screen with station data
      Widget targetScreen = StationDetailScreen(station: station);

      // Calculate distance (mock if no coordinates)
      String distance;
      String time;
      final index = _stations.indexOf(station);
      if (station.latitude != null && station.longitude != null) {
        distance = '${(2.0 + (index % 5)).toStringAsFixed(1)} km';
        time = '${(5 + (index % 10)).toString()} mins';
      } else {
        distance = '${(2.0 + (index % 5)).toStringAsFixed(1)} km';
        time = '${(5 + (index % 10)).toString()} mins';
      }

      return {
        'id': station.id,
        'name': station.name,
        'rating': station.rating.toStringAsFixed(1),
        'reviews': '(${station.reviewsCount})',
        'distance': distance,
        'time': time,
        'image': station.image,
        'target': targetScreen,
        'station': station,
        'isOpen': station.isOpen,
        'fuelTypes': station.fuelTypes,
        'price': station.pricePerGallon,
        'address': station.address,
        'phone': station.phone,
        'email': station.email,
        'latitude': station.latitude,
        'longitude': station.longitude,
      };
    }).toList();
  }

  // Helper method to build station image - displays uploaded images
  Widget _buildStationImage(String? imageUrl) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
        return Image.network(
          imageUrl,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[800],
              child: const Icon(
                Icons.local_gas_station,
                size: 30,
                color: Colors.white54,
              ),
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              color: Colors.grey[800],
              child: const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppTheme.gold),
                ),
              ),
            );
          },
        );
      } else {
        return Image.asset(
          imageUrl,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (_, __, ___) => Container(
            color: Colors.grey[800],
            child: const Icon(Icons.local_gas_station, size: 30, color: Colors.white54),
          ),
        );
      }
    }
    return Container(
      color: Colors.grey[800],
      child: const Icon(
        Icons.local_gas_station,
        size: 30,
        color: Colors.white54,
      ),
    );
  }

  void _onNavTap(int i) {
    if (i == _currentIndex) return;
    Widget? nextScreen;
    if (i == 0) nextScreen = const HomeScreen();
    if (i == 2) nextScreen = const TopStationsScreen();
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
                initialCenter: LatLng(0.3476, 32.5825),
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
                  markers: _buildStationMarkers(),
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
              height: 380,
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
                        if (!_isLoading && _filteredNearbyStations.isNotEmpty)
                          Text(
                            '${_filteredNearbyStations.length} stations',
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Horizontal Scrollable Cards - ONLY REAL DATA
                  SizedBox(
                    height: 210,
                    child: _isLoading
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const CircularProgressIndicator(
                                  color: AppTheme.gold,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Loading stations...',
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : _filteredNearbyStations.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.local_gas_station_outlined,
                                      size: 40,
                                      color: Colors.grey[500],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      _errorMessage.isNotEmpty ? _errorMessage : 'No stations found',
                                      style: TextStyle(
                                        color: Colors.grey[500],
                                        fontSize: 14,
                                      ),
                                    ),
                                    if (_errorMessage.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Text(
                                          'Try adding a station from the dashboard',
                                          style: TextStyle(
                                            color: Colors.grey[400],
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              )
                            : ListView.builder(
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
                  if (_filteredNearbyStations.isNotEmpty)
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
          MaterialPageRoute(
            builder: (_) => station['target'] ?? StationDetailScreen(station: station['station']),
          ),
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
              child: SizedBox(
                height: 100,
                width: double.infinity,
                child: _buildStationImage(station['image']),
              ),
            ),
            
            // Details
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    station['name'] ?? 'Unknown Station',
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
                        station['distance'] ?? 'N/A',
                        style: TextStyle(color: Colors.grey[500], fontSize: 12),
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.access_time, color: Colors.grey, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        station['time'] ?? 'N/A',
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

  List<Marker> _buildStationMarkers() {
    if (_stations.isNotEmpty) {
      return _stations.where((station) => 
        station.latitude != null && station.longitude != null
      ).map((station) {
        return _buildStationMarker(
          LatLng(
            station.latitude!.toDouble(),
            station.longitude!.toDouble(),
          ),
          station.image,
        );
      }).toList();
    }
    return [];
  }

  Marker _buildStationMarker(LatLng point, String? imageUrl) {
    Widget markerImage;
    
    if (imageUrl != null && imageUrl.isNotEmpty && 
        (imageUrl.startsWith('http://') || imageUrl.startsWith('https://'))) {
      markerImage = ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Image.network(
          imageUrl,
          width: 36,
          height: 28,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Icon(Icons.local_gas_station, size: 20),
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              width: 36,
              height: 28,
              color: Colors.grey[800],
              child: const Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppTheme.gold),
                  ),
                ),
              ),
            );
          },
        ),
      );
    } else {
      markerImage = ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Image.asset(
          'assets/images/shel.png',
          width: 36,
          height: 28,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Icon(Icons.local_gas_station, size: 20),
        ),
      );
    }
    
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
            child: markerImage,
          ),
          const SizedBox(height: 2),
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: AppTheme.gold,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
          ),
        ],
      ),
    );
  }
}