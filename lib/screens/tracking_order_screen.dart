import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'home_screen.dart';

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
    this.stationName = 'Shell Ntinda',
    this.deliveryLocation = 'Ntinda, Kampala',
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
  // Shell Ntinda area coordinates in Kampala
  final LatLng _stationLocation = const LatLng(0.3532, 32.5985); 
  // Target center area coordinates in Kampala
  final LatLng _deliveryLocation = const LatLng(0.3422, 32.5855); 

  List<LatLng> _routePoints = [];
  LatLng? _driverLocation;
  int _currentPathIndex = 0;
  Timer? _simulationTimer;
  String _timelineStatus = "Preparing Fuel";
  double _etaMinutes = 15.0;

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
    // Generate 30 linear interpolation steps between station and customer location
    const steps = 30;
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
          // Decrease ETA from 15 minutes down to 0
          final remainingFraction = 1.0 - (_currentPathIndex / (_routePoints.length - 1));
          _etaMinutes = remainingFraction * 15;
          if (_currentPathIndex < 6) {
            _timelineStatus = "Preparing Fuel";
          } else {
            _timelineStatus = "On the Way";
          }
        } else {
          _timelineStatus = "Delivered";
          _etaMinutes = 0;
          _simulationTimer?.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 16),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
              (route) => false,
            );
          },
        ),
        title: const Text(
          "TRACK DELIVERY",
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Live Map Container ──────────────────────────────────────────
            Container(
              height: 250,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.08)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: LatLng(
                      (_stationLocation.latitude + _deliveryLocation.latitude) / 2,
                      (_stationLocation.longitude + _deliveryLocation.longitude) / 2,
                    ),
                    initialZoom: 13.8,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',
                      subdomains: const ['a', 'b', 'c', 'd'],
                      userAgentPackageName: 'com.fuelconnect.app',
                    ),
                    PolylineLayer(
                      polylines: [
                        Polyline(
                          points: _routePoints,
                          color: const Color(0xFFC4963D),
                          strokeWidth: 4,
                        ),
                      ],
                    ),
                    MarkerLayer(
                      markers: [
                        // Station Marker (Red Gas Pump)
                        Marker(
                          width: 36,
                          height: 36,
                          point: _stationLocation,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.redAccent,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.local_gas_station_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                        // Delivery Location Marker (Blue Home/Vehicle)
                        Marker(
                          width: 36,
                          height: 36,
                          point: _deliveryLocation,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.blueAccent,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.location_on_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                        // Moving Truck Marker
                        if (_driverLocation != null)
                          Marker(
                            width: 38,
                            height: 38,
                            point: _driverLocation!,
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Color(0xFFC4963D),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black38,
                                    blurRadius: 6,
                                    spreadRadius: 1,
                                  )
                                ],
                              ),
                              child: const Icon(
                                Icons.local_shipping_rounded,
                                color: Colors.black,
                                size: 20,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ── ETA & Status Banner ─────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFC4963D).withOpacity(0.12)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44, height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFC4963D).withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.timer_outlined, color: Color(0xFFC4963D), size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _etaMinutes > 0
                              ? 'ETA: ${_etaMinutes.toStringAsFixed(0)} Mins'
                              : 'Arrived & Delivered!',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          _timelineStatus == "Preparing Fuel"
                              ? 'Filling fuel at ${widget.stationName}'
                              : (_timelineStatus == "On the Way"
                                  ? 'Driver in transit to delivery location'
                                  : 'Tank replenished successfully!'),
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.4),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Delivery Driver Info ───────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44, height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2C2C2E),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.person, color: Color(0xFFC4963D), size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Delivery Agent",
                          style: TextStyle(color: Colors.white38, fontSize: 11),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          "Rajesh Kumar",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "Vehicle: Fuel Truck (${widget.licensePlate})",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Calling Rajesh Kumar (+256 70x xxx xxx)...')),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFC4963D).withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.call, color: Color(0xFFC4963D), size: 18),
                    ),
                  ),
                ],
              ),
            ),

            // ── Order Details Card ──────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "DELIVERY SPECIFICATIONS",
                    style: TextStyle(
                      color: Color(0xFFC4963D),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _specRow("Fuel Type", widget.fuelType),
                  _specRow("Quantity", "${widget.quantityLitres} Litres"),
                  _specRow("Vehicle", widget.vehicleModel),
                  _specRow("Address", widget.deliveryLocation),
                  _specRow("Selected Time", widget.deliveryTime),
                ],
              ),
            ),

            // ── Status Timeline ─────────────────────────────────────────────
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                "Order Timeline",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildTimelineItem(
              title: "Order Placed",
              description: "We have received your fuel request.",
              time: "Just now",
              isPassed: true,
              isActive: false,
              isLast: false,
            ),
            _buildTimelineItem(
              title: "Preparing Fuel",
              description: "The agent is filling fuel at ${widget.stationName}.",
              time: _timelineStatus == "Preparing Fuel" ? "In Progress" : "Done",
              isPassed: _timelineStatus != "Preparing Fuel",
              isActive: _timelineStatus == "Preparing Fuel",
              isLast: false,
            ),
            _buildTimelineItem(
              title: "Shipped / On the Way",
              description: "The fuel truck is in transit to your vehicle.",
              time: _timelineStatus == "On the Way" ? "In Progress" : (_timelineStatus == "Delivered" ? "Done" : "Pending"),
              isPassed: _timelineStatus == "Delivered",
              isActive: _timelineStatus == "On the Way",
              isLast: false,
            ),
            _buildTimelineItem(
              title: "Delivered",
              description: "Tank replenished and order completed.",
              time: _timelineStatus == "Delivered" ? "Completed" : "Pending",
              isPassed: _timelineStatus == "Delivered",
              isActive: _timelineStatus == "Delivered",
              isLast: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _specRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 12),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem({
    required String title,
    required String description,
    required String time,
    required bool isPassed,
    required bool isActive,
    required bool isLast,
  }) {
    final Color indicatorColor = isActive
        ? const Color(0xFFC4963D)
        : (isPassed ? const Color(0xFF4CAF50) : const Color(0xFF3A3A3C));
    return SizedBox(
      height: 90,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 30,
            child: Column(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: indicatorColor,
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                              color: const Color(0xFFC4963D).withOpacity(0.4),
                              spreadRadius: 2,
                              blurRadius: 5,
                            )
                          ]
                        : null,
                  ),
                  child: Center(
                    child: isActive
                        ? const SizedBox(
                            width: 10,
                            height: 10,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : (isPassed
                            ? const Icon(Icons.check, color: Colors.white, size: 12)
                            : null),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: 2,
                    color: isLast
                        ? Colors.transparent
                        : (isPassed ? const Color(0xFF4CAF50) : const Color(0xFF3A3A3C)),
                    margin: const EdgeInsets.only(top: 4),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isActive || isPassed ? FontWeight.bold : FontWeight.normal,
                    color: isActive ? const Color(0xFFC4963D) : (isPassed ? Colors.white : Colors.white30),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: isPassed || isActive ? Colors.white60 : Colors.white24,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 10,
                    color: isActive ? const Color(0xFFC4963D) : (isPassed ? const Color(0xFF4CAF50) : Colors.white24),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}