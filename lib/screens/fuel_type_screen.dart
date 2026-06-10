import 'package:flutter/material.dart';
import '/payment/payment_screen.dart';

class FuelTypeScreen extends StatefulWidget {
  final String stationName;
  final String stationAddress;
  final List<String> fuelTypes;

  const FuelTypeScreen({
    super.key,
    this.stationName = 'Shell Ntinda',
    this.stationAddress = 'Ntinda Road, Kampala',
    this.fuelTypes = const ['Petrol 95', 'Diesel', 'Kerosene'],
  });

  @override
  State<FuelTypeScreen> createState() => _FuelTypeScreenState();
}

class _FuelTypeScreenState extends State<FuelTypeScreen> {
  late String _selectedFuel;
  int _quantity = 20; // litres

  // New order config state variables
  late TextEditingController _locationController;
  late TextEditingController _vehicleModelController;
  late TextEditingController _licensePlateController;
  bool _deliverNow = true;
  DateTime? _scheduledDateTime;

  // Simulated price map (UGX per litre)
  static const Map<String, double> _fuelPrices = {
    'Petrol 95':  4850,
    'Diesel':     4650,
    'Premium':    5100,
    'Kerosene':   3900,
    'Fuel':       4850,
    'Diesel / Petrol': 4750,
  };

  double get _pricePerLitre =>
      _fuelPrices[_selectedFuel] ?? 4850.0;
  double get _fuelTotal  => _pricePerLitre * _quantity;
  double get _deliveryFee => 5000.0;
  double get _gst         => _deliveryFee * 0.10;
  double get _total       => _fuelTotal + _deliveryFee + _gst;

  String _ugx(double v) =>
      'UGX ${v.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}';

  @override
  void initState() {
    super.initState();
    _selectedFuel = widget.fuelTypes.isNotEmpty
        ? widget.fuelTypes.first
        : 'Petrol 95';

    // Initialize delivery inputs
    _locationController = TextEditingController(text: widget.stationAddress);
    _vehicleModelController = TextEditingController(text: 'Toyota Corolla (Blue)');
    _licensePlateController = TextEditingController(text: 'UAS 452G');
  }

  @override
  void dispose() {
    _locationController.dispose();
    _vehicleModelController.dispose();
    _licensePlateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D0D),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: Color(0xFFC4963D), size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Confirm Order',
          style: TextStyle(
            color: Color(0xFFC4963D),
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Station Card ──────────────────────────────────────────────
            _sectionCard(
              header: 'FUEL STATION',
              headerIcon: Icons.local_gas_station_rounded,
              child: Row(
                children: [
                  Container(
                    width: 44, height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4CAF50).withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.local_gas_station_rounded,
                        color: Color(0xFF4CAF50), size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.stationName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (widget.stationAddress.isNotEmpty) ...[
                          const SizedBox(height: 3),
                          Text(
                            widget.stationAddress,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // ── Fuel Type Selector ────────────────────────────────────────
            _sectionCard(
              header: 'SELECT FUEL TYPE',
              headerIcon: Icons.oil_barrel_outlined,
              child: Column(
                children: widget.fuelTypes.isEmpty
                    ? ['Petrol 95', 'Diesel', 'Kerosene']
                        .map((f) => _fuelTile(f))
                        .toList()
                    : widget.fuelTypes.map((f) => _fuelTile(f)).toList(),
              ),
            ),
            const SizedBox(height: 14),

            // ── Quantity Stepper ──────────────────────────────────────────
            _sectionCard(
              header: 'QUANTITY',
              headerIcon: Icons.scale_outlined,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Litres',
                      style: TextStyle(
                          color: Colors.white70, fontSize: 14)),
                  Row(
                    children: [
                      _stepBtn(Icons.remove, () {
                        if (_quantity > 1) setState(() => _quantity--);
                      }),
                      const SizedBox(width: 16),
                      Text(
                        '$_quantity L',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 16),
                      _stepBtn(Icons.add, () {
                        if (_quantity < 200) setState(() => _quantity++);
                      }),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),

            // ── Delivery Location ─────────────────────────────────────────
            _sectionCard(
              header: 'DELIVERY LOCATION',
              headerIcon: Icons.location_on_rounded,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _locationController,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'Enter specific delivery spot (e.g. Parking Lot B)',
                      hintStyle: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 13),
                      filled: true,
                      fillColor: const Color(0xFF1E1E1E),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFC4963D)),
                      ),
                      prefixIcon: const Icon(Icons.my_location, color: Color(0xFFC4963D), size: 16),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // ── Delivery Time ─────────────────────────────────────────────
            _sectionCard(
              header: 'DELIVERY TIME',
              headerIcon: Icons.access_time_filled_rounded,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _deliverNow = true),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: _deliverNow
                                  ? const Color(0xFFC4963D).withOpacity(0.12)
                                  : const Color(0xFF252525),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: _deliverNow
                                    ? const Color(0xFFC4963D)
                                    : Colors.white.withOpacity(0.08),
                                width: _deliverNow ? 1.5 : 1.0,
                              ),
                            ),
                            child: const Column(
                              children: [
                                Icon(Icons.bolt, color: Color(0xFFC4963D), size: 18),
                                SizedBox(height: 4),
                                Text(
                                  'Deliver Now',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Within 30 mins',
                                  style: TextStyle(
                                    color: Colors.white38,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            setState(() => _deliverNow = false);
                            final date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(const Duration(days: 7)),
                              builder: (context, child) => Theme(
                                data: ThemeData.dark().copyWith(
                                  colorScheme: const ColorScheme.dark(
                                    primary: Color(0xFFC4963D),
                                    onPrimary: Colors.black,
                                    surface: Color(0xFF1A1A1A),
                                    onSurface: Colors.white,
                                  ),
                                ),
                                child: child!,
                              ),
                            );
                            if (date != null && mounted) {
                              final time = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                                builder: (context, child) => Theme(
                                  data: ThemeData.dark().copyWith(
                                    colorScheme: const ColorScheme.dark(
                                      primary: Color(0xFFC4963D),
                                      onPrimary: Colors.black,
                                      surface: Color(0xFF1A1A1A),
                                      onSurface: Colors.white,
                                    ),
                                  ),
                                  child: child!,
                                ),
                              );
                              if (time != null) {
                                setState(() {
                                  _scheduledDateTime = DateTime(
                                    date.year,
                                    date.month,
                                    date.day,
                                    time.hour,
                                    time.minute,
                                  );
                                });
                              }
                            }
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: !_deliverNow
                                  ? const Color(0xFFC4963D).withOpacity(0.12)
                                  : const Color(0xFF252525),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: !_deliverNow
                                    ? const Color(0xFFC4963D)
                                    : Colors.white.withOpacity(0.08),
                                width: !_deliverNow ? 1.5 : 1.0,
                              ),
                            ),
                            child: Column(
                              children: [
                                const Icon(Icons.calendar_month, color: Color(0xFFC4963D), size: 18),
                                const SizedBox(height: 4),
                                const Text(
                                  'Schedule Later',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _scheduledDateTime == null
                                      ? 'Select Time'
                                      : () {
                                          final h = _scheduledDateTime!.hour.toString().padLeft(2, '0');
                                          final m = _scheduledDateTime!.minute.toString().padLeft(2, '0');
                                          return '${_scheduledDateTime!.day}/${_scheduledDateTime!.month} @ $h:$m';
                                        }(),
                                  style: TextStyle(
                                    color: _scheduledDateTime == null ? Colors.white38 : const Color(0xFFC4963D),
                                    fontSize: 10,
                                    fontWeight: _scheduledDateTime != null ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // ── Vehicle Details ───────────────────────────────────────────
            _sectionCard(
              header: 'VEHICLE FOR DELIVERY',
              headerIcon: Icons.directions_car_filled_rounded,
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextField(
                      controller: _vehicleModelController,
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                      decoration: InputDecoration(
                        labelText: 'Model & Color',
                        labelStyle: const TextStyle(color: Colors.white38, fontSize: 11),
                        filled: true,
                        fillColor: const Color(0xFF1E1E1E),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Color(0xFFC4963D)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: _licensePlateController,
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                      decoration: InputDecoration(
                        labelText: 'License Plate',
                        labelStyle: const TextStyle(color: Colors.white38, fontSize: 11),
                        filled: true,
                        fillColor: const Color(0xFF1E1E1E),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Color(0xFFC4963D)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),

            // ── Payment Summary ───────────────────────────────────────────
            const Text(
              'Payment Summary',
              style: TextStyle(
                color: Color(0xFFC4963D),
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: const Color(0xFFC4963D).withOpacity(0.15)),
              ),
              child: Column(
                children: [
                  _payRow('$_selectedFuel × $_quantity L',
                      _ugx(_fuelTotal)),
                  const SizedBox(height: 10),
                  _payRow('Delivery Fee', _ugx(_deliveryFee)),
                  const SizedBox(height: 10),
                  _payRow('Tax (10%)', _ugx(_gst)),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(
                        color: Color(0xFFC4963D), height: 1),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('TOTAL',
                          style: TextStyle(
                              color: Color(0xFFC4963D),
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.8)),
                      Text(
                        _ugx(_total),
                        style: const TextStyle(
                          color: Color(0xFFC4963D),
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── Proceed to Payment ────────────────────────────────────────
            ElevatedButton.icon(
              onPressed: () {
                final deliveryTimeStr = _deliverNow
                    ? 'Deliver Now (Within 30 mins)'
                    : (_scheduledDateTime == null
                        ? 'Scheduled (Later)'
                        : () {
                            final h = _scheduledDateTime!.hour.toString().padLeft(2, '0');
                            final m = _scheduledDateTime!.minute.toString().padLeft(2, '0');
                            return 'Scheduled: ${_scheduledDateTime!.day}/${_scheduledDateTime!.month}/${_scheduledDateTime!.year} @ $h:$m';
                          }());
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PaymentScreen(
                      stationName: widget.stationName,
                      fuelType: _selectedFuel,
                      quantityLitres: _quantity,
                      totalAmount: _total,
                      deliveryLocation: _locationController.text.trim().isEmpty
                          ? widget.stationAddress
                          : _locationController.text.trim(),
                      deliveryTime: deliveryTimeStr,
                      vehicleModel: _vehicleModelController.text.trim(),
                      licensePlate: _licensePlateController.text.trim(),
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.lock_outline,
                  size: 18, color: Colors.white),
              label: const Text(
                'Proceed to Payment',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC4963D),
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _fuelTile(String fuel) {
    final selected = _selectedFuel == fuel;
    final price = _fuelPrices[fuel] ?? 4850.0;
    return GestureDetector(
      onTap: () => setState(() => _selectedFuel = fuel),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFFC4963D).withOpacity(0.12)
              : const Color(0xFF252525),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? const Color(0xFFC4963D)
                : Colors.white.withOpacity(0.08),
            width: selected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Text('⛽',
                style: TextStyle(
                    fontSize: selected ? 20 : 16)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                fuel,
                style: TextStyle(
                  color: selected
                      ? const Color(0xFFC4963D)
                      : Colors.white,
                  fontSize: 14,
                  fontWeight: selected
                      ? FontWeight.w700
                      : FontWeight.w500,
                ),
              ),
            ),
            Text(
              'UGX ${price.toStringAsFixed(0)}/L',
              style: TextStyle(
                color: selected
                    ? const Color(0xFFC4963D)
                    : Colors.white38,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 18, height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected
                      ? const Color(0xFFC4963D)
                      : Colors.white24,
                  width: 2,
                ),
                color: selected
                    ? const Color(0xFFC4963D)
                    : Colors.transparent,
              ),
              child: selected
                  ? const Icon(Icons.check,
                      color: Colors.white, size: 11)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionCard({
    required String header,
    required IconData headerIcon,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: const Color(0xFFC4963D).withOpacity(0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(headerIcon,
                  color: const Color(0xFFC4963D), size: 15),
              const SizedBox(width: 6),
              Text(header,
                  style: const TextStyle(
                      color: Color(0xFF888888),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2)),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _stepBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36, height: 36,
        decoration: BoxDecoration(
          color: const Color(0xFF252525),
          shape: BoxShape.circle,
          border: Border.all(
              color: const Color(0xFFC4963D).withOpacity(0.35)),
        ),
        child:
            Icon(icon, color: const Color(0xFFC4963D), size: 18),
      ),
    );
  }

  Widget _payRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(
                color: Colors.white60, fontSize: 13)),
        Text(value,
            style: const TextStyle(
                color: Colors.white, fontSize: 13,
                fontWeight: FontWeight.w600)),
      ],
    );
  }
}