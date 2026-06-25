import 'package:flutter/material.dart';
import 'package:fuel_app/auth/theme.dart' hide ThemeToggleButton;
import 'package:fuel_app/widgets/theme_toggle_button.dart';
import 'package:fuel_app/widgets/custom_bottom_nav.dart';
import 'package:fuel_app/services/station_service.dart';
import 'package:fuel_app/models/station_model.dart';
import '/screens/station_screen.dart';
import '/screens/top_stations_screen.dart';
import '/screens/profile_screen.dart';
import '/screens/station_detail_screen1.dart';
import '/screens/station_detail_screen2.dart';
import '../services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _auth = AuthService();
  final StationService _stationService = StationService();
  int _currentIndex = 0;

  // Backend data ONLY - NO DUMMY DATA
  List<StationModel> _recommendedStationsList = [];
  bool _isLoading = true;
  String _errorMessage = '';

  // UI data - built ONLY from backend data
  List<Map<String, dynamic>> _filteredStations = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadRecommendedStations();
    _searchController.addListener(() {
      setState(() {
        final query = _searchController.text.toLowerCase();
        _filteredStations = _filteredStations.where((station) {
          final name = station['name'].toString().toLowerCase();
          final address = station['address']?.toString().toLowerCase() ?? '';
          final location = station['location']?.toString().toLowerCase() ?? '';
          return name.contains(query) || address.contains(query) || location.contains(query);
        }).toList();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadRecommendedStations() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final result = await _stationService.getTopStations();

      if (mounted) {
        setState(() {
          _isLoading = false;
          if (result['success']) {
            _recommendedStationsList = result['stations'] ?? [];
            _buildStationCardsFromData();
          } else {
            _errorMessage = result['message'] ?? 'Failed to load stations';
            _recommendedStationsList = [];
            _filteredStations = [];
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Network error: $e';
          _recommendedStationsList = [];
          _filteredStations = [];
        });
      }
    }
  }

  void _buildStationCardsFromData() {
    // Build UI data ONLY from backend stations - NO DUMMY DATA
    _filteredStations = _recommendedStationsList.map((station) {
      // Determine which detail screen to use
      final index = _recommendedStationsList.indexOf(station);
      Widget targetScreen;
      if (index % 2 == 0) {
        targetScreen = const StationDetailScreen1();
      } else {
        targetScreen = const StationDetailScreen2();
      }

      // Use address as location if location is not available
      String location = station.address ?? 'Unknown Location';

      return {
        'id': station.id,
        'name': station.name,
        'address': station.address,
        'location': location,
        'rating': station.rating.toStringAsFixed(1),
        'image': station.image, // Keep the full URL from backend
        'isOpen': station.isOpen,
        'target': targetScreen,
        'station': station,
        'price': station.pricePerGallon,
        'fuelTypes': station.fuelTypes,
        'phone': station.phone,
        'email': station.email,
        'latitude': station.latitude,
        'longitude': station.longitude,
      };
    }).toList();
  }

  // Helper method to build station image - displays uploaded images
  Widget _buildStationImage(String? imageUrl) {
    // Check if image URL exists and is not empty
    if (imageUrl != null && imageUrl.isNotEmpty) {
      // Check if it's a network URL
      if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
        return Image.network(
          imageUrl,
          height: double.infinity,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            // Show dark placeholder with gas icon if image fails
            return Container(
              color: Colors.grey[800],
              child: const Icon(
                Icons.local_gas_station,
                size: 40,
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
        // If it's an asset path (shouldn't happen with backend data)
        return Image.asset(
          imageUrl,
          height: double.infinity,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: Colors.grey[800],
            child: const Icon(Icons.local_gas_station, size: 40, color: Colors.white54),
          ),
        );
      }
    }
    
    // Only show this fallback if NO image URL exists
    return Container(
      color: Colors.grey[800],
      child: const Icon(
        Icons.local_gas_station,
        size: 40,
        color: Colors.white54,
      ),
    );
  }

  void _onNavTap(int i) {
    if (i == _currentIndex) return;
    Widget? nextScreen;
    if (i == 1) {
      nextScreen = const StationScreen();  // Removed 'const' - this is the fix
    } else if (i == 2) {
      nextScreen = const TopStationsScreen();
    } else if (i == 4) {
      nextScreen = const ProfileScreen();
    }

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

  Future<void> _handleLogout() async {
    await _auth.logout();
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
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
      appBar: AppBar(
        title: const Text(
          'Fuel Connect',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _handleLogout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Stack(
        children: [
          // Scrollable Content
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero Section
                Container(
                  height: MediaQuery.of(context).size.height * 0.55,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                    image: DecorationImage(
                      image: AssetImage('assets/images/shel.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Gradient Overlay
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(40),
                            bottomRight: Radius.circular(40),
                          ),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.6),
                              Colors.black.withOpacity(0.3),
                              const Color(0xFF0F2027),
                            ],
                          ),
                        ),
                      ),
                      
                      // Content inside Hero
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Top Bar
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: AppTheme.gold, width: 2),
                                    ),
                                    child: CircleAvatar(
                                      radius: 20,
                                      backgroundImage: const AssetImage('assets/images/avatar.png'),
                                      backgroundColor: Colors.grey[800],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on_outlined, color: Colors.white, size: 16),
                                      const SizedBox(width: 4),
                                      const Text(
                                        'From San Francisco',
                                        style: TextStyle(color: Colors.white, fontSize: 14),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      CustomThemeToggle(iconColor: Colors.white, bgColor: Colors.transparent),
                                      const SizedBox(width: 10),
                                      GestureDetector(
                                        onTap: () => Navigator.pushNamed(context, '/notifications'),
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.2),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(Icons.notifications_none, color: Colors.white, size: 20),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              
                              const Spacer(),
                              
                              // Main Hero Text
                              Row(
                                children: [
                                  const Icon(Icons.home_outlined, color: Colors.white70, size: 16),
                                  const SizedBox(width: 6),
                                  const Text('Fuel Station', style: TextStyle(color: Colors.white70, fontSize: 14)),
                                ],
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Recommended\nFuel Station',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: 16),
                              
                              // Badges row
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.local_gas_station, color: Colors.white70, size: 16),
                                      const SizedBox(width: 4),
                                      const Text('\$3.60 Per Gallon', style: TextStyle(color: Colors.white70, fontSize: 13)),
                                      const SizedBox(width: 16),
                                      const Icon(Icons.build, color: Colors.white70, size: 16),
                                      const SizedBox(width: 4),
                                      const Text('Fuel + Services', style: TextStyle(color: Colors.white70, fontSize: 13)),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: AppTheme.gold,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Text(
                                      '24/7',
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                            ],
                          ),
                        ),
                      ),
                      
                      // Floating Search Bar
                      Positioned(
                        bottom: 0,
                        left: 20,
                        right: 20,
                        child: Transform.translate(
                          offset: const Offset(0, 25),
                          child: Container(
                            height: 60,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(color: Colors.grey.withOpacity(0.3)),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.search, color: Colors.white70),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: TextField(
                                    controller: _searchController,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: const InputDecoration(
                                      hintText: 'Search Fuel Station',
                                      hintStyle: TextStyle(color: Colors.white70),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.tune, color: Colors.black, size: 18),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Recommended Section - ONLY REAL DATA
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recommended for You',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (!_isLoading && _filteredStations.isNotEmpty)
                        Text(
                          '${_filteredStations.length} stations',
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
                
                // Horizontal Cards - ONLY REAL DATA
                SizedBox(
                  height: 220,
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
                      : _filteredStations.isEmpty
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
                                    _errorMessage.isNotEmpty ? _errorMessage : 'No stations available',
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
                              itemCount: _filteredStations.length,
                              itemBuilder: (context, index) {
                                final station = _filteredStations[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => station['target'] ?? const StationDetailScreen1(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: 160,
                                    margin: const EdgeInsets.symmetric(horizontal: 6),
                                    decoration: BoxDecoration(
                                      color: cardColor,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Stack(
                                      children: [
                                        // Full Image - Using _buildStationImage for uploaded images
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(20),
                                          child: _buildStationImage(station['image']),
                                        ),
                                        // Gradient at bottom for text
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                Colors.transparent,
                                                Colors.transparent,
                                                Colors.black.withOpacity(0.8),
                                              ],
                                            ),
                                          ),
                                        ),
                                        // Open Badge - Gold
                                        if (station['isOpen'] == true)
                                          Positioned(
                                            top: 12,
                                            right: 12,
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: AppTheme.gold,
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: const Text(
                                                'Open',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        // Price Badge
                                        if (station['price'] != null)
                                          Positioned(
                                            top: 12,
                                            left: 12,
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: AppTheme.gold,
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                '\$${station['price'].toStringAsFixed(2)}',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        // Text Info
                                        Positioned(
                                          bottom: 12,
                                          left: 12,
                                          right: 12,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                station['name'] ?? 'Unknown',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  const Icon(Icons.location_on, color: Colors.white70, size: 12),
                                                  const SizedBox(width: 4),
                                                  Expanded(
                                                    child: Text(
                                                      station['location'] ?? 'N/A',
                                                      style: const TextStyle(color: Colors.white70, fontSize: 11),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  const Icon(Icons.star, color: AppTheme.gold, size: 12),
                                                  const SizedBox(width: 2),
                                                  Text(
                                                    station['rating'] ?? '0.0',
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 11,
                                                      fontWeight: FontWeight.bold,
                                                    ),
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
                              },
                            ),
                ),
              ],
            ),
          ),
          
          // Bottom Navigation Bar
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
}