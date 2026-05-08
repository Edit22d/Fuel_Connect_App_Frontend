import 'dart:async';
import 'package:flutter/material.dart';
// We keep the import for LatLng since it is used in the FuelStation model
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '/screens/order_screen.dart';
import '/screens/support_screen.dart';
import '/screens/profile_screen.dart';
import '/screens/fuel_type_screen.dart';
import '../services/auth_service.dart';
import '../auth/login_screen.dart';

void main() => runApp(const HomeScreen());

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fuel Finder',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF1A1A1A),
        fontFamily: 'SF Pro Display',
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFC4963D),
          surface: Color(0xFF2A2A2A),
        ),
      ),
      home: const StationsNearYouScreen(),
    );
  }
}


class FuelStation {
  final String id;
  final String name;
  final String address;
  final double rating;
  final int reviewCount;
  final String distance;
  final String imageUrl;
  final LatLng position;
  final bool isOpen;
  final String pricePerLitre;
  final List<String> fuelTypes;
  final String phone;
  final String openingHours;

  const FuelStation({
    required this.id,
    required this.name,
    required this.address,
    required this.rating,
    required this.reviewCount,
    required this.distance,
    required this.imageUrl,
    required this.position,
    required this.isOpen,
    required this.pricePerLitre,
    this.fuelTypes = const [],
    this.phone = '',
    this.openingHours = '',
  });

  bool matchesQuery(String query) {
    final lowerQuery = query.toLowerCase();
    return name.toLowerCase().contains(lowerQuery) ||
        address.toLowerCase().contains(lowerQuery) ||
        fuelTypes.any((f) => f.toLowerCase().contains(lowerQuery));
  }
}

class FuelType {
  final String name;
  final String icon;
  final Color color;

  const FuelType({
    required this.name,
    required this.icon,
    required this.color,
  });
}

final List<FuelType> kFuelTypes = [
  const FuelType(name: 'V-Power', icon: '⚡', color: Color(0xFFC4963D)),
  const FuelType(name: 'Petrol 98', icon: '⛽', color: Color(0xFFFF8C00)),
  const FuelType(name: 'Diesel', icon: '🛢️', color: Color(0xFFFF8C00)),
  const FuelType(name: 'Kerosene', icon: '💧', color: Color(0xFFFF8C00)),
  const FuelType(name: 'LPG', icon: '🔥', color: Color(0xFFFF8C00)),
  const FuelType(name: 'Electric', icon: '⚡', color: Color(0xFFFF8C00)),
];

final List<FuelStation> kStations = [
  FuelStation(
    id: '1',
    name: 'Shell Ntinda',
    address: 'Ntinda Road, Kampala',
    rating: 4.6,
    reviewCount: 342,
    distance: '0.3 km',
    imageUrl: 'assets/images/Shel.png',
    position: const LatLng(0.3476, 32.5825),
    isOpen: true,
    pricePerLitre: 'UGX 4,850',
    fuelTypes: ['Petrol 95', 'Petrol 98', 'Diesel'],
    phone: '+256 414 123456',
    openingHours: '24 Hours',
  ),
  FuelStation(
    id: '2',
    name: 'TotalEnergies',
    address: 'Kampala Road, Kampala',
    rating: 4.5,
    reviewCount: 289,
    distance: '0.7 km',
    imageUrl: 'assets/images/Totall.png',
    position: const LatLng(0.3460, 32.5840),
    isOpen: true,
    pricePerLitre: 'UGX 4,800',
    fuelTypes: ['Petrol 95', 'Diesel', 'Kerosene'],
    phone: '+256 414 234567',
    openingHours: '6:00 AM - 10:00 PM',
  ),
  FuelStation(
    id: '3',
    name: 'Stabex',
    address: 'Jinja Road, Kampala',
    rating: 4.3,
    reviewCount: 156,
    distance: '1.1 km',
    imageUrl: 'assets/images/Stabe.png',
    position: const LatLng(0.3490, 32.5810),
    isOpen: false,
    pricePerLitre: 'UGX 4,780',
    fuelTypes: ['Petrol 95', 'Diesel', 'LPG'],
    phone: '+256 414 345678',
    openingHours: '7:00 AM - 9:00 PM',
  ),
  FuelStation(
    id: '4',
    name: 'Rubis',
    address: 'Bombo Road, Kampala',
    rating: 4.4,
    reviewCount: 198,
    distance: '1.5 km',
    imageUrl: 'assets/images/Rubi.png',
    position: const LatLng(0.3510, 32.5800),
    isOpen: true,
    pricePerLitre: 'UGX 4,820',
    fuelTypes: ['Petrol 95', 'Petrol 98', 'Diesel', 'Electric'],
    phone: '+256 414 456789',
    openingHours: '24 Hours',
  ),
  FuelStation(
    id: '5',
    name: 'City Oil',
    address: 'Entebbe Road, Kampala',
    rating: 4.2,
    reviewCount: 134,
    distance: '2.0 km',
    imageUrl: 'assets/images/cityoil.png',
    position: const LatLng(0.3445, 32.5790),
    isOpen: true,
    pricePerLitre: 'UGX 4,790',
    fuelTypes: ['Petrol 95', 'Diesel', 'Kerosene'],
    phone: '+256 414 567890',
    openingHours: '6:00 AM - 11:00 PM',
  ),
];



class StationDetailScreen extends StatefulWidget {
  final FuelStation station;

  const StationDetailScreen({
    super.key,
    required this.station,
  });

  @override
  State<StationDetailScreen> createState() => _StationDetailScreenState();
}

class _StationDetailScreenState extends State<StationDetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 280,
              pinned: true,
              backgroundColor: const Color(0xFF1A1A1A),
              leading: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back, color: Colors.white),
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      widget.station.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: const Color(0xFF2A2A2A),
                        child: const Icon(
                          Icons.local_gas_station,
                          size: 80,
                          color: Color(0xFFC4963D),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.8),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.station.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  widget.station.isOpen
                                      ? 'Station is currently open'
                                      : 'Station is currently closed',
                                ),
                                backgroundColor: widget.station.isOpen
                                    ? const Color(0xFF1A4A1A)
                                    : const Color(0xFF1A4A1A),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: widget.station.isOpen
                                  ? const Color(0xFF1A4A1A)
                                  : const Color(0xFF1A4A1A),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: widget.station.isOpen
                                        ? const Color(0xFF1A4A1A)
                                        : const Color(0xFF1A4A1A),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  widget.station.isOpen ? 'Open' : 'Closed',
                                  style: TextStyle(
                                    color: widget.station.isOpen
                                        ? const Color(0xFF1A4A1A)
                                        : const Color(0xFF1A4A1A),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Color(0xFFC4963D), size: 18),
                        const SizedBox(width: 4),
                        Text(
                          '${widget.station.rating} (${widget.station.reviewCount} reviews)',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Icon(Icons.location_on, color: Color(0xFFC4963D), size: 18),
                        const SizedBox(width: 4),
                        Text(
                          widget.station.distance,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Address'),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2A2A),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on, color: Color(0xFFC4963D), size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              widget.station.address,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildSectionTitle('Opening Hours'),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2A2A),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.access_time, color: Color(0xFFC4963D), size: 18),
                          const SizedBox(width: 8),
                          Text(
                            widget.station.openingHours,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildSectionTitle('Contact'),
                    GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Calling ${widget.station.phone}...')),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A2A2A),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.phone, color: Color(0xFFC4963D), size: 18),
                            const SizedBox(width: 8),
                            Text(
                              widget.station.phone,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Available Fuel Types'),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget.station.fuelTypes.map((fuelType) {
                        final type = kFuelTypes.firstWhere(
                          (t) => t.name == fuelType,
                          orElse: () => kFuelTypes[0],
                        );
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: type.color.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: type.color.withOpacity(0.5),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(type.icon, style: const TextStyle(fontSize: 16)),
                              const SizedBox(width: 6),
                              Text(
                                fuelType,
                                style: TextStyle(
                                  color: type.color,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Current Price'),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFC4963D), Color(0xFFC4963D)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Price per Litre',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            widget.station.pricePerLitre,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: MediaQuery.of(context).padding.bottom + 16,
          top: 16,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
               onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.navigation),
                label: const Text('Navigate'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2A2A2A),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FuelTypeScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC4963D),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Order Fuel',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}


// ─────────────────────────────────────────────────────────────────────────────
// MAIN HOME SCREEN
// ─────────────────────────────────────────────────────────────────────────────

class StationsNearYouScreen extends StatefulWidget {
  const StationsNearYouScreen({super.key});

  @override
  State<StationsNearYouScreen> createState() =>
      _StationsNearYouScreenState();
}

class _StationsNearYouScreenState extends State<StationsNearYouScreen>
    with TickerProviderStateMixin {

  // ── Auth Service ────────────────────────────────────────────────────────────
  final _auth = AuthService();

  // ── Map ────────────────────────────────────────────────────────────────────
  // Removed GoogleMapController as we are using a static image
  final LatLng _userLocation     = const LatLng(0.3476, 32.5825);
  final LatLng _deliveryLocation = const LatLng(0.3530, 32.5870);
  Set<Marker>   _markers   = {};
  Set<Polyline> _polylines = {};

  // ── Bottom nav ─────────────────────────────────────────────────────────────
  int _selectedNav = 0;

  // ── Auto-scroll station cards ──────────────────────────────────────────────
  late ScrollController _scrollController;
  Timer? _scrollTimer;
  bool   _userTouching = false;
  static const double _cardWidth  = 270.0;
  static const double _cardGap    = 12.0;
  static const double _cardStride = _cardWidth + _cardGap;
  static const double _scrollStep = 0.6;
  String? _activeStationId;

  // ── Fade-in ────────────────────────────────────────────────────────────────
  late AnimationController _fadeController;
  late Animation<double>   _fadeAnim;

  // ── Search ─────────────────────────────────────────────────────────────────
  final TextEditingController _searchController = TextEditingController();
  List<FuelStation> _filteredStations = kStations;
  bool _isSearching = false;

  // ── Premium Overlay Drawer ─────────────────────────────────────────────────
  late AnimationController _drawerController;
  late Animation<double>   _drawerSlideAnim;
  late Animation<double>   _contentScaleAnim;
  late Animation<double>   _contentShiftAnim;
  late Animation<double>   _contentCornerAnim;
  late Animation<double>   _overlayOpacityAnim;
  bool _drawerOpen = false;

  static const double _drawerWidthFraction = 0.75;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _setupMarkers();
    _setupPolylines();

    // Fade-in
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _fadeController.forward();

    // Drawer animation controller
    _drawerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );

    _drawerSlideAnim = CurvedAnimation(
      parent: _drawerController,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );

    _contentScaleAnim = Tween<double>(begin: 1.0, end: 0.88).animate(
      CurvedAnimation(parent: _drawerController, curve: Curves.easeOutCubic),
    );

    _contentShiftAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _drawerController, curve: Curves.easeOutCubic),
    );

    _contentCornerAnim = Tween<double>(begin: 0.0, end: 20.0).animate(
      CurvedAnimation(parent: _drawerController, curve: Curves.easeOutCubic),
    );

    _overlayOpacityAnim = Tween<double>(begin: 0.0, end: 0.45).animate(
      CurvedAnimation(parent: _drawerController, curve: Curves.easeOutCubic),
    );

    _searchController.addListener(_onSearchChanged);

    // Removed PostFrameCallback for map readiness since we are using an image
    
    _startScroll();
  }

  void _openDrawer() {
    setState(() => _drawerOpen = true);
    _drawerController.forward();
  }

  void _closeDrawer() {
    _drawerController.reverse().then((_) {
      if (mounted) setState(() => _drawerOpen = false);
    });
  }

  void _toggleDrawer() {
    if (_drawerOpen) {
      _closeDrawer();
    } else {
      _openDrawer();
    }
  }

  void _navigateToScreen(Widget screen) {
    _closeDrawer();
    Future.delayed(const Duration(milliseconds: 260), () {
      if (mounted) {
        Navigator.push(
          context,
          _premiumSlideRoute(screen),
        );
      }
    });
  }

  /// Premium right-to-left slide transition matching iOS feel
  Route _premiumSlideRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: const Duration(milliseconds: 380),
      reverseTransitionDuration: const Duration(milliseconds: 320),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final slideIn = Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));

        final slideOut = Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(-0.25, 0.0),
        ).animate(CurvedAnimation(parent: secondaryAnimation, curve: Curves.easeInCubic));

        final fade = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: animation,
            curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
          ),
        );

        return SlideTransition(
          position: slideOut,
          child: SlideTransition(
            position: slideIn,
            child: FadeTransition(opacity: fade, child: child),
          ),
        );
      },
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // LOGOUT LOGIC
  // ─────────────────────────────────────────────────────────────────────────────
  Future<void> _showLogoutDialog() async {
    final phoneController = TextEditingController();
    final passwordController = TextEditingController();
    bool isLoading = false;

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: const Color(0xFF2A2A2A),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text(
              'Confirm Logout',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Please enter your credentials to confirm logout.',
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const SizedBox(height: 16),
                _buildDialogTextField(
                  controller: phoneController,
                  hintText: 'Phone Number',
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 12),
                _buildDialogTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                  keyboardType: TextInputType.phone,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: isLoading ? null : () => Navigator.of(context).pop(),
                child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
              ),
              TextButton(
                onPressed: isLoading ? null : () async {
                  final phone = phoneController.text.trim();
                  final password = passwordController.text.trim();

                  if (phone.isEmpty || password.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please fill in all fields')),
                    );
                    return;
                  }

                  setDialogState(() => isLoading = true);

                  final result = await _auth.login(
                    emailOrPhone: phone,
                    password: password,
                  );

                  setDialogState(() => isLoading = false);

                  if (result['success']) {
                    await _auth.logout();
                    if (mounted) {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        '/',
                        (route) => false,
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(result['message'] ?? 'Invalid credentials'),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                  }
                },
                child: isLoading
                    ? const SizedBox(
                        width: 16, height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFC4963D)),
                      )
                    : const Text('Confirm', style: TextStyle(color: Color(0xFFC4963D), fontWeight: FontWeight.bold)),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDialogTextField({
    required TextEditingController controller,
    required String hintText,
    required TextInputType keyboardType,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: const Color(0xFF1A1A1A),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
  // ─────────────────────────────────────────────────────────────────────────────

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    setState(() {
      _isSearching         = query.isNotEmpty;
      _filteredStations    = query.isEmpty
          ? kStations
          : kStations.where((s) => s.matchesQuery(query)).toList();
      _activeStationId     = null;
    });
    _updateMapMarkers();
  }

  void _updateMapMarkers() {
    final markers = <Marker>{
      Marker(
        markerId: const MarkerId('user'),
        position: _userLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        infoWindow: const InfoWindow(title: 'You are here'),
      ),
      Marker(
        markerId: const MarkerId('delivery'),
        position: _deliveryLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: const InfoWindow(title: 'Delivery Location'),
      ),
    };
    for (final station in _filteredStations) {
      markers.add(Marker(
        markerId: MarkerId(station.id),
        position: station.position,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        infoWindow: InfoWindow(
          title: station.name,
          snippet: station.pricePerLitre,
        ),
      ));
    }
    setState(() => _markers = markers);
  }

  void _clearSearch() {
    _searchController.clear();
    FocusScope.of(context).unfocus();
  }

  void _startScroll() {
    _scrollTimer?.cancel();
    _scrollTimer = Timer.periodic(const Duration(milliseconds: 16), (_) {
      if (_userTouching || _isSearching) return;
      if (!_scrollController.hasClients) return;

      final pos        = _scrollController.position;
      final loopLength = _filteredStations.length * _cardStride;
      if (loopLength == 0) return;

      final next = pos.pixels + _scrollStep;
      if (next >= pos.maxScrollExtent - loopLength) {
        _scrollController.jumpTo(pos.pixels - loopLength + _scrollStep);
      } else {
        _scrollController.jumpTo(next);
      }
    });
  }

  void _onPointerDown(FuelStation station) {
    _userTouching = true;
    setState(() => _activeStationId = station.id);
    // Removed camera animation as there is no controller
  }

  void _onPointerUp() {
    _userTouching = false;
    setState(() => _activeStationId = null);
  }

  void _setupMarkers() {
    final markers = <Marker>{
      Marker(
        markerId: const MarkerId('user'),
        position: _userLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        infoWindow: const InfoWindow(title: 'You are here'),
      ),
      Marker(
        markerId: const MarkerId('delivery'),
        position: _deliveryLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: const InfoWindow(title: 'Delivery Location'),
      ),
    };
    for (final station in kStations) {
      markers.add(Marker(
        markerId: MarkerId(station.id),
        position: station.position,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        infoWindow: InfoWindow(
          title: station.name,
          snippet: station.pricePerLitre,
        ),
      ));
    }
    setState(() => _markers = markers);
  }

  void _setupPolylines() {
    _polylines = {
      Polyline(
        polylineId: const PolylineId('route'),
        points: [_userLocation, _deliveryLocation],
        color: const Color(0xFFC4963D),
        width: 4,
        patterns: [PatternItem.dash(20), PatternItem.gap(10)],
      ),
    };
  }

  @override
  void dispose() {
    _scrollTimer?.cancel();
    _scrollController.dispose();
    _fadeController.dispose();
    _drawerController.dispose();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth  = MediaQuery.of(context).size.width;
    final drawerWidth  = screenWidth * _drawerWidthFraction;
    final maxContentShift = drawerWidth * 0.30;

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: Stack(
        children: [
          // ── LAYER 1: Home content (scales + shifts when drawer opens) ───────
          AnimatedBuilder(
            animation: _drawerController,
            builder: (context, child) {
              final scale  = _contentScaleAnim.value;
              final shiftX = _contentShiftAnim.value * maxContentShift;
              final radius = _contentCornerAnim.value;

              return Transform.translate(
                offset: Offset(shiftX, 0),
                child: Transform.scale(
                  scale: scale,
                  alignment: Alignment.centerLeft,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(radius),
                    child: child,
                  ),
                ),
              );
            },
            child: FadeTransition(
              opacity: _fadeAnim,
              child: Scaffold(
                backgroundColor: const Color(0xFF1A1A1A),
                body: Column(
                  children: [
                    _buildTopBar(),
                    _buildSearchBar(),
                    Expanded(child: _buildMap()),
                    _buildFuelTypeSection(),
                    _buildNearbySection(),
                    _buildBottomNav(),
                  ],
                ),
              ),
            ),
          ),

          // ── LAYER 2: Scrim overlay ─────────────────────────────────────────
          AnimatedBuilder(
            animation: _overlayOpacityAnim,
            builder: (context, _) {
              if (_overlayOpacityAnim.value == 0) return const SizedBox.shrink();
              return GestureDetector(
                onTap: _closeDrawer,
                child: Container(
                  color: Colors.black.withOpacity(_overlayOpacityAnim.value),
                ),
              );
            },
          ),

          // ── LAYER 3: Drawer panel ────────────────────────────────────────────
          AnimatedBuilder(
            animation: _drawerSlideAnim,
            builder: (context, child) {
              final dx = -drawerWidth + (_drawerSlideAnim.value * drawerWidth);
              return Transform.translate(
                offset: Offset(dx, 0),
                child: child,
              );
            },
            child: _buildDrawerPanel(drawerWidth),
          ),
        ],
      ),
    );
  }

  // ── DRAWER PANEL ────────────────────────────────────────────────────────────
  Widget _buildDrawerPanel(double drawerWidth) {
    return SizedBox(
      width: drawerWidth,
      height: double.infinity,
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1A1A1A),
          borderRadius: BorderRadius.only(
            topRight:    Radius.circular(28),
            bottomRight: Radius.circular(28),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 32,
              offset: Offset(8, 0),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ─────────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFC4963D).withOpacity(0.15),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFC4963D).withOpacity(0.4),
                        ),
                      ),
                      child: const Icon(
                        Icons.person_rounded,
                        color: Color(0xFFC4963D),
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome back',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            'Fuel Finder',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: _closeDrawer,
                      child: const Icon(
                        Icons.close_rounded,
                        color: Colors.white38,
                        size: 22,
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(color: Colors.white10, height: 1),
              const SizedBox(height: 16),

              // ── Nav Items ─────────────────────────────────────────────────────
              _drawerItem(
                icon: Icons.local_gas_station_rounded,
                label: 'Stations',
                active: true,
                onTap: _closeDrawer,
              ),
              _drawerItem(
                icon: Icons.shopping_bag_rounded,
                label: 'Orders',
                active: false,
                onTap: () => _navigateToScreen(const OrderScreen()),
              ),
              _drawerItem(
                icon: Icons.history_rounded,
                label: 'History',
                active: false,
                onTap: () => _navigateToScreen(const OrderScreen()),
              ),
              _drawerItem(
                icon: Icons.favorite_rounded,
                label: 'Favourites',
                active: false,
                onTap: () => _navigateToScreen(const OrderScreen()),
              ),
              _drawerItem(
                icon: Icons.support_agent_rounded,
                label: 'Support',
                active: false,
                onTap: () => _navigateToScreen(const SupportScreen()),
              ),
              _drawerItem(
                icon: Icons.person_rounded,
                label: 'Profile',
                active: false,
                onTap: () => _navigateToScreen(const ProfileScreen()),
              ),
              _drawerItem(
                icon: Icons.settings_rounded,
                label: 'Settings',
                active: false,
                onTap: _closeDrawer,
              ),

              const Spacer(),
              const Divider(color: Colors.white10, height: 1),

              // ── Logout ─────────────────────────────────────────────────────
              _drawerItem(
                icon: Icons.logout_rounded,
                label: 'Logout',
                active: false,
                color: Colors.redAccent,
                onTap: () {
                  _closeDrawer();
                  Future.delayed(const Duration(milliseconds: 300), () {
                    if (mounted) _showLogoutDialog();
                  });
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _drawerItem({
    required IconData icon,
    required String label,
    required bool active,
    required VoidCallback onTap,
    Color? color,
  }) {
    final c = color ?? (active ? const Color(0xFFC4963D) : Colors.white70);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: active
              ? const Color(0xFFC4963D).withOpacity(0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(icon, color: c, size: 22),
            const SizedBox(width: 14),
            Text(
              label,
              style: TextStyle(
                color: c,
                fontSize: 15,
                fontWeight: active ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
            if (active) ...[
              const Spacer(),
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Color(0xFFC4963D),
                  shape: BoxShape.circle,
                ),
              ),
            ] else ...[
              const Spacer(),
              const Icon(
                Icons.chevron_right_rounded,
                color: Colors.white12,
                size: 18,
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ── TOP BAR ─────────────────────────────────────────────────────────────────
  Widget _buildTopBar() {
    return Container(
      color: const Color(0xFF1A1A1A),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 16,
        right: 16,
        bottom: 8,
      ),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Station Near You',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
              ),
            ),
          ),
          GestureDetector(
            onTap: _toggleDrawer,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _drawerOpen
                    ? const Color(0xFFC4963D).withOpacity(0.2)
                    : const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(12),
                border: _drawerOpen
                    ? Border.all(
                        color: const Color(0xFFC4963D).withOpacity(0.6),
                        width: 1.5,
                      )
                    : null,
              ),
              child: Icon(
                _drawerOpen ? Icons.close_rounded : Icons.tune_rounded,
                color: const Color(0xFFC4963D),
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── SEARCH BAR ──────────────────────────────────────────────────────────────
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Row(
          children: [
            const SizedBox(width: 12),
            const Icon(Icons.search_rounded, color: Color(0xFF888888), size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                cursorColor: const Color(0xFFC4963D),
                decoration: const InputDecoration(
                  hintText: 'Find a fuel station near you',
                  hintStyle: TextStyle(color: Color(0xFF666666), fontSize: 14),
                  border: InputBorder.none,
                  isCollapsed: true,
                ),
                textInputAction: TextInputAction.search,
                onSubmitted: (_) => FocusScope.of(context).unfocus(),
              ),
            ),
            if (_searchController.text.isNotEmpty)
              GestureDetector(
                onTap: _clearSearch,
                child: Container(
                  margin: const EdgeInsets.all(6),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(Icons.clear_rounded,
                      color: Color(0xFF888888), size: 14),
                ),
              )
            else
              Container(
                margin: const EdgeInsets.all(6),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFC4963D),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.my_location_rounded,
                    color: Colors.white, size: 16),
              ),
          ],
        ),
      ),
    );
  }

 Widget _buildMap() {
  return LayoutBuilder(
    builder: (context, constraints) {
      return SizedBox(
        width: constraints.maxWidth,
        height: constraints.maxHeight,
        child: Image.asset(
          'assets/images/map.png',
          fit: BoxFit.cover,
          alignment: const Alignment(0.5, -0.5), // 👈 horizontal + vertical control

          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: const Color(0xFF1A1A1A),
              child: const Center(
                child: Text(
                  'Map Image Missing',
                  style: TextStyle(color: Colors.white54),
                ),
              ),
            );
          },
        ),
      );
    },
  );
}
  // ── FUEL TYPE SECTION ───────────────────────────────────────────────────────
  Widget _buildFuelTypeSection() {
    return Container(
      color: const Color(0xFF1A1A1A),
      padding: const EdgeInsets.only(top: 12, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Text(
                  'Fuel Types',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {},
                  child: const Text(
                    'See all',
                    style: TextStyle(
                      color: Color(0xFFC4963D),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: kFuelTypes.length,
              itemBuilder: (context, index) {
                final fuelType = kFuelTypes[index];
                return Container(
                  width: 100,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: fuelType.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: fuelType.color.withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(fuelType.icon,
                          style: const TextStyle(fontSize: 32)),
                      const SizedBox(height: 8),
                      Text(
                        fuelType.name,
                        style: TextStyle(
                          color: fuelType.color,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ── NEARBY SECTION ──────────────────────────────────────────────────────────
  Widget _buildNearbySection() {
    if (_isSearching && _filteredStations.isEmpty) {
      return Container(
        color: const Color(0xFF1A1A1A),
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(Icons.search_off_rounded,
                color: Color(0xFF666666), size: 48),
            const SizedBox(height: 12),
            const Text(
              'No stations found',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Try searching for "${_searchController.text}"',
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _clearSearch,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC4963D),
                foregroundColor: Colors.white,
              ),
              child: const Text('Clear Search'),
            ),
          ],
        ),
      );
    }

    return Container(
      color: const Color(0xFF1A1A1A),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                Text(
                  _isSearching ? 'Search Results' : 'Nearby Petrol Stations',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                if (!_isSearching)
                  GestureDetector(
                    onTap: () {},
                    child: const Text(
                      'See all',
                      style: TextStyle(
                        color: Color(0xFFC4963D),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    
                  ),
            
            ],
          )
          ),
          
          SizedBox(
            height: 160,
            child: Listener(
              onPointerDown: (_) => _userTouching = true,
              onPointerUp:    (_) => _onPointerUp(),
              onPointerCancel: (_) => _onPointerUp(),
              child: ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                physics: _isSearching
                    ? const BouncingScrollPhysics()
                    : const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.only(left: 16, right: 4, bottom: 2),
                itemCount: _isSearching
                    ? _filteredStations.length
                    : _filteredStations.length * 200,
                itemBuilder: (context, index) {
                  final station = _isSearching
                      ? _filteredStations[index]
                      : _filteredStations[index % _filteredStations.length];
                  final isActive = _activeStationId == station.id;
                  return GestureDetector(
                    onTapDown: (_) => _onPointerDown(station),
                    onTapUp:   (_) => _onPointerUp(),
                    onTapCancel: () => _onPointerUp(),
                    child: _buildStationCard(station, isActive),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  // ── STATION CARD ─────────────────────────────────────────────────────────────
  Widget _buildStationCard(FuelStation station, bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: _cardWidth,
      margin: const EdgeInsets.only(right: _cardGap),
      decoration: BoxDecoration(
        color: const Color(0xFF252525),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isActive
              ? const Color(0xFFC4963D)
              : Colors.white.withOpacity(0.07),
          width: isActive ? 2.0 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: isActive
                ? const Color(0xFFC4963D).withOpacity(0.30)
                : Colors.black.withOpacity(0.40),
            blurRadius: isActive ? 20 : 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft:    Radius.circular(16),
              bottomLeft: Radius.circular(16),
            ),
            child: Image.asset(
              station.imageUrl,
              width:  108,
              height: 160,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 108,
                color: const Color(0xFF333333),
                child: const Icon(Icons.local_gas_station,
                    color: Color(0xFFC4963D), size: 36),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment:  MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        _premiumSlideRoute(StationDetailScreen(station: station)),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: station.isOpen
                            ? const Color(0xFF1A4A1A)
                            : const Color(0xFF4A1A1A),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6, height: 6,
                            decoration: BoxDecoration(
                              color: station.isOpen
                                  ? const Color(0xFF1A4A1A)
                                  : const Color(0xFF1A4A1A),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            station.isOpen ? 'Open' : 'Closed',
                            style: TextStyle(
                              color: station.isOpen
                                  ? const Color(0xFF1A4A1A)
                                  : const Color(0xFF1A4A1A),
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    station.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    station.address,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 11,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded,
                          color: Color(0xFFC4963D), size: 14),
                      const SizedBox(width: 3),
                      Text(
                        station.rating.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        ' (${station.reviewCount})',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.4),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.location_on_rounded,
                          color: Color(0xFFC4963D), size: 13),
                      const SizedBox(width: 2),
                      Text(
                        station.distance,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 11,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFC4963D).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: const Color(0xFFC4963D).withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          station.pricePerLitre,
                          style: const TextStyle(
                            color: Color(0xFFC4963D),
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── BOTTOM NAV ───────────────────────────────────────────────────────────────
  Widget _buildBottomNav() {
    final items = [
      (Icons.local_gas_station_rounded, 'Stations'),
      (Icons.support_agent_rounded,     'Support'),
      (Icons.shopping_bag_rounded,      'Orders'),
      (Icons.person_rounded,            'Profile'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.08)),
        ),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom + 4,
        top: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (i) {
          final selected = _selectedNav == i;
          return GestureDetector(
            onTap: () {
              setState(() => _selectedNav = i);
              if (i == 1) {
                Navigator.push(
                  context,
                  _premiumSlideRoute(const SupportScreen()),
                ).then((_) => setState(() => _selectedNav = 0));
              } else if (i == 2) {
                Navigator.push(
                  context,
                  _premiumSlideRoute(const OrderScreen()),
                ).then((_) => setState(() => _selectedNav = 0));
              } else if (i == 3) {
                Navigator.push(
                  context,
                  _premiumSlideRoute(const ProfileScreen()),
                ).then((_) => setState(() => _selectedNav = 0));
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFFC4963D).withOpacity(0.12)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    items[i].$1,
                    color: selected
                        ? const Color(0xFFC4963D)
                        : Colors.white.withOpacity(0.4),
                    size: 24,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    items[i].$2,
                    style: TextStyle(
                      color: selected
                          ? const Color(0xFFC4963D)
                          : Colors.white.withOpacity(0.4),
                      fontSize: 10,
                      fontWeight:
                          selected ? FontWeight.w700 : FontWeight.w400,
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