import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Payment App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF1A1A1A),
        fontFamily: 'SF Pro Display',
      ),
      home: const PaymentScreen(),
    );
  }
}

// ─────────────────────────────────────────────
// PAYMENT SCREEN
// ─────────────────────────────────────────────
class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int _selectedPaymentIndex = 0; // 0=Card, 1=Mobile Money, 2=Airtel Money, 3=MTN Money, 4=Mobile Pay, 5=Cash

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.85),
      builder: (_) => const PaymentSuccessDialog(),
    );
  }

  void _showFailedDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.85),
      builder: (_) => const PaymentFailedDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      body: SafeArea(
        child: Column(
          children: [
            // ── Top bar ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2C2C2E),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.arrow_back_ios_new,
                          color: Colors.white, size: 14),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Payment Summary',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

                    // ── ORDER DETAILS card ──
                    _SectionCard(
                      title: 'ORDER DETAILS',
                      child: Column(
                        children: [
                          _OrderRow(
                              label: 'Station',
                              value: 'Shell Station Downtown',
                              valueColor: Colors.white),
                          const SizedBox(height: 10),
                          _OrderRow(
                            label: 'Fuel Type',
                            value: '95 Octane',
                            valueColor: const Color(0xFFE8A020),
                            valueBackground: const Color(0xFF2E2510),
                          ),
                          const SizedBox(height: 10),
                          _OrderRow(
                              label: 'Fuel Amount',
                              value: '48.5 Liters',
                              valueColor: Colors.white70),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Divider(color: Color(0xFF3A3A3C), height: 1),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Total Amount',
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 13)),
                              Text(
                                '\$78.25',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ── PAYMENT METHOD card ──
                    _SectionCard(
                      title: 'PAYMENT METHOD',
                      child: Column(
                        children: [
                          _PaymentOption(
                            index: 0,
                            selected: _selectedPaymentIndex == 0,
                            icon: Icons.credit_card_outlined,
                            label: 'Credit/Debit Card',
                            subtitle: 'Visa •••• 4521',
                            onTap: () =>
                                setState(() => _selectedPaymentIndex = 0),
                          ),
                          const SizedBox(height: 8),
                          _GroupHeader(label: 'Mobile Money'),
                          const SizedBox(height: 8),
                          _PaymentOption(
                            index: 1,
                            selected: _selectedPaymentIndex == 1,
                            icon: Icons.phone_android,
                            label: 'Airtel Money',
                            subtitle: '+256 70x xxx xxx',
                            iconColor: const Color(0xFFE8A020),
                            onTap: () =>
                                setState(() => _selectedPaymentIndex = 1),
                          ),
                          const SizedBox(height: 8),
                          _PaymentOption(
                            index: 2,
                            selected: _selectedPaymentIndex == 2,
                            icon: Icons.phone_android,
                            label: 'MTN Money',
                            subtitle: '+256 77x xxx xxx',
                            iconColor: const Color(0xFFE8C040),
                            onTap: () =>
                                setState(() => _selectedPaymentIndex = 2),
                          ),
                          const SizedBox(height: 8),
                          _PaymentOption(
                            index: 3,
                            selected: _selectedPaymentIndex == 3,
                            icon: Icons.phone_iphone,
                            label: 'Mobile Pay',
                            subtitle: 'Apple Pay / Google Pay',
                            onTap: () =>
                                setState(() => _selectedPaymentIndex = 3),
                          ),
                          const SizedBox(height: 8),
                          _PaymentOption(
                            index: 4,
                            selected: _selectedPaymentIndex == 4,
                            icon: Icons.money_outlined,
                            label: 'Cash',
                            subtitle: 'Pay at pump',
                            onTap: () =>
                                setState(() => _selectedPaymentIndex = 4),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ── Confirm button ──
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: _showSuccessDialog,
                        icon: const Icon(Icons.lock_outline,
                            size: 18, color: Colors.black),
                        label: const Text(
                          'Confirm Payment',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.3,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE8A020),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ── Simulate failure ──
                    Center(
                      child: GestureDetector(
                        onTap: _showFailedDialog,
                        child: const Text(
                          'Simulate payment failure',
                          style: TextStyle(
                            color: Color(0xFF8E8E93),
                            fontSize: 12,
                            decoration: TextDecoration.underline,
                            decorationColor: Color(0xFF8E8E93),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// REUSABLE WIDGETS
// ─────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF242426),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF3A3A3C), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF8E8E93),
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _OrderRow extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;
  final Color? valueBackground;

  const _OrderRow({
    required this.label,
    required this.value,
    required this.valueColor,
    this.valueBackground,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style:
                const TextStyle(color: Color(0xFF8E8E93), fontSize: 13)),
        valueBackground != null
            ? Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: valueBackground,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(value,
                    style: TextStyle(
                        color: valueColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w600)),
              )
            : Text(value,
                style: TextStyle(
                    color: valueColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w500)),
      ],
    );
  }
}

class _GroupHeader extends StatelessWidget {
  final String label;
  const _GroupHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 2),
      child: Text(label,
          style: const TextStyle(
              color: Color(0xFF8E8E93),
              fontSize: 12,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5)),
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final int index;
  final bool selected;
  final IconData icon;
  final String label;
  final String subtitle;
  final Color? iconColor;
  final VoidCallback onTap;

  const _PaymentOption({
    required this.index,
    required this.selected,
    required this.icon,
    required this.label,
    required this.subtitle,
    this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color:
              selected ? const Color(0xFF2A2208) : const Color(0xFF2C2C2E),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected
                ? const Color(0xFFE8A020)
                : const Color(0xFF3A3A3C),
            width: selected ? 1.2 : 0.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFF3A2E10)
                    : const Color(0xFF3A3A3C),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon,
                  color: iconColor ??
                      (selected
                          ? const Color(0xFFE8A020)
                          : Colors.white70),
                  size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: TextStyle(
                        color: selected ? Colors.white : Colors.white70,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      )),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: const TextStyle(
                          color: Color(0xFF8E8E93), fontSize: 11)),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected
                      ? const Color(0xFFE8A020)
                      : const Color(0xFF5A5A5C),
                  width: 2,
                ),
                color: selected
                    ? const Color(0xFFE8A020)
                    : Colors.transparent,
              ),
              child: selected
                  ? const Icon(Icons.check,
                      color: Colors.black, size: 11)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// PAYMENT SUCCESS DIALOG
// ─────────────────────────────────────────────
class PaymentSuccessDialog extends StatelessWidget {
  const PaymentSuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2A2A2C), Color(0xFF1E1E20)],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF3A3A3C), width: 0.5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Success icon
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF4CAF50), width: 2.5),
              ),
              child: const Icon(Icons.check, color: Color(0xFF4CAF50), size: 36),
            ),
            const SizedBox(height: 20),

            const Text(
              'Payment Successful!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Your transaction of \$78.25 for\n#UG-1 Liter at Shell Station\nDowntown has been confirmed.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF8E8E93),
                fontSize: 13,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),

            // Transaction details row
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF2C2C2E),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _TxDetail(label: 'DATE & TIME', value: 'APR 24, 2025 • 09:32'),
                  _TxDetail(
                      label: 'TOTAL PAYMENT',
                      value: '\$78.25',
                      valueColor: const Color(0xFFE8A020)),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Back to Home button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE8A020),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: const Text(
                  '← BACK TO HOME',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TxDetail extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const _TxDetail({
    required this.label,
    required this.value,
    this.valueColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                color: Color(0xFF8E8E93),
                fontSize: 9,
                letterSpacing: 0.8,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text(value,
            style: TextStyle(
                color: valueColor,
                fontSize: 12,
                fontWeight: FontWeight.w600)),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// PAYMENT FAILED DIALOG
// ─────────────────────────────────────────────
class PaymentFailedDialog extends StatelessWidget {
  const PaymentFailedDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2A2A2C), Color(0xFF1E1E20)],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF3A3A3C), width: 0.5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Failed icon
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF3A1A1A),
                border: Border.all(color: const Color(0xFFE53935), width: 2.5),
              ),
              child: const Icon(Icons.warning_amber_rounded,
                  color: Color(0xFFE53935), size: 36),
            ),
            const SizedBox(height: 20),

            const Text(
              'Payment Failed',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Your bank declined the transaction.\nPlease check your card balance or try\na different payment method.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF8E8E93),
                fontSize: 13,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 28),

            // Try Again button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE8A020),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: const Text(
                  'TRY AGAIN',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Contact Support button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF3A3A3C), width: 1),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  'CONTACT SUPPORT',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
