import 'package:flutter/material.dart';
import 'package:fuel_app/auth/theme.dart';
import 'confirm_order_screen.dart';

class OrderSummaryScreen extends StatefulWidget {
  final String stationName;
  final String fuelType;
  final int quantityLitres;
  final double baseAmount;
  final String deliveryLocation;

  const OrderSummaryScreen({
    super.key,
    this.stationName = 'Aloha Petroleum, Ltd',
    this.fuelType = 'Petrol',
    this.quantityLitres = 35,
    this.baseAmount = 93.00,
    this.deliveryLocation = '1001 Bishop St. Ste 1300',
  });

  @override
  State<OrderSummaryScreen> createState() => _OrderSummaryScreenState();
}

class _OrderSummaryScreenState extends State<OrderSummaryScreen> {
  bool _insuranceEnabled = true;

  // Simulated order items
  late List<_OrderItem> _items;

  @override
  void initState() {
    super.initState();
    _items = [
      _OrderItem(
        label: widget.fuelType,
        liters: widget.quantityLitres.toDouble(),
        amount: 750.00,
      ),
      const _OrderItem(
        label: 'Gas',
        liters: 0.500,
        amount: 180.00,
      ),
    ];
  }

  double get _subtotal => _items.fold(0, (sum, item) => sum + item.amount);
  double get _insuranceAmount => _subtotal * 0.25; // 27.500
  double get _total =>
      _insuranceEnabled ? _subtotal + _insuranceAmount : _subtotal;

  String _fmt(double v) =>
      'USD ${v.toStringAsFixed(3).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',')}';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppTheme.darkBg : const Color(0xFFF5F5F7);
    final cardBg = isDark ? AppTheme.darkSurface : Colors.white;
    final textPrimary = isDark ? Colors.white : const Color(0xFF111111);
    final textSecondary = isDark ? AppTheme.darkTextSecondary : const Color(0xFF666666);
    final dividerColor = isDark ? AppTheme.darkBorder : const Color(0xFFE8E8E8);
    final gold = AppTheme.gold;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: cardBg,
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: Text(
          'Order Summary',
          style: TextStyle(
            color: textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
        actions: [
          const ThemeToggleButton(),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: dividerColor, width: 1.5),
              ),
              child: Icon(Icons.close, color: textPrimary, size: 18),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Thin divider under appbar
          Divider(height: 1, thickness: 1, color: dividerColor),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Payment Summary Card ────────────────────────────────
                  Text(
                    'Payment Summary',
                    style: TextStyle(
                      color: textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        if (!isDark)
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                      ],
                      border: isDark
                          ? Border.all(color: AppTheme.darkBorder)
                          : null,
                    ),
                    child: Column(
                      children: [
                        ...List.generate(_items.length, (i) {
                          final item = _items[i];
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18, vertical: 16),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.label,
                                            style: TextStyle(
                                              color: textPrimary,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 3),
                                          Text(
                                            '${item.liters.toStringAsFixed(3)} Liters',
                                            style: TextStyle(
                                              color: textSecondary,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      _fmtItem(item.amount),
                                      style: TextStyle(
                                        color: textPrimary,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    // Delete icon
                                    GestureDetector(
                                      onTap: () {
                                        if (_items.length > 1) {
                                          setState(
                                              () => _items.removeAt(i));
                                        }
                                      },
                                      child: Container(
                                        width: 32,
                                        height: 32,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFF3B30)
                                              .withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: const Icon(
                                          Icons.delete_outline_rounded,
                                          color: Color(0xFFFF3B30),
                                          size: 17,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    // Edit icon
                                    GestureDetector(
                                      onTap: () {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'Edit ${item.label} item'),
                                            duration: const Duration(
                                                seconds: 1),
                                            behavior:
                                                SnackBarBehavior.floating,
                                          ),
                                        );
                                      },
                                      child: Container(
                                        width: 32,
                                        height: 32,
                                        decoration: BoxDecoration(
                                          color: AppTheme.gold
                                              .withOpacity(0.12),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: const Icon(
                                          Icons.edit_outlined,
                                          color: AppTheme.gold,
                                          size: 17,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (i < _items.length - 1)
                                Divider(
                                    height: 1,
                                    thickness: 1,
                                    color: dividerColor,
                                    indent: 18,
                                    endIndent: 18),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // ── Total Card ──────────────────────────────────────────
                  Container(
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        if (!isDark)
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                      ],
                      border: isDark
                          ? Border.all(color: AppTheme.darkBorder)
                          : null,
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 18),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total',
                          style: TextStyle(
                            color: textPrimary,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          _fmt(_subtotal),
                          style: TextStyle(
                            color: textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // ── Insurance Card ──────────────────────────────────────
                  Container(
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        if (!isDark)
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                      ],
                      border: isDark
                          ? Border.all(color: AppTheme.darkBorder)
                          : null,
                    ),
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Insurance header row with check icon
                        Row(
                          children: [
                            Container(
                              width: 26,
                              height: 26,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: gold, width: 2),
                              ),
                              child: Icon(Icons.check,
                                  color: gold, size: 14),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Insurance',
                              style: TextStyle(
                                color: textPrimary,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Insurance add a fixed/percentage fee to secure your order delivery.',
                          style: TextStyle(
                            color: textSecondary,
                            fontSize: 12,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Divider(height: 1, thickness: 1, color: dividerColor),
                        const SizedBox(height: 14),

                        // Amount row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Amount:',
                              style: TextStyle(
                                color: textSecondary,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  _fmt(_insuranceAmount),
                                  style: TextStyle(
                                    color: textPrimary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Icon(Icons.info_outline,
                                    color: textSecondary, size: 16),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Add Insurance toggle row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Add Insurance',
                              style: TextStyle(
                                color: textPrimary,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Switch(
                              value: _insuranceEnabled,
                              onChanged: (v) =>
                                  setState(() => _insuranceEnabled = v),
                              activeThumbColor: Colors.white,
                              activeTrackColor: gold,
                              inactiveThumbColor: Colors.white,
                              inactiveTrackColor: dividerColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // ── Update Total Card ───────────────────────────────────
                  Container(
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        if (!isDark)
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                      ],
                      border: isDark
                          ? Border.all(color: AppTheme.darkBorder)
                          : null,
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Update Total',
                              style: TextStyle(
                                color: textPrimary,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: Text(
                                _fmt(_total),
                                key: ValueKey(_total),
                                style: TextStyle(
                                  color: textPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (_insuranceEnabled) ...[
                          const SizedBox(height: 6),
                          Text(
                            'Insurance included',
                            style: TextStyle(
                              color: gold,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),

          // ── Bottom Button ────────────────────────────────────────────
          Container(
            color: cardBg,
            padding: EdgeInsets.fromLTRB(
                20,
                14,
                20,
                14 + MediaQuery.of(context).padding.bottom),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ConfirmOrderScreen(
                      stationName: widget.stationName,
                      fuelType: widget.fuelType,
                      quantityLitres: widget.quantityLitres,
                      totalAmount: _total,
                      deliveryLocation: widget.deliveryLocation,
                    ),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: gold,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text(
                  'Confirm and Pay',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _fmtItem(double v) =>
      '${v.toStringAsFixed(3).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',')} USD';
}

class _OrderItem {
  final String label;
  final double liters;
  final double amount;
  const _OrderItem(
      {required this.label, required this.liters, required this.amount});
}
