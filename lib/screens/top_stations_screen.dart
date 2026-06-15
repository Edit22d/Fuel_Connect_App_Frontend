import 'package:flutter/material.dart';
import 'package:fuel_app/auth/theme.dart' hide ThemeToggleButton;
import 'package:fuel_app/widgets/custom_bottom_nav.dart';
import 'package:fuel_app/widgets/theme_toggle_button.dart';
import 'home_screen.dart';
import 'station_screen.dart';
import 'profile_screen.dart';

class TopStationsScreen extends StatefulWidget {
  const TopStationsScreen({super.key});

  @override
  State<TopStationsScreen> createState() => _TopStationsScreenState();
}

class _TopStationsScreenState extends State<TopStationsScreen> {
  int _currentIndex = 2; // "List" icon

  void _onNavTap(int i) {
    if (i == _currentIndex) return;
    Widget? nextScreen;
    if (i == 0) nextScreen = const HomeScreen();
    if (i == 1) nextScreen = const StationScreen();
    // i == 2 is TopStationsScreen
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

  // Dummy data for prices matching the screenshot style
  final List<Map<String, dynamic>> _topStations = [
    {
      'company': 'Total Energies',
      'distance': '3.0 km Away',
      'image': 'assets/images/Totall.png',
      'gas': '1200',
      'diesel': 'N/A',
      'petrol': '1600',
    },
    {
      'company': 'Nipco Oil',
      'distance': '5.0 km Away',
      'image': 'assets/images/shel.png', // Fallback image
      'gas': '1320',
      'diesel': 'N/A',
      'petrol': '1600',
    },
    {
      'company': 'Mobile Oil',
      'distance': '5.0 km Away',
      'image': 'assets/images/stabe.png', // Fallback image
      'gas': '1900',
      'diesel': '1450',
      'petrol': '1400',
    },
    {
      'company': 'Mobile Oil',
      'distance': '5.0 km Away',
      'image': 'assets/images/stabe.png', // Fallback image
      'gas': '1900',
      'diesel': '1450',
      'petrol': '1400',
    },
    {
      'company': 'NNPC Oil & Gas',
      'distance': '5.0 km Away',
      'image': 'assets/images/Rubi.png', // Fallback image
      'gas': '1350',
      'diesel': 'N/A',
      'petrol': '1400',
    },
    {
      'company': 'NNPC Oil & Gas',
      'distance': '5.0 km Away',
      'image': 'assets/images/Rubi.png', // Fallback image
      'gas': '1350',
      'diesel': 'N/A',
      'petrol': '1400',
    },
  ];

  List<Map<String, dynamic>> _filteredTopStations = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredTopStations = List.from(_topStations);
    _searchController.addListener(() {
      setState(() {
        final query = _searchController.text.toLowerCase();
        _filteredTopStations = _topStations.where((station) {
          final company = station['company'].toString().toLowerCase();
          final distance = station['distance'].toString().toLowerCase();
          return company.contains(query) || distance.contains(query);
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
    final subTextColor = isDark ? Colors.grey[400] : Colors.grey[600];
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDark ? const Color(0xFF2A2A2A) : Colors.grey[200],
                          ),
                          child: Icon(Icons.arrow_back, color: textColor, size: 20),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Top Stations & Prices',
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
                        bgColor: isDark ? const Color(0xFF2A2A2A) : Colors.grey[200]!,
                      ),
                    ],
                  ),
                ),

                // Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 48,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(color: (subTextColor ?? Colors.grey).withOpacity(0.3)),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.search, color: subTextColor, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: _searchController,
                                  style: TextStyle(color: textColor, fontSize: 14),
                                  decoration: InputDecoration(
                                    hintText: 'Find a station by name or location',
                                    hintStyle: TextStyle(color: subTextColor, fontSize: 14),
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
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
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

                const SizedBox(height: 24),

                // Table Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          'Company',
                          style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Gas',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Diesel',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Petrol',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 8, bottom: 100), // padding for bottom nav
                    itemCount: _filteredTopStations.length,
                    itemBuilder: (context, index) {
                      final station = _filteredTopStations[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.02),
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Company Info
                            Expanded(
                              flex: 3,
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      station['image'],
                                      width: 40,
                                      height: 40,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Container(
                                        width: 40, height: 40, color: Colors.grey[300],
                                        child: const Icon(Icons.local_gas_station, size: 20),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          station['company'],
                                          style: TextStyle(
                                            color: textColor,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.location_on,
                                              color: AppTheme.gold, // Changed from green to gold
                                              size: 12,
                                            ),
                                            const SizedBox(width: 4),
                                            Expanded(
                                              child: Text(
                                                station['distance'],
                                                style: TextStyle(
                                                  color: subTextColor,
                                                  fontSize: 11,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
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
                            
                            // Prices
                            Expanded(
                              flex: 1,
                              child: Text(
                                station['gas'],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: subTextColor,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                station['diesel'],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: subTextColor,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                station['petrol'],
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
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
      ),
    );
  }
}
