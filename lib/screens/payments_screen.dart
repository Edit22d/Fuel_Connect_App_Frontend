// import 'package:flutter/material.dart';
// import 'station_list_screen.dart'
//     show StationModel, FCAppBar, FCProceedButton;

// // ─────────────────────────────────────────────────────────────────────────────
// // SCREEN 9  —  "Add Money / Payments"
// // Dark card with title "Payments", 4 labelled input rows,
// // "Checkout from Dalton Khasal" footer, gold "Proceed To Checkout" button
// //
// // SCREEN 10 — same screen + order-success modal on top
// // ─────────────────────────────────────────────────────────────────────────────
// class PaymentsScreen extends StatefulWidget {
//   final StationModel station;
//   final String fuelType;
//   const PaymentsScreen(
//       {Key? key, required this.station, required this.fuelType})
//       : super(key: key);

//   @override
//   State<PaymentsScreen> createState() => _PaymentsScreenState();
// }

// class _PaymentsScreenState extends State<PaymentsScreen>
//     with SingleTickerProviderStateMixin {
//   final _litres1Ctrl = TextEditingController(text: '10 litres');
//   final _litres2Ctrl = TextEditingController(text: '10 litre');
//   final _amountCtrl  = TextEditingController(text: '45,500');
//   final _extraCtrl   = TextEditingController(text: '1,500');

//   // Delivery radio selection
//   String _delivery = 'Home City';

//   late AnimationController _ctrl;
//   late Animation<double> _fade;
//   late Animation<Offset> _slide;

//   @override
//   void initState() {
//     super.initState();
//     _ctrl = AnimationController(
//         vsync: this, duration: const Duration(milliseconds: 450));
//     _fade  = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
//     _slide = Tween<Offset>(begin: const Offset(0, 0.04), end: Offset.zero)
//         .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
//     _ctrl.forward();
//   }

//   @override
//   void dispose() {
//     _ctrl.dispose();
//     _litres1Ctrl.dispose();
//     _litres2Ctrl.dispose();
//     _amountCtrl.dispose();
//     _extraCtrl.dispose();
//     super.dispose();
//   }

//   void _onProceed() => _showSuccessModal();

//   // ── Order-success modal (Screen 10) ─────────────────────────────────────────
//   void _showSuccessModal() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       barrierColor: Colors.black.withOpacity(0.7),
//       builder: (_) => StatefulBuilder(
//         builder: (ctx, setDialogState) => Dialog(
//           backgroundColor: Colors.transparent,
//           insetPadding:
//               const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
//           child: Container(
//             decoration: BoxDecoration(
//               color: const Color(0xFF232323),
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(
//                   color: const Color(0xFFc8970a).withOpacity(0.45),
//                   width: 1.5),
//               boxShadow: [
//                 BoxShadow(
//                     color: const Color(0xFFc8970a).withOpacity(0.15),
//                     blurRadius: 28,
//                     spreadRadius: 1)
//               ],
//             ),
//             padding: const EdgeInsets.all(22),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 // ── Success message ─────────────────────
//                 const Text(
//                   'Your order has been\nSuccessfully placed',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 14,
//                       fontWeight: FontWeight.w600,
//                       height: 1.4),
//                 ),
//                 const SizedBox(height: 18),

//                 // ── Delivery radio options ───────────────
//                 _RadioOption(
//                   label: 'Home City',
//                   icon: Icons.home_outlined,
//                   selected: _delivery == 'Home City',
//                   onTap: () =>
//                       setDialogState(() => _delivery = 'Home City'),
//                 ),
//                 const SizedBox(height: 8),
//                 _RadioOption(
//                   label: 'Drive Minus',
//                   icon: Icons.directions_car_outlined,
//                   selected: _delivery == 'Drive Minus',
//                   onTap: () =>
//                       setDialogState(() => _delivery = 'Drive Minus'),
//                 ),
//                 const SizedBox(height: 8),
//                 _RadioOption(
//                   label: 'Cash',
//                   icon: Icons.payments_outlined,
//                   selected: _delivery == 'Cash',
//                   onTap: () =>
//                       setDialogState(() => _delivery = 'Cash'),
//                 ),
//                 const SizedBox(height: 22),

//                 // ── Okay button ─────────────────────────
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.of(context).pop();
//                     Navigator.of(context)
//                         .popUntil((r) => r.isFirst);
//                   },
//                   child: Container(
//                     width: double.infinity,
//                     height: 46,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(28),
//                       gradient: const LinearGradient(
//                           colors: [
//                             Color(0xFF3d2b00),
//                             Color(0xFFc8970a)
//                           ]),
//                       boxShadow: [
//                         BoxShadow(
//                             color: const Color(0xFFc8970a)
//                                 .withOpacity(0.35),
//                             blurRadius: 14,
//                             offset: const Offset(0, 4))
//                       ],
//                     ),
//                     child: const Center(
//                       child: Text('Okay',
//                           style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 14,
//                               fontWeight: FontWeight.bold,
//                               letterSpacing: 0.4)),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // ── BUILD ─────────────────────────────────────────────────────────────────
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF1a1a1a),
//       body: FadeTransition(
//         opacity: _fade,
//         child: Column(
//           children: [
//             FCAppBar(title: 'Add Money'),

//             Expanded(
//               child: SlideTransition(
//                 position: _slide,
//                 child: SingleChildScrollView(
//                   padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
//                   child: Column(
//                     children: [
//                       // ── Payments card ─────────────────────
//                       Container(
//                         width: double.infinity,
//                         decoration: BoxDecoration(
//                           color: const Color(0xFF262626),
//                           borderRadius: BorderRadius.circular(14),
//                           border: Border.all(
//                               color: const Color(0xFFc8970a)
//                                   .withOpacity(0.22),
//                               width: 1),
//                         ),
//                         padding: const EdgeInsets.all(18),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             // "Payments" title
//                             const Text('Payments',
//                                 style: TextStyle(
//                                     color: Color(0xFFc8970a),
//                                     fontSize: 15,
//                                     fontWeight: FontWeight.bold)),
//                             const SizedBox(height: 16),

//                             // Station chip
//                             Container(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 12, vertical: 8),
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(8),
//                                 color: const Color(0xFFc8970a)
//                                     .withOpacity(0.08),
//                                 border: Border.all(
//                                     color: const Color(0xFFc8970a)
//                                         .withOpacity(0.25)),
//                               ),
//                               child: Row(
//                                 children: [
//                                   const Icon(Icons.local_gas_station,
//                                       color: Color(0xFFc8970a),
//                                       size: 18),
//                                   const SizedBox(width: 8),
//                                   Expanded(
//                                     child: Text(
//                                       '${widget.station.name}  ·  ${widget.fuelType}',
//                                       style: const TextStyle(
//                                           color: Colors.white,
//                                           fontSize: 12),
//                                     ),
//                                   ),
//                                   Text(widget.station.distance,
//                                       style: const TextStyle(
//                                           color: Color(0xFFc8970a),
//                                           fontSize: 10)),
//                                 ],
//                               ),
//                             ),
//                             const SizedBox(height: 16),

//                             // ── 4 input rows ──────────────────
//                             _PayRow(
//                               label: '10 litres',
//                               ctrl: _litres1Ctrl,
//                             ),
//                             const SizedBox(height: 2),
//                             _PayDivider(),
//                             const SizedBox(height: 2),
//                             _PayRow(
//                               label: '10 litre',
//                               ctrl: _litres2Ctrl,
//                             ),
//                             const SizedBox(height: 2),
//                             _PayDivider(),
//                             const SizedBox(height: 2),
//                             _PayRow(
//                               label: '45,500',
//                               ctrl: _amountCtrl,
//                               keyboardType: TextInputType.number,
//                             ),
//                             const SizedBox(height: 2),
//                             _PayDivider(),
//                             const SizedBox(height: 2),
//                             _PayRow(
//                               label: '1,500',
//                               ctrl: _extraCtrl,
//                               keyboardType: TextInputType.number,
//                             ),
//                             const SizedBox(height: 18),

//                             // ── "Checkout from …" ─────────────
//                             Row(
//                               children: [
//                                 const Icon(Icons.store_mall_directory_outlined,
//                                     color: Color(0xFFc8970a), size: 15),
//                                 const SizedBox(width: 6),
//                                 Text(
//                                   'Checkout from Dalton Khasal',
//                                   style: TextStyle(
//                                       color: Colors.white
//                                           .withOpacity(0.55),
//                                       fontSize: 12),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),

//                       const SizedBox(height: 16),

//                       // ── Delivery options card ─────────────
//                       Container(
//                         width: double.infinity,
//                         decoration: BoxDecoration(
//                           color: const Color(0xFF262626),
//                           borderRadius: BorderRadius.circular(14),
//                           border: Border.all(
//                               color: const Color(0xFFc8970a)
//                                   .withOpacity(0.22),
//                               width: 1),
//                         ),
//                         padding: const EdgeInsets.all(16),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text('Delivery Options',
//                                 style: TextStyle(
//                                     color: Color(0xFFc8970a),
//                                     fontSize: 13,
//                                     fontWeight: FontWeight.w600)),
//                             const SizedBox(height: 12),
//                             _RadioOption(
//                               label: 'Home City',
//                               icon: Icons.home_outlined,
//                               selected: _delivery == 'Home City',
//                               onTap: () => setState(
//                                   () => _delivery = 'Home City'),
//                             ),
//                             const SizedBox(height: 8),
//                             _RadioOption(
//                               label: 'Drive Minus',
//                               icon: Icons.directions_car_outlined,
//                               selected: _delivery == 'Drive Minus',
//                               onTap: () => setState(
//                                   () => _delivery = 'Drive Minus'),
//                             ),
//                             const SizedBox(height: 8),
//                             _RadioOption(
//                               label: 'Cash',
//                               icon: Icons.payments_outlined,
//                               selected: _delivery == 'Cash',
//                               onTap: () =>
//                                   setState(() => _delivery = 'Cash'),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                     ],
//                   ),
//                 ),
//               ),
//             ),

//             // ── "Proceed To Checkout" bottom bar ──────────
//             Container(
//               color: const Color(0xFF1a1a1a),
//               padding: const EdgeInsets.fromLTRB(24, 10, 24, 28),
//               child: GestureDetector(
//                 onTap: _onProceed,
//                 child: Container(
//                   height: 48,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(30),
//                     gradient: const LinearGradient(
//                         colors: [Color(0xFF3d2b00), Color(0xFFc8970a)]),
//                     boxShadow: [
//                       BoxShadow(
//                           color:
//                               const Color(0xFFc8970a).withOpacity(0.3),
//                           blurRadius: 16,
//                           offset: const Offset(0, 5))
//                     ],
//                   ),
//                   child: const Center(
//                     child: Text('Proceed To Checkout',
//                         style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 14,
//                             fontWeight: FontWeight.bold,
//                             letterSpacing: 0.4)),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ── Payment row — label left, editable value right ───────────────────────────
// class _PayRow extends StatelessWidget {
//   final String label;
//   final TextEditingController ctrl;
//   final TextInputType keyboardType;

//   const _PayRow({
//     required this.label,
//     required this.ctrl,
//     this.keyboardType = TextInputType.text,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Expanded(
//           child: Text(label,
//               style: const TextStyle(
//                   color: Colors.white54, fontSize: 12)),
//         ),
//         SizedBox(
//           width: 110,
//           child: TextField(
//             controller: ctrl,
//             keyboardType: keyboardType,
//             textAlign: TextAlign.right,
//             style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 12,
//                 fontWeight: FontWeight.w500),
//             decoration: const InputDecoration(
//               border: InputBorder.none,
//               isDense: true,
//               contentPadding: EdgeInsets.symmetric(vertical: 6),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _PayDivider extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) => Divider(
//       color: const Color(0xFFc8970a).withOpacity(0.15),
//       height: 1,
//       thickness: 1);
// }

// // ── Radio option row ──────────────────────────────────────────────────────────
// class _RadioOption extends StatelessWidget {
//   final String label;
//   final IconData icon;
//   final bool selected;
//   final VoidCallback onTap;

//   const _RadioOption({
//     required this.label,
//     required this.icon,
//     required this.selected,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Row(
//         children: [
//           // Radio circle
//           AnimatedContainer(
//             duration: const Duration(milliseconds: 180),
//             width: 20, height: 20,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               border: Border.all(
//                 color: selected
//                     ? const Color(0xFFc8970a)
//                     : Colors.white30,
//                 width: 2,
//               ),
//               color: selected
//                   ? const Color(0xFFc8970a).withOpacity(0.2)
//                   : Colors.transparent,
//             ),
//             child: selected
//                 ? Center(
//                     child: Container(
//                       width: 9, height: 9,
//                       decoration: const BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: Color(0xFFc8970a),
//                       ),
//                     ),
//                   )
//                 : null,
//           ),
//           const SizedBox(width: 10),

//           // Icon
//           Icon(icon,
//               color: selected ? const Color(0xFFc8970a) : Colors.white38,
//               size: 17),
//           const SizedBox(width: 8),

//           // Label
//           Text(label,
//               style: TextStyle(
//                   color: selected ? Colors.white : Colors.white54,
//                   fontSize: 13,
//                   fontWeight:
//                       selected ? FontWeight.w600 : FontWeight.normal)),
//         ],
//       ),
//     );
//   }
// }
