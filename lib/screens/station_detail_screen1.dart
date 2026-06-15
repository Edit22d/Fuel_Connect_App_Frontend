import 'package:flutter/material.dart';
import 'package:fuel_app/auth/theme.dart';
import '/payment/order_summary_screen.dart';

class StationDetailScreen1 extends StatefulWidget {
  const StationDetailScreen1({super.key});

  @override
  State<StationDetailScreen1> createState() => _StationDetailScreen1State();
}

class _StationDetailScreen1State extends State<StationDetailScreen1> {
  bool _isPetrolExpanded = true;
  String _selectedTruck = 'Medium';

  final TextEditingController _litersController =
      TextEditingController(text: '35.00');
  final TextEditingController _amountController =
      TextEditingController(text: '\$ 3.00');

  @override
  void dispose() {
    _litersController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppTheme.darkBg : Colors.white;
    final cardBg = isDark ? AppTheme.darkSurface : Colors.white;
    final accordionBodyBg =
        isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF4F4F4);
    final textPrimary =
        isDark ? Colors.white : const Color(0xFF111111);
    final textSecondary =
        isDark ? AppTheme.darkTextSecondary : const Color(0xFF8E8E93);
    final borderColor =
        isDark ? AppTheme.darkBorder : Colors.grey.withOpacity(0.15);
    final gold = AppTheme.gold;

    return Scaffold(
      backgroundColor: bg,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Header Image & Overlay Buttons ──────────────────────────
            Stack(
              children: [
                Container(
                  height: 280,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(32)),
                    image: DecorationImage(
                      image: AssetImage('assets/images/stabex_station.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Gradient overlay for readability
                Container(
                  height: 280,
                  decoration: BoxDecoration(
                    borderRadius:
                        const BorderRadius.vertical(bottom: Radius.circular(32)),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.25),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _CircularButton(
                          icon: Icons.arrow_back,
                          onTap: () => Navigator.pop(context),
                        ),
                        const HeaderThemeToggle(),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Title & Rating ──────────────────────────────────────
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Aloha Petroleum, Ltd',
                          style: TextStyle(
                            color: textPrimary,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star,
                              color: Color(0xFFFFC107), size: 18),
                          const SizedBox(width: 4),
                          Text(
                            '5.0',
                            style: TextStyle(
                              color: textPrimary.withOpacity(0.8),
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // ── Address ─────────────────────────────────────────────
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined,
                          color: textSecondary, size: 18),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          '1001 Bishop St. Ste 1300, HI 96813, US',
                          style: TextStyle(
                            color: textSecondary,
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // ── Available Products ──────────────────────────────────
                  Text(
                    'Available Products',
                    style: TextStyle(
                      color: textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: borderColor),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(isDark ? 0.0 : 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _ProductCol(
                            label: 'Gas',
                            price: '1,200',
                            showDivider: true,
                            textPrimary: textPrimary,
                            textSecondary: textSecondary),
                        _ProductCol(
                            label: 'Petrol',
                            price: '1,450',
                            showDivider: true,
                            textPrimary: textPrimary,
                            textSecondary: textSecondary),
                        _ProductCol(
                            label: 'Diesel',
                            price: 'N/A',
                            showDivider: false,
                            textPrimary: textPrimary,
                            textSecondary: textSecondary),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── Petrol Accordion ────────────────────────────────────
                  Container(
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: borderColor),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(isDark ? 0.0 : 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Header
                        InkWell(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16)),
                          onTap: () => setState(
                              () => _isPetrolExpanded = !_isPetrolExpanded),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Petrol',
                                  style: TextStyle(
                                    color: textPrimary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                AnimatedRotation(
                                  turns: _isPetrolExpanded ? 0.5 : 0,
                                  duration:
                                      const Duration(milliseconds: 250),
                                  child: Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: textSecondary,
                                    size: 24,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Body
                        AnimatedCrossFade(
                          firstChild: const SizedBox(
                              width: double.infinity, height: 0),
                          secondChild: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: accordionBodyBg,
                              borderRadius: const BorderRadius.vertical(
                                  bottom: Radius.circular(16)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Liters
                                Text('Liters',
                                    style: TextStyle(
                                        color: textPrimary,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600)),
                                const SizedBox(height: 8),
                                _buildTextField(
                                    _litersController, cardBg, textPrimary),
                                const SizedBox(height: 14),

                                // Amount
                                Text('Amount',
                                    style: TextStyle(
                                        color: textPrimary,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600)),
                                const SizedBox(height: 8),
                                _buildTextField(
                                    _amountController, cardBg, textPrimary),
                                const SizedBox(height: 14),

                                // Truck
                                Text('Truck',
                                    style: TextStyle(
                                        color: textPrimary,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600)),
                                const SizedBox(height: 8),
                                Container(
                                  decoration: BoxDecoration(
                                    color: accordionBodyBg,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: borderColor),
                                  ),
                                  padding: const EdgeInsets.all(4),
                                  child: Row(
                                    children: [
                                      _buildTruckPill('Small', cardBg,
                                          textPrimary, borderColor),
                                      _buildTruckPill('Medium', cardBg,
                                          textPrimary, borderColor),
                                      _buildTruckPill('Large', cardBg,
                                          textPrimary, borderColor),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          crossFadeState: _isPetrolExpanded
                              ? CrossFadeState.showSecond
                              : CrossFadeState.showFirst,
                          duration: const Duration(milliseconds: 250),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20), // Space for bottom button
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: bg,
        padding: EdgeInsets.fromLTRB(
            20, 12, 20, 12 + MediaQuery.of(context).padding.bottom),
        child: SizedBox(
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              final litText = _litersController.text
                  .replaceAll(RegExp(r'[^0-9.]'), '');
              final amountText = _amountController.text
                  .replaceAll(RegExp(r'[^0-9.]'), '');
              final litres = double.tryParse(litText)?.toInt() ?? 35;
              final amount = double.tryParse(amountText) ?? 93.00;

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => OrderSummaryScreen(
                    stationName: 'Aloha Petroleum, Ltd',
                    deliveryLocation: '1001 Bishop St. Ste 1300',
                    fuelType: 'Petrol',
                    quantityLitres: litres,
                    baseAmount: amount,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: gold,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text(
              'View Order & Proceed',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, Color cardBg,
      Color textPrimary) {
    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(
            color: textPrimary, fontSize: 14, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildTruckPill(
      String size, Color cardBg, Color textPrimary, Color borderColor) {
    final isSelected = _selectedTruck == size;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTruck = size),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? cardBg : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    )
                  ]
                : [],
          ),
          alignment: Alignment.center,
          child: Text(
            size,
            style: TextStyle(
              color: textPrimary,
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class _CircularButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircularButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.92),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.black87, size: 20),
      ),
    );
  }
}

class _ProductCol extends StatelessWidget {
  final String label;
  final String price;
  final bool showDivider;
  final Color textPrimary;
  final Color textSecondary;

  const _ProductCol({
    required this.label,
    required this.price,
    required this.showDivider,
    required this.textPrimary,
    required this.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  price,
                  style: TextStyle(
                    color: textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          if (showDivider)
            Container(
              height: 30,
              width: 1,
              color: Colors.grey.withOpacity(0.2),
            ),
        ],
      ),
    );
  }
}
