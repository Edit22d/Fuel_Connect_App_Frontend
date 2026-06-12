import 'package:flutter/material.dart';
import 'package:fuel_app/auth/theme.dart' hide ThemeToggleButton;
import 'package:fuel_app/widgets/theme_toggle_button.dart';
import 'package:fuel_app/widgets/custom_bottom_nav.dart';
import '/screens/station_screen.dart';
import '/screens/top_stations_screen.dart';
import '/screens/profile_screen.dart';
import '/screens/station_detail_screen1.dart';
import '/screens/station_detail_screen2.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0; // Home

  void _onNavTap(int i) {
    if (i == _currentIndex) return;
    Widget? nextScreen;
    if (i == 1) nextScreen = const StationScreen();
    if (i == 2) nextScreen = const TopStationsScreen();
    // i == 3 is Favorites (placeholder)
    if (i == 4) nextScreen = const ProfileScreen();

    if (nextScreen != null) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => nextScreen!,
          transitionDuration: Duration.zero
        ),
      );
    }
  }

  final List<Map<String, dynamic>> _recommendedStations = [
    {
      'name': 'Love\'s Travel Stop',
      'location': 'Dallas, TX',
      'rating': '4.9',
      'image': 'assets/images/stabe.png',
      'isOpen': true,
      'target': const StationDetailScreen1(),
    },
    {
      'name': 'Costco Gasoline',
      'location': 'Seattle, WA',
      'rating': '4.5',
      'image': 'assets/images/shel.png',
      'isOpen': true,
      'target': const StationDetailScreen2(),
    },
    {
      'name': 'Total Energies',
      'location': 'Austin, TX',
      'rating': '4.7',
      'image': 'assets/images/Totall.png',
      'isOpen': true,
      'target': const StationDetailScreen1(),
    },
  ];

  List<Map<String, dynamic>> _filteredStations = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredStations = List.from(_recommendedStations);
    _searchController.addListener(() {
      setState(() {
        final query = _searchController.text.toLowerCase();
        _filteredStations = _recommendedStations.where((station) {
          final name = station['name'].toString().toLowerCase();
          final location = station['location'].toString().toLowerCase();
          return name.contains(query) || location.contains(query);
        }).toList();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppTheme.darkBg : AppTheme.lightBg;
    final textColor = isDark ? Colors.white : Colors.black;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    
    // To match the screenshot, we use a fixed light background for the content area
    // but we will adapt to the theme so it looks good in dark mode too.

    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          // Scrollable Content
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100), // Space for bottom nav
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
                      image: AssetImage('assets/images/shel.png'), // Placeholder hero image
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Gradient Overlay for readability
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
                              const Color(0xFF0F2027), // Deep dark cyan-ish color matching screenshot
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
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.2),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(Icons.notifications_none, color: Colors.white, size: 20),
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
                                      color: AppTheme.gold, // Changed from green to gold
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
                      
                      // Floating Search Bar at the bottom of hero
                      Positioned(
                        bottom: 0,
                        left: 20,
                        right: 20,
                        child: Transform.translate(
                          offset: const Offset(0, 25), // Halfway out
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
                
                const SizedBox(height: 40), // Space for floating search bar
                
                // Recommended Section
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
                      Text(
                        'View all',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Horizontal Cards
                SizedBox(
                  height: 220,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredStations.length,
                    itemBuilder: (context, index) {
                      final station = _filteredStations[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => station['target']),
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
                              // Full Image
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.asset(
                                  station['image'],
                                  height: double.infinity,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
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
                              // Open Badge
                              Positioned(
                                top: 12,
                                right: 12,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                                  ),
                                  child: const Text(
                                    'Open',
                                    style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
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
                                      station['name'],
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
                                            station['location'],
                                            style: const TextStyle(color: Colors.white70, fontSize: 11),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const Icon(Icons.star, color: AppTheme.gold, size: 12),
                                        const SizedBox(width: 2),
                                        Text(
                                          station['rating'],
                                          style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
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