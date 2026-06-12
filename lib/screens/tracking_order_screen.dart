import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'home_screen.dart';
import '../auth/theme.dart';
import '../widgets/theme_toggle_button.dart';

class TrackOrderScreen extends StatefulWidget {
  final String stationName;
  final String deliveryLocation;
  final String deliveryTime;
  final String vehicleModel;
  final String licensePlate;
  final String fuelType;
  final int quantityLitres;
  final double totalAmount;

  const TrackOrderScreen({
    super.key,
    this.stationName = 'Pilot Travel Centers LLC',
    this.deliveryLocation = '5508 Lonas Drive, Knoxville, TN 37909',
    this.deliveryTime = 'Deliver Now',
    this.vehicleModel = 'Toyota Corolla',
    this.licensePlate = 'UAS 452G',
    this.fuelType = 'Petrol 95',
    this.quantityLitres = 20,
    this.totalAmount = 100000.0,
  });

  @override
  State<TrackOrderScreen> createState() => _TrackOrderScreenState();
}

class _TrackOrderScreenState extends State<TrackOrderScreen> {
  // Coordinates based on screenshot layout (arbitrary for simulation)
  final LatLng _stationLocation = const LatLng(0.3532, 32.5985); 
  final LatLng _deliveryLocation = const LatLng(0.3422, 32.5855); 

  List<LatLng> _routePoints = [];
  LatLng? _driverLocation;
  int _currentPathIndex = 0;
  Timer? _simulationTimer;
  double _etaMinutes = 8.0;
  double _distanceKm = 4.9;

  @override
  void initState() {
    super.initState();
    _generateRoutePoints();
    _startTrackingSimulation();
  }

  @override
  void dispose() {
    _simulationTimer?.cancel();
    super.dispose();
  }

  void _generateRoutePoints() {
    const steps = 40;
    for (int i = 0; i <= steps; i++) {
      final t = i / steps;
      final lat = _stationLocation.latitude + t * (_deliveryLocation.latitude - _stationLocation.latitude);
      final lng = _stationLocation.longitude + t * (_deliveryLocation.longitude - _stationLocation.longitude);
      _routePoints.add(LatLng(lat, lng));
    }
    _driverLocation = _routePoints.first;
  }

  void _startTrackingSimulation() {
    _simulationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_currentPathIndex < _routePoints.length - 1) {
          _currentPathIndex++;
          _driverLocation = _routePoints[_currentPathIndex];
          
          final remainingFraction = 1.0 - (_currentPathIndex / (_routePoints.length - 1));
          _etaMinutes = remainingFraction * 8;
          _distanceKm = remainingFraction * 4.9;
        } else {
          _etaMinutes = 0;
          _distanceKm = 0;
          _simulationTimer?.cancel();
        }
      });
    });
  }

  void _endRoute() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          // ── Full Screen Live Map ──────────────────────────────────────────
          FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(
                (_stationLocation.latitude + _deliveryLocation.latitude) / 2,
                (_stationLocation.longitude + _deliveryLocation.longitude) / 2,
              ),
              initialZoom: 13.5,
            ),
            children: [
              TileLayer(
                urlTemplate: isDark 
                    ? 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png'
                    : 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',
                subdomains: const ['a', 'b', 'c', 'd'],
                userAgentPackageName: 'com.fuelconnect.app',
              ),
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: _routePoints,
                    color: AppTheme.gold, // Changed from green to gold
                    strokeWidth: 5,
                  ),
                ],
              ),
              MarkerLayer(
                markers: [
                  // Station Marker
                  Marker(
                    width: 50,
                    height: 50,
                    point: _stationLocation,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppTheme.gold.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Container(
                          width: 30, height: 30,
                          decoration: const BoxDecoration(
                            color: AppTheme.gold,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.local_gas_station, color: Colors.white, size: 16),
                        ),
                      ),
                    ),
                  ),
                  
                  // Moving Vehicle Marker
                  if (_driverLocation != null)
                    Marker(
                      width: 44,
                      height: 44,
                      point: _driverLocation!,
                      child: Transform.rotate(
                        angle: -0.5, // Arbitrary angle to simulate direction
                        child: Container(
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(color: Colors.black26, blurRadius: 8, spreadRadius: 1),
                            ],
                          ),
                          child: const Center(
                            child: Icon(Icons.directions_car, color: AppTheme.gold, size: 24),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),

          // ── Top Theme Toggle & Back Button ──────────────────────────────────────────
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: _endRoute,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
                    ),
                    child: Icon(Icons.arrow_back, color: isDark ? Colors.white : Colors.black),
                  ),
                ),
                const CustomThemeToggle(
                  iconColor: Colors.white,
                  bgColor: Colors.black26,
                ),
              ],
            ),
          ),

          // ── Top Floating Card ──────────────────────────────────────────
          Positioned(
            top: MediaQuery.of(context).padding.top + 76,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 5)),
                ],
              ),
              child: Row(
                children: [
                  // Icon
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppTheme.gold.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.local_gas_station, color: AppTheme.gold, size: 24),
                  ),
                  const SizedBox(width: 16),
                  
                  // Text Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.stationName,
                          style: TextStyle(
                            color: theme.textTheme.bodyLarge?.color,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.deliveryLocation,
                          style: TextStyle(
                            color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5),
                            fontSize: 11,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  
                  // ETA Info
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${_etaMinutes.toStringAsFixed(0)} min',
                        style: TextStyle(
                          color: theme.textTheme.bodyLarge?.color,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${_distanceKm.toStringAsFixed(1)} km',
                        style: TextStyle(
                          color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ── Bottom End Route Button ──────────────────────────────────────────
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 30,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                width: 200,
                height: 56,
                child: ElevatedButton(
                  onPressed: _endRoute,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.gold, // Gold instead of green
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 10,
                    shadowColor: AppTheme.gold.withOpacity(0.5),
                  ),
                  child: const Text(
                    'End Route',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}