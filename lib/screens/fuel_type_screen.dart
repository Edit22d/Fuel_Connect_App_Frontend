import 'package:flutter/material.dart';
import '/payment/confirm_order_screen.dart';
import 'package:fuel_app/auth/theme.dart';

class FuelTypeScreen extends StatefulWidget {
  final String stationName;
  final String stationAddress;
  final List<String> fuelTypes;

  const FuelTypeScreen({
    super.key,
    this.stationName = 'Aloha Petroleum, Ltd',
    this.stationAddress = '1001 Bishop St. Ste 130',
    this.fuelTypes = const ['Petrol 95', 'Diesel', 'Premium 98'],
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

  // Simulated price map
  static const Map<String, double> _fuelPrices = {
    'Petrol 95':  4.59,
    'Diesel':     4.89,
    'Premium 98': 5.19,
    'Kerosene':   3.90,
  };

  double get _pricePerLitre => _fuelPrices[_selectedFuel] ?? 4.59;
  double get _fuelTotal  => _pricePerLitre * _quantity;
  double get _deliveryFee => 5.00;
  double get _gst         => _deliveryFee * 0.10;
  double get _total       => _fuelTotal + _deliveryFee + _gst;

  String _formatCurrency(double v) => '\$${v.toStringAsFixed(2)}';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppTheme.darkBg : const Color(0xFFF4F4F6);
    final cardBg = isDark ? AppTheme.darkSurface : Colors.white;
    final textPrimary = isDark ? Colors.white : const Color(0xFF111111);
    final textSecondary = isDark ? AppTheme.darkTextSecondary : const Color(0xFF666666);
    final dividerColor = isDark ? AppTheme.darkBorder : const Color(0xFFE8E8E8);
    final inputFill = isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF8F8FA);
    final gold = AppTheme.gold;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: cardBg,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: Center(
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 36,
              height: 36,
              margin: const EdgeInsets.only(left: 8),
              decoration: BoxDecoration(
                color: cardBg,
                shape: BoxShape.circle,
                border: Border.all(color: dividerColor, width: 1.5),
              ),
              child: Icon(Icons.arrow_back, color: textPrimary, size: 16),
            ),
          ),
        ),
        centerTitle: true,
        title: Text(
          'Order Fuel',
          style: TextStyle(
            color: textPrimary,
            fontSize: 17,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
        actions: const [ThemeToggleButton()],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1, color: dividerColor),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Station Card ──────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(16),
                border: isDark ? Border.all(color: dividerColor) : null,
                boxShadow: [
                  if (!isDark)
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 48, height: 48,
                    decoration: BoxDecoration(
                      color: gold.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.local_gas_station_rounded, color: gold, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.stationName,
                          style: TextStyle(
                            color: textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (widget.stationAddress.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            widget.stationAddress,
                            style: TextStyle(
                              color: textSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── Fuel Type Selector ────────────────────────────────────────
            _sectionHeader('Select Fuel Type', textPrimary),
            const SizedBox(height: 12),
            Column(
              children: widget.fuelTypes.isEmpty
                  ? ['Petrol 95', 'Diesel', 'Premium 98']
                      .map((f) => _fuelTile(f, isDark, cardBg, textPrimary, textSecondary, dividerColor, gold))
                      .toList()
                  : widget.fuelTypes.map((f) => _fuelTile(f, isDark, cardBg, textPrimary, textSecondary, dividerColor, gold)).toList(),
            ),
            const SizedBox(height: 24),

            // ── Quantity Stepper ──────────────────────────────────────────
            _sectionHeader('Quantity (Litres)', textPrimary),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(16),
                border: isDark ? Border.all(color: dividerColor) : null,
                boxShadow: [
                  if (!isDark)
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 8,
                    ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Volume', style: TextStyle(color: textSecondary, fontSize: 16)),
                  Row(
                    children: [
                      _stepBtn(Icons.remove, isDark, textPrimary, () {
                        if (_quantity > 1) setState(() => _quantity--);
                      }),
                      Container(
                        width: 70,
                        alignment: Alignment.center,
                        child: Text(
                          '$_quantity L',
                          style: TextStyle(
                            color: textPrimary,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      _stepBtn(Icons.add, isDark, textPrimary, () {
                        if (_quantity < 200) setState(() => _quantity++);
                      }),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── Delivery Location ─────────────────────────────────────────
            _sectionHeader('Delivery Location', textPrimary),
            const SizedBox(height: 12),
            TextField(
              controller: _locationController,
              style: TextStyle(color: textPrimary, fontSize: 15),
              decoration: _inputDecoration(
                hint: 'Enter delivery spot',
                icon: Icons.my_location_rounded,
                isDark: isDark,
                fillColor: inputFill,
                dividerColor: dividerColor,
                gold: gold,
                textSecondary: textSecondary,
              ),
            ),
            const SizedBox(height: 24),

            // ── Delivery Time ─────────────────────────────────────────────
            _sectionHeader('Delivery Time', textPrimary),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _timeOptionCard(
                    title: 'Deliver Now',
                    subtitle: 'Within 30 mins',
                    icon: Icons.bolt_rounded,
                    isSelected: _deliverNow,
                    isDark: isDark,
                    cardBg: cardBg,
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                    dividerColor: dividerColor,
                    gold: gold,
                    onTap: () => setState(() => _deliverNow = true),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _timeOptionCard(
                    title: 'Schedule',
                    subtitle: _scheduledDateTime == null
                        ? 'Select Time'
                        : '${_scheduledDateTime!.month}/${_scheduledDateTime!.day} ${_scheduledDateTime!.hour.toString().padLeft(2, '0')}:${_scheduledDateTime!.minute.toString().padLeft(2, '0')}',
                    icon: Icons.calendar_month_rounded,
                    isSelected: !_deliverNow,
                    isDark: isDark,
                    cardBg: cardBg,
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                    dividerColor: dividerColor,
                    gold: gold,
                    onTap: () async {
                      setState(() => _deliverNow = false);
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 7)),
                        builder: (context, child) => Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ColorScheme.light(
                              primary: gold,
                              onPrimary: Colors.white,
                              onSurface: isDark ? Colors.white : Colors.black,
                              surface: isDark ? const Color(0xFF1A1A1A) : Colors.white,
                            ),
                            textButtonTheme: TextButtonThemeData(
                              style: TextButton.styleFrom(foregroundColor: gold),
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
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                primary: gold,
                                onPrimary: Colors.white,
                                onSurface: isDark ? Colors.white : Colors.black,
                                surface: isDark ? const Color(0xFF1A1A1A) : Colors.white,
                              ),
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(foregroundColor: gold),
                              ),
                            ),
                            child: child!,
                          ),
                        );
                        if (time != null && mounted) {
                          setState(() {
                            _scheduledDateTime = DateTime(
                              date.year, date.month, date.day, time.hour, time.minute,
                            );
                          });
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ── Vehicle Details ───────────────────────────────────────────
            _sectionHeader('Vehicle for Delivery', textPrimary),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: _vehicleModelController,
                    style: TextStyle(color: textPrimary, fontSize: 15),
                    decoration: _inputDecoration(
                      hint: 'Model & Color',
                      isDark: isDark,
                      fillColor: inputFill,
                      dividerColor: dividerColor,
                      gold: gold,
                      textSecondary: textSecondary,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _licensePlateController,
                    style: TextStyle(color: textPrimary, fontSize: 15),
                    decoration: _inputDecoration(
                      hint: 'License Plate',
                      isDark: isDark,
                      fillColor: inputFill,
                      dividerColor: dividerColor,
                      gold: gold,
                      textSecondary: textSecondary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // ── Payment Summary ───────────────────────────────────────────
            _sectionHeader('Payment Summary', textPrimary),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(16),
                border: isDark ? Border.all(color: dividerColor) : null,
                boxShadow: [
                  if (!isDark)
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                    ),
                ],
              ),
              child: Column(
                children: [
                  _payRow('$_selectedFuel × $_quantity L', _formatCurrency(_fuelTotal), textSecondary, textPrimary),
                  const SizedBox(height: 12),
                  _payRow('Delivery Fee', _formatCurrency(_deliveryFee), textSecondary, textPrimary),
                  const SizedBox(height: 12),
                  _payRow('Tax (10%)', _formatCurrency(_gst), textSecondary, textPrimary),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Divider(color: dividerColor, height: 1),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Amount',
                        style: TextStyle(
                          color: textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        _formatCurrency(_total),
                        style: TextStyle(
                          color: gold,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // ── Proceed to Confirm Order ──────────────────────────────────
            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ConfirmOrderScreen(
                        stationName: widget.stationName,
                        fuelType: _selectedFuel,
                        quantityLitres: _quantity,
                        totalAmount: _total,
                        deliveryLocation: _locationController.text.trim().isEmpty
                            ? widget.stationAddress
                            : _locationController.text.trim(),
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: gold,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text(
                  'Confirm Order',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, Color textPrimary) {
    return Text(
      title,
      style: TextStyle(
        color: textPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    IconData? icon,
    required bool isDark,
    required Color fillColor,
    required Color dividerColor,
    required Color gold,
    required Color textSecondary,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: textSecondary.withValues(alpha: 0.6), fontSize: 15),
      filled: true,
      fillColor: fillColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      prefixIcon: icon != null ? Icon(icon, color: gold, size: 20) : null,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: dividerColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: dividerColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: gold, width: 1.5),
      ),
    );
  }

  Widget _timeOptionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required bool isDark,
    required Color cardBg,
    required Color textPrimary,
    required Color textSecondary,
    required Color dividerColor,
    required Color gold,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? gold.withValues(alpha: 0.08) : cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? gold : dividerColor,
            width: isSelected ? 1.5 : 1.0,
          ),
          boxShadow: [
            if (!isDark && !isSelected)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 6,
              ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? gold : textSecondary, size: 24),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? textPrimary : textSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                color: isSelected ? gold : textSecondary,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _fuelTile(
    String fuel,
    bool isDark,
    Color cardBg,
    Color textPrimary,
    Color textSecondary,
    Color dividerColor,
    Color gold,
  ) {
    final selected = _selectedFuel == fuel;
    final price = _fuelPrices[fuel] ?? 4.59;
    return GestureDetector(
      onTap: () => setState(() => _selectedFuel = fuel),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? gold.withValues(alpha: 0.08) : cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? gold : dividerColor,
            width: selected ? 1.5 : 1.0,
          ),
          boxShadow: [
            if (!isDark && !selected)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 6,
              ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: selected ? gold : (isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF2F2F5)),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.water_drop_rounded,
                color: selected ? Colors.white : textSecondary,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fuel,
                    style: TextStyle(
                      color: textPrimary,
                      fontSize: 16,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${price.toStringAsFixed(2)}/gal',
                    style: TextStyle(
                      color: textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 22, height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? gold : textSecondary.withValues(alpha: 0.4),
                  width: 2,
                ),
                color: selected ? gold : Colors.transparent,
              ),
              child: selected ? const Icon(Icons.check, color: Colors.white, size: 14) : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _stepBtn(IconData icon, bool isDark, Color textPrimary, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44, height: 44,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF0F0F2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: textPrimary, size: 20),
      ),
    );
  }

  Widget _payRow(String label, String value, Color textSecondary, Color textPrimary) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: textSecondary, fontSize: 15)),
        Text(value, style: TextStyle(color: textPrimary, fontSize: 15, fontWeight: FontWeight.w600)),
      ],
    );
  }
}