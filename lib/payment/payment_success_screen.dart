import 'package:flutter/material.dart';
import 'package:fuel_app/auth/theme.dart';
import '../screens/tracking_order_screen.dart';

class PaymentSuccessScreen extends StatelessWidget {
  final String stationName;
  final String fuelType;
  final int quantityLitres;
  final double totalAmount;
  final String deliveryLocation;
  final String deliveryTime;
  final String vehicleModel;
  final String licensePlate;
  final String paymentMethod;

  const PaymentSuccessScreen({
    super.key,
    required this.stationName,
    required this.fuelType,
    required this.quantityLitres,
    required this.totalAmount,
    required this.deliveryLocation,
    required this.deliveryTime,
    required this.vehicleModel,
    required this.licensePlate,
    required this.paymentMethod,
  });

  void _showReceiptBottomSheet(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppTheme.darkSurface : Colors.white;
    final textPrimary = isDark ? Colors.white : const Color(0xFF111111);
    final textSecondary = isDark ? AppTheme.darkTextSecondary : const Color(0xFF666666);
    final dividerColor = isDark ? AppTheme.darkBorder : const Color(0xFFE8E8E8);

    showModalBottomSheet(
      context: context,
      backgroundColor: cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: dividerColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Order Receipt',
                  style: TextStyle(
                    color: textPrimary,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 18),
                _buildReceiptRow('Order Reference', '3367HGYMKaL60253', textSecondary, textPrimary),
                Divider(color: dividerColor, height: 20),
                _buildReceiptRow('Date & Time', () {
                  final now = DateTime.now();
                  return '${now.day}/${now.month}/${now.year} at ${now.hour}:${now.minute.toString().padLeft(2, '0')}';
                }(), textSecondary, textPrimary),
                Divider(color: dividerColor, height: 20),
                _buildReceiptRow('Station', stationName, textSecondary, textPrimary),
                Divider(color: dividerColor, height: 20),
                _buildReceiptRow('Fuel & Volume', '$fuelType ($quantityLitres Liters)', textSecondary, textPrimary),
                Divider(color: dividerColor, height: 20),
                _buildReceiptRow('Payment Method', paymentMethod, textSecondary, textPrimary),
                Divider(color: dividerColor, height: 20),
                _buildReceiptRow('Total Amount', '\$${totalAmount.toStringAsFixed(2)}', textSecondary, AppTheme.gold, isBoldValue: true),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildReceiptRow(String label, String value, Color labelColor, Color valueColor, {bool isBoldValue = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(color: labelColor, fontSize: 13, fontWeight: FontWeight.w500),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 13,
            fontWeight: isBoldValue ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppTheme.darkBg : const Color(0xFFF4F4F6);
    final cardBg = isDark ? AppTheme.darkSurface : Colors.white;
    final textPrimary = isDark ? Colors.white : const Color(0xFF111111);
    final textSecondary = isDark ? AppTheme.darkTextSecondary : const Color(0xFF666666);
    final dividerColor = isDark ? AppTheme.darkBorder : const Color(0xFFE8E8E8);
    final gold = AppTheme.gold;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            // Top Padding
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(
                        isDark ? Icons.light_mode : Icons.dark_mode,
                        color: isDark ? AppTheme.gold : AppTheme.darkGold,
                      ),
                      onPressed: themeNotifier.toggleTheme,
                      tooltip: 'Toggle Theme',
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),

            // Verified check badge with soft green halos
            Center(
              child: Container(
                width: 170,
                height: 170,
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withOpacity(0.06),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50).withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.verified,
                    color: Color(0xFF38D430), // vibrant green matching screenshot
                    size: 96,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Success texts
            Text(
              'Order Successful!',
              style: TextStyle(
                color: textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Your order has been placed and processing\nhas started.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textSecondary,
                  fontSize: 13.5,
                  height: 1.4,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const Spacer(flex: 2),

            // Two actions above the bottom bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  // View Receipt capsule button
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: cardBg,
                          side: BorderSide(color: dividerColor, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(26),
                          ),
                        ),
                        onPressed: () => _showReceiptBottomSheet(context),
                        child: Text(
                          'View Receipt',
                          style: TextStyle(
                            color: textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Track Your Order capsule button
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEAF9EB), // light green bg
                          foregroundColor: const Color(0xFF2E7D32), // dark green text
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(26),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => TrackOrderScreen(
                                stationName: stationName,
                                deliveryLocation: deliveryLocation,
                                deliveryTime: deliveryTime,
                                vehicleModel: vehicleModel,
                                licensePlate: licensePlate,
                                fuelType: fuelType,
                                quantityLitres: quantityLitres,
                                totalAmount: totalAmount,
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          'Track Your Order',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Large bottom button "Proceed to Payment" (routes home)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: gold,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: const Text(
                    'Proceed to Payment',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}