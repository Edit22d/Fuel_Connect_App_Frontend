import 'package:flutter/material.dart';
import 'package:fuel_app/auth/theme.dart';
import 'payment_success_screen.dart';

class PaymentScreen extends StatefulWidget {
  final String stationName;
  final String fuelType;
  final int quantityLitres;
  final double totalAmount;
  final String deliveryLocation;
  final String deliveryTime;
  final String vehicleModel;
  final String licensePlate;

  const PaymentScreen({
    super.key,
    this.stationName = 'Aloha Petroleum, Ltd',
    this.fuelType    = 'Petrol 95',
    this.quantityLitres = 20,
    this.totalAmount = 106.80,
    this.deliveryLocation = '1001 Bishop St. Ste 130',
    this.deliveryTime = 'Deliver Now',
    this.vehicleModel = 'Toyota Corolla',
    this.licensePlate = 'UAS 452G',
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int _selectedPaymentIndex = 0; // 0: Cash, 1: Wallet, 2: Credit Card, 3: Airtel, 4: MTN, 5: Momo
  String _cardNumber = '';
  String _cardExpiry = '';

  String get _formattedTotal {
    return '\$${widget.totalAmount.toStringAsFixed(2)}';
  }

  void _showAddCardBottomSheet(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppTheme.darkSurface : Colors.white;
    final textPrimary = isDark ? Colors.white : const Color(0xFF111111);
    final textSecondary = isDark ? AppTheme.darkTextSecondary : const Color(0xFF666666);
    final dividerColor = isDark ? AppTheme.darkBorder : const Color(0xFFE8E8E8);

    final cardNumberController = TextEditingController(text: _cardNumber);
    final expiryController = TextEditingController(text: _cardExpiry);
    final cvvController = TextEditingController();

    showModalBottomSheet(
      context: context,
      backgroundColor: cardBg,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            top: 20,
            left: 20,
            right: 20,
          ),
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
                'Credit & Debit Card Details',
                style: TextStyle(
                  color: textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: cardNumberController,
                keyboardType: TextInputType.number,
                style: TextStyle(color: textPrimary),
                decoration: InputDecoration(
                  labelText: 'Card Number',
                  labelStyle: TextStyle(color: textSecondary),
                  hintText: 'xxxx xxxx xxxx xxxx',
                  hintStyle: const TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppTheme.gold)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppTheme.gold, width: 2)),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: expiryController,
                      keyboardType: TextInputType.datetime,
                      style: TextStyle(color: textPrimary),
                      decoration: InputDecoration(
                        labelText: 'Expiry Date',
                        labelStyle: TextStyle(color: textSecondary),
                        hintText: 'MM/YY',
                        hintStyle: const TextStyle(color: Colors.grey),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppTheme.gold)),
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppTheme.gold, width: 2)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: cvvController,
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      style: TextStyle(color: textPrimary),
                      decoration: InputDecoration(
                        labelText: 'CVV',
                        labelStyle: TextStyle(color: textSecondary),
                        hintText: '***',
                        hintStyle: const TextStyle(color: Colors.grey),
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppTheme.gold)),
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppTheme.gold, width: 2)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.gold,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    if (cardNumberController.text.isNotEmpty) {
                      setState(() {
                        _cardNumber = cardNumberController.text;
                        _cardExpiry = expiryController.text;
                        _selectedPaymentIndex = 2; // select Card
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Card details added!'),
                          duration: Duration(seconds: 1),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  child: const Text(
                    'Save Card',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBrandLogo(String brand) {
    switch (brand) {
      case 'Airtel Mobile':
        return Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
            color: Color(0xFFE31B23),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: const Text(
            'a',
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900, fontFamily: 'sans-serif'),
          ),
        );
      case 'MTN Mobile':
        return Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
            color: Color(0xFFFFCC00),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: const Text(
            'MTN',
            style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold),
          ),
        );
      case 'Momo Pay':
        return Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
            color: Color(0xFF0066AE),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: const Text(
            'Momo',
            style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  String _getSelectedPaymentMethodName() {
    switch (_selectedPaymentIndex) {
      case 0:
        return 'Cash';
      case 1:
        return 'Wallet';
      case 2:
        return _cardNumber.isNotEmpty 
            ? 'Card (•••• ${_cardNumber.substring(_cardNumber.length - 4.clamp(0, _cardNumber.length))})'
            : 'Credit/Debit Card';
      case 3:
        return 'Airtel Mobile';
      case 4:
        return 'MTN Mobile';
      case 5:
        return 'Momo Pay';
      default:
        return 'Cash';
    }
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
          'Payment Methods',
          style: TextStyle(
            color: textPrimary,
            fontSize: 17,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
        actions: const [
          ThemeToggleButton(),
        ],
      ),
      body: Column(
        children: [
          Divider(height: 1, thickness: 1, color: dividerColor),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Cash Section ─────────────────────────────────────
                  _buildSectionHeader('Cash', textSecondary),
                  const SizedBox(height: 10),
                  _buildPaymentCard(
                    index: 0,
                    icon: Icons.payments_outlined,
                    title: 'Cash',
                    cardBg: cardBg,
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                    dividerColor: dividerColor,
                    gold: gold,
                  ),
                  const SizedBox(height: 20),

                  // ── Wallet Section ─────────────────────────────────────
                  _buildSectionHeader('Wallet', textSecondary),
                  const SizedBox(height: 10),
                  _buildPaymentCard(
                    index: 1,
                    icon: Icons.account_balance_wallet_outlined,
                    title: 'Wallet',
                    cardBg: cardBg,
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                    dividerColor: dividerColor,
                    gold: gold,
                  ),
                  const SizedBox(height: 20),

                  // ── Credit & Debit Card Section ────────────────────────
                  _buildSectionHeader('Credit & Debit Card', textSecondary),
                  const SizedBox(height: 10),
                  _buildPaymentCard(
                    index: 2,
                    icon: Icons.credit_card_outlined,
                    title: 'Wallet', // named Wallet in the screenshot
                    subtitle: _cardNumber.isNotEmpty 
                        ? 'Visa •••• ${_cardNumber.substring(_cardNumber.length - 4.clamp(0, _cardNumber.length))}' 
                        : 'Tap to enter details',
                    isCardType: true,
                    cardBg: cardBg,
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                    dividerColor: dividerColor,
                    gold: gold,
                  ),
                  const SizedBox(height: 20),

                  // ── More Payment Options Section ───────────────────────
                  _buildSectionHeader('More Payment Options', textSecondary),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        if (!isDark)
                          BoxShadow(
                            color: Colors.black.withOpacity(0.02),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                      ],
                      border: isDark ? Border.all(color: AppTheme.darkBorder) : null,
                    ),
                    child: Column(
                      children: [
                        _buildMobileMoneyRow(
                          index: 3,
                          title: 'Airtel Mobile',
                          cardBg: cardBg,
                          textPrimary: textPrimary,
                          dividerColor: dividerColor,
                          gold: gold,
                        ),
                        Divider(height: 1, thickness: 1, color: dividerColor, indent: 16, endIndent: 16),
                        _buildMobileMoneyRow(
                          index: 4,
                          title: 'MTN Mobile',
                          cardBg: cardBg,
                          textPrimary: textPrimary,
                          dividerColor: dividerColor,
                          gold: gold,
                        ),
                        Divider(height: 1, thickness: 1, color: dividerColor, indent: 16, endIndent: 16),
                        _buildMobileMoneyRow(
                          index: 5,
                          title: 'Momo Pay',
                          cardBg: cardBg,
                          textPrimary: textPrimary,
                          dividerColor: dividerColor,
                          gold: gold,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
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
                    builder: (_) => PaymentSuccessScreen(
                      stationName: widget.stationName,
                      fuelType: widget.fuelType,
                      quantityLitres: widget.quantityLitres,
                      totalAmount: widget.totalAmount,
                      deliveryLocation: widget.deliveryLocation,
                      deliveryTime: widget.deliveryTime,
                      vehicleModel: widget.vehicleModel,
                      licensePlate: widget.licensePlate,
                      paymentMethod: _getSelectedPaymentMethodName(),
                    ),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: gold,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text(
                  'Confirm Payment',
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

  Widget _buildSectionHeader(String title, Color textSecondary) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        title,
        style: TextStyle(
          color: textSecondary,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildPaymentCard({
    required int index,
    required IconData icon,
    required String title,
    String? subtitle,
    bool isCardType = false,
    required Color cardBg,
    required Color textPrimary,
    required Color textSecondary,
    required Color dividerColor,
    required Color gold,
  }) {
    final isSelected = _selectedPaymentIndex == index;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        if (isCardType) {
          _showAddCardBottomSheet(context);
        } else {
          setState(() => _selectedPaymentIndex = index);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? gold : dividerColor,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? gold : textSecondary, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ]
                ],
              ),
            ),
            if (isCardType)
              Icon(Icons.chevron_right, color: textSecondary, size: 20)
            else
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? gold : textSecondary.withOpacity(0.5),
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? Center(
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: gold,
                          ),
                        ),
                      )
                    : null,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileMoneyRow({
    required int index,
    required String title,
    required Color cardBg,
    required Color textPrimary,
    required Color dividerColor,
    required Color gold,
  }) {
    final isSelected = _selectedPaymentIndex == index;

    return InkWell(
      onTap: () => setState(() => _selectedPaymentIndex = index),
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            _buildBrandLogo(title),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? gold : Colors.grey.withOpacity(0.5),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: gold,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
