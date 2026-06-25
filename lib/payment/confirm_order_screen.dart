import 'package:flutter/material.dart';
import 'package:fuel_app/auth/theme.dart';
import 'payment_screen.dart';

class ConfirmOrderScreen extends StatefulWidget {
  final String stationName;
  final String fuelType;
  final int quantityLitres;
  final double totalAmount;
  final String deliveryLocation;

  const ConfirmOrderScreen({
    super.key,
    this.stationName = 'Aloha Petroleum, Ltd',
    this.fuelType = 'Petrol',
    this.quantityLitres = 35,
    this.totalAmount = 120.500,
    this.deliveryLocation = '1574 Santa Monica Blvd, Los Angeles, CA 900...',
  });

  @override
  State<ConfirmOrderScreen> createState() => _ConfirmOrderScreenState();
}

class _ConfirmOrderScreenState extends State<ConfirmOrderScreen> {
  String _pickupAddress = '11574 Santa Monica Blvd, Los Angeles, CA 90025';
  late String _dropAddress;
  String _deliveryMode = 'process'; // 'process' or 'schedule'
  DateTime _scheduledDateTime = DateTime.now(); // Fixed: Use current date as default

  @override
  void initState() {
    super.initState();
    _dropAddress = widget.deliveryLocation.isNotEmpty 
        ? widget.deliveryLocation 
        : '9805 S Main St, Houston, TX 77025';
    // Set scheduled date to now by default
    _scheduledDateTime = DateTime.now();
  }

  void _showEditAddressDialog(BuildContext context, {required bool isPickup}) {
    final textController = TextEditingController(text: isPickup ? _pickupAddress : _dropAddress);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDark ? AppTheme.darkSurface : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            isPickup ? 'Edit Pickup Location' : 'Edit Drop Location',
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: TextField(
            controller: textController,
            style: TextStyle(color: isDark ? Colors.white : Colors.black),
            decoration: InputDecoration(
              hintText: 'Enter address...',
              hintStyle: const TextStyle(color: Colors.grey),
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppTheme.gold)),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppTheme.gold, width: 2)),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.gold,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                setState(() {
                  if (isPickup) {
                    _pickupAddress = textController.text;
                  } else {
                    _dropAddress = textController.text;
                  }
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Address updated successfully!'),
                    duration: Duration(seconds: 1),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text('Save', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  // Fixed date picker with correct date validation
  Future<void> _selectDateTime(BuildContext context) async {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final DateTime now = DateTime.now();
    final DateTime firstDate = now; // Set first date to today
    final DateTime lastDate = now.add(const Duration(days: 30)); // 30 days from now
    
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: now, // Use today as initial date
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: isDark
                ? const ColorScheme.dark(
                    primary: AppTheme.gold,
                    onPrimary: Colors.white,
                    onSurface: Colors.white,
                  )
                : const ColorScheme.light(
                    primary: AppTheme.gold,
                    onPrimary: Colors.white,
                    onSurface: Colors.black,
                  ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.gold,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      if (!context.mounted) return;
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_scheduledDateTime),
        builder: (context, child) {
          final bool isDark = Theme.of(context).brightness == Brightness.dark;
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: isDark
                  ? const ColorScheme.dark(
                      primary: AppTheme.gold,
                      onPrimary: Colors.white,
                      onSurface: Colors.white,
                    )
                  : const ColorScheme.light(
                      primary: AppTheme.gold,
                      onPrimary: Colors.white,
                      onSurface: Colors.black,
                    ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: AppTheme.gold,
                ),
              ),
            ),
            child: child!,
          );
        },
      );

      if (pickedTime != null) {
        setState(() {
          _scheduledDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          _deliveryMode = 'schedule';
        });
      }
    }
  }

  void _showMoreOptionsBottomSheet(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppTheme.darkSurface : Colors.white;
    final textPrimary = isDark ? Colors.white : const Color(0xFF111111);
    final dividerColor = isDark ? AppTheme.darkBorder : const Color(0xFFE8E8E8);

    showModalBottomSheet(
      context: context,
      backgroundColor: cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: dividerColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Order Options',
                  style: TextStyle(
                    color: textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ListTile(
                  leading: Icon(Icons.edit, color: AppTheme.gold),
                  title: Text('Edit Pickup Location', style: TextStyle(color: textPrimary)),
                  onTap: () {
                    Navigator.pop(context);
                    _showEditAddressDialog(context, isPickup: true);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.edit_location_alt, color: AppTheme.gold),
                  title: Text('Edit Drop Location', style: TextStyle(color: textPrimary)),
                  onTap: () {
                    Navigator.pop(context);
                    _showEditAddressDialog(context, isPickup: false);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.support_agent, color: AppTheme.gold),
                  title: Text('Contact Support', style: TextStyle(color: textPrimary)),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/support');
                  },
                ),
                ListTile(
                  leading: Icon(
                    isDark ? Icons.light_mode : Icons.dark_mode,
                    color: AppTheme.gold,
                  ),
                  title: Text('Toggle Theme (Light / Dark)', style: TextStyle(color: textPrimary)),
                  onTap: () {
                    Navigator.pop(context);
                    themeNotifier.toggleTheme();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.close, color: Colors.redAccent),
                  title: const Text('Cancel Checkout', style: TextStyle(color: Colors.redAccent)),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatScheduledDateOnly(DateTime dt) {
    final weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${weekdays[dt.weekday - 1]}, ${months[dt.month - 1]} ${dt.day},';
  }

  String _formatScheduledTimeOnly(DateTime dt) {
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $ampm';
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
          'Confirm Order',
          style: TextStyle(
            color: textPrimary,
            fontSize: 17,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () => _showMoreOptionsBottomSheet(context),
            child: Center(
              child: Container(
                margin: const EdgeInsets.only(right: 16),
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: cardBg,
                  shape: BoxShape.circle,
                  border: Border.all(color: dividerColor, width: 1.5),
                ),
                child: Icon(Icons.more_horiz, color: textPrimary, size: 18),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Divider(height: 1, thickness: 1, color: dividerColor),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Where to Drop? ─────────────────────────────────────
                  Text(
                    'Where to Drop?',
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
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                      ],
                      border: isDark ? Border.all(color: AppTheme.darkBorder) : null,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: LocationTimeline(
                      pickupAddress: _pickupAddress,
                      dropAddress: _dropAddress,
                      onEditPickup: () => _showEditAddressDialog(context, isPickup: true),
                      onEditDrop: () => _showEditAddressDialog(context, isPickup: false),
                    ),
                  ),
                  const SizedBox(height: 22),

                  // ── Select Delivery Time ────────────────────────────────
                  Text(
                    'Select Delivery Time',
                    style: TextStyle(
                      color: textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      // Process Today Card
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _deliveryMode = 'process';
                              // Reset scheduled date to now when switching to process mode
                              _scheduledDateTime = DateTime.now();
                            });
                            final bool isDark = Theme.of(context).brightness == Brightness.dark;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: isDark ? Colors.grey[800] : Colors.grey[300],
                                content: const Text('Delivery set to Process Today'),
                              ),
                            );
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: cardBg,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: _deliveryMode == 'process' ? gold : dividerColor,
                                width: _deliveryMode == 'process' ? 1.5 : 1,
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 18,
                                      height: 18,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: _deliveryMode == 'process' ? gold : textSecondary.withOpacity(0.5),
                                          width: 2,
                                        ),
                                      ),
                                      child: _deliveryMode == 'process'
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
                                    const SizedBox(width: 8),
                                    Text(
                                      'Process today',
                                      style: TextStyle(
                                        color: textPrimary,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Processing starts today.',
                                  style: TextStyle(
                                    color: textSecondary,
                                    fontSize: 11,
                                    height: 1.3,
                                  ),
                                ),
                                Text(
                                  'Delivery in 2-3 working days',
                                  style: TextStyle(
                                    color: textSecondary,
                                    fontSize: 11,
                                    height: 1.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Schedule Card
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _selectDateTime(context),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: cardBg,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: _deliveryMode == 'schedule' ? gold : dividerColor,
                                width: _deliveryMode == 'schedule' ? 1.5 : 1,
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 18,
                                      height: 18,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: _deliveryMode == 'schedule' ? gold : textSecondary.withOpacity(0.5),
                                          width: 2,
                                        ),
                                      ),
                                      child: _deliveryMode == 'schedule'
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
                                    const SizedBox(width: 8),
                                    Text(
                                      'Schedule',
                                      style: TextStyle(
                                        color: textPrimary,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  _formatScheduledDateOnly(_scheduledDateTime),
                                  style: TextStyle(
                                    color: textSecondary,
                                    fontSize: 11,
                                    height: 1.3,
                                  ),
                                ),
                                Text(
                                  _formatScheduledTimeOnly(_scheduledDateTime),
                                  style: TextStyle(
                                    color: textSecondary,
                                    fontSize: 11,
                                    height: 1.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),

                  // ── Estimated time Delivery ─────────────────────────────
                  Text(
                    'Estimated time Delivery',
                    style: TextStyle(
                      color: textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        if (!isDark)
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                      ],
                      border: isDark ? Border.all(color: AppTheme.darkBorder) : null,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.access_time_rounded, color: textSecondary, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _deliveryMode == 'process'
                                ? 'Thursday 13th - Monday 16th 2025 3-4 working days'
                                : 'Scheduled: ${_formatScheduledDateOnly(_scheduledDateTime)} at ${_formatScheduledTimeOnly(_scheduledDateTime)}',
                            style: TextStyle(
                              color: textSecondary,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w500,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // ── Order Reference ─────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Order Reference:',
                          style: TextStyle(
                            color: textPrimary,
                            fontSize: 13.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '3367HGYMKaL60253',
                          style: TextStyle(
                            color: textSecondary,
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
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
                    builder: (_) => PaymentScreen(
                      stationName: widget.stationName,
                      fuelType: widget.fuelType,
                      quantityLitres: widget.quantityLitres,
                      totalAmount: widget.totalAmount,
                      deliveryLocation: _dropAddress,
                      deliveryTime: _deliveryMode == 'process'
                          ? 'Process Today (2-3 working days)'
                          : 'Scheduled: ${_formatScheduledDateOnly(_scheduledDateTime)} ${_formatScheduledTimeOnly(_scheduledDateTime)}',
                    ),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: gold,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
}

// ── Location Timeline Dotted Widget ───────────────────────────
class LocationTimeline extends StatelessWidget {
  final String pickupAddress;
  final String dropAddress;
  final VoidCallback onEditPickup;
  final VoidCallback onEditDrop;

  const LocationTimeline({
    super.key,
    required this.pickupAddress,
    required this.dropAddress,
    required this.onEditPickup,
    required this.onEditDrop,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? Colors.white : const Color(0xFF111111);
    final textSecondary = isDark ? AppTheme.darkTextSecondary : const Color(0xFF888888);
    final boxBg = isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF2F2F5);
    final dividerColor = isDark ? AppTheme.darkBorder : const Color(0xFFE8E8E8);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Left Timeline Icons & Dotted Line
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 16),
                // Pickup Dot
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: textSecondary, width: 2),
                    color: Colors.transparent,
                  ),
                  child: Center(
                    child: Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: textSecondary,
                      ),
                    ),
                  ),
                ),
                // Dotted Line
                Expanded(
                  child: CustomPaint(
                    size: const Size(2, double.infinity),
                    painter: DottedLinePainter(color: dividerColor),
                  ),
                ),
                // Drop Dot - Changed to gold
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppTheme.gold, width: 2),
                    color: Colors.transparent,
                  ),
                  child: Center(
                    child: Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.gold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          
          // Right Address Cards
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Pickup block
                  Text(
                    'Pickup Location',
                    style: TextStyle(
                      color: textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: boxBg,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            pickupAddress,
                            style: TextStyle(color: textPrimary, fontSize: 13, fontWeight: FontWeight.w500),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: onEditPickup,
                          child: Icon(Icons.edit_outlined, size: 16, color: AppTheme.gold),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Drop block
                  Text(
                    'Drop Location',
                    style: TextStyle(
                      color: textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: boxBg,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            dropAddress,
                            style: TextStyle(color: textPrimary, fontSize: 13, fontWeight: FontWeight.w500),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: onEditDrop,
                          child: Icon(Icons.edit_outlined, size: 16, color: AppTheme.gold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }
}

class DottedLinePainter extends CustomPainter {
  final Color color;
  DottedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    
    double startY = 4;
    double endY = size.height - 4;
    double dashHeight = 4;
    double dashSpace = 4;
    
    while (startY < endY) {
      canvas.drawLine(Offset(size.width / 2, startY), Offset(size.width / 2, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}