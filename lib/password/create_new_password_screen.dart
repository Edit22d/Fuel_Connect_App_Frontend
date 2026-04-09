// import 'package:flutter/material.dart';
// import 'verify_email_screen.dart';
// import 'verify_pin_screen.dart';
// import 'shared_widgets.dart' show slideRoute;

// class CreateNewPasswordScreen extends StatefulWidget {
//   const CreateNewPasswordScreen({Key? key}) : super(key: key);

//   @override
//   State<CreateNewPasswordScreen> createState() =>
//       _CreateNewPasswordScreenState();
// }

// class _CreateNewPasswordScreenState extends State<CreateNewPasswordScreen>
//     with SingleTickerProviderStateMixin {
//   final _newPassCtrl     = TextEditingController();
//   final _confirmPassCtrl = TextEditingController();
//   bool _obscureNew       = true;
//   bool _obscureConfirm   = true;

//   late AnimationController _ctrl;
//   late Animation<double> _fadeAnim;
//   late Animation<Offset> _slideAnim;

//   @override
//   void initState() {
//     super.initState();
//     _ctrl = AnimationController(
//         vsync: this, duration: const Duration(milliseconds: 700));
//     _fadeAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
//     _slideAnim =
//         Tween<Offset>(begin: const Offset(0, 0.07), end: Offset.zero).animate(
//             CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
//     _ctrl.forward();
//   }

//   @override
//   void dispose() {
//     _ctrl.dispose();
//     _newPassCtrl.dispose();
//     _confirmPassCtrl.dispose();
//     super.dispose();
//   }

//   void _onSave() {
//     if (_newPassCtrl.text.isEmpty || _confirmPassCtrl.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//         content: Text('Please fill in both password fields'),
//         backgroundColor: Color(0xFFd4af37),
//       ));
//       return;
//     }
//     if (_newPassCtrl.text != _confirmPassCtrl.text) {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//         content: Text('Passwords do not match'),
//         backgroundColor: Color(0xFFd4af37),
//       ));
//       return;
//     }
//     _showSuccessDialog();
//   }

//   void _showSuccessDialog() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (_) => Dialog(
//         backgroundColor: Colors.transparent,
//         child: Container(
//           decoration: BoxDecoration(
//             color: const Color(0xFF333333),
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(
//               color: const Color(0xFFd4af37).withOpacity(0.3),
//               width: 1,
//             ),
//           ),
//           padding: const EdgeInsets.all(28),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 width: 64, height: 64,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: const Color(0xFFd4af37).withOpacity(0.15),
//                   border: Border.all(
//                       color: const Color(0xFFd4af37).withOpacity(0.5),
//                       width: 1.5),
//                 ),
//                 child: const Icon(Icons.check_rounded,
//                     color: Color(0xFFd4af37), size: 32),
//               ),
//               const SizedBox(height: 18),
//               const Text(
//                 'Your password has\nbeen changed\nsuccessfully!',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                   height: 1.45,
//                 ),
//               ),
//               const SizedBox(height: 24),
//               GestureDetector(
//                 onTap: () {
//                   Navigator.of(context).popUntil((route) => route.isFirst);
//                 },
//                 child: Container(
//                   width: 100, height: 40,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(24),
//                     color: const Color(0xFFd4af37),
//                   ),
//                   child: const Center(
//                     child: Text('OK',
//                         style: TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 14,
//                             letterSpacing: 0.6)),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF0D1117),
//       body: SafeArea(
//         child: FadeTransition(
//           opacity: _fadeAnim,
//           child: Column(
//             children: [
//               TopBar(),
//               Expanded(
//                 child: SingleChildScrollView(
//                   padding: const EdgeInsets.symmetric(horizontal: 32),
//                   child: SlideTransition(
//                     position: _slideAnim,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const SizedBox(height: 16),
//                         Center(child: FuelConnectLogo()),
//                         const SizedBox(height: 36),
//                         const Center(
//                           child: Text(
//                             'Create New\nPassword',
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               color: Color(0xFFd4af37),
//                               fontSize: 30,
//                               fontWeight: FontWeight.bold,
//                               height: 1.25,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 14),
//                         const Center(
//                           child: Text(
//                             'Your new password must be different\nfrom previously used',
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                                 color: Colors.white38,
//                                 fontSize: 13,
//                                 height: 1.6),
//                           ),
//                         ),
//                         const SizedBox(height: 40),

//                         PassField(
//                           controller: _newPassCtrl,
//                           label: 'New Password',
//                           hint: 'New Password',
//                           obscure: _obscureNew,
//                           onToggle: () =>
//                               setState(() => _obscureNew = !_obscureNew),
//                         ),
//                         const SizedBox(height: 20),

//                         PassField(
//                           controller: _confirmPassCtrl,
//                           label: 'Confirm Password',
//                           hint: 'Confirm Password',
//                           obscure: _obscureConfirm,
//                           onToggle: () =>
//                               setState(() => _obscureConfirm = !_obscureConfirm),
//                         ),
//                         const SizedBox(height: 12),

//                         Align(
//                           alignment: Alignment.centerRight,
//                           child: GestureDetector(
//                             onTap: () => Navigator.push(
//                               context,
//                               slideRoute(const VerifyMpinScreen()),
//                             ),
//                             child: const Text(
//                               'Change Password',
//                               style: TextStyle(
//                                 color: Color(0xFFd4af37),
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 48),

//                         GradientButton(label: 'Save', onTap: _onSave),
//                         const SizedBox(height: 30),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(bottom: 18),
//                 child: FooterText(),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // ── Password field ────────────────────────────────────────────────────────────
// class PassField extends StatelessWidget {
//   final TextEditingController controller;
//   final String label;
//   final String hint;
//   final bool obscure;
//   final VoidCallback onToggle;

//   const PassField({
//     required this.controller,
//     required this.label,
//     required this.hint,
//     required this.obscure,
//     required this.onToggle,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label,
//             style: const TextStyle(
//                 color: Color(0xFFd4af37),
//                 fontSize: 11,
//                 letterSpacing: 0.5,
//                 fontWeight: FontWeight.w500)),
//         TextField(
//           controller: controller,
//           obscureText: obscure,
//           style: const TextStyle(color: Colors.white, fontSize: 14),
//           decoration: InputDecoration(
//             hintText: hint,
//             hintStyle:
//                 const TextStyle(color: Colors.white38, fontSize: 13),
//             enabledBorder: const UnderlineInputBorder(
//               borderSide: BorderSide(color: Color(0xFFd4af37)),
//             ),
//             focusedBorder: const UnderlineInputBorder(
//               borderSide: BorderSide(color: Color(0xFFd4af37), width: 2),
//             ),
//             suffixIcon: GestureDetector(
//               onTap: onToggle,
//               child: Icon(
//                   obscure
//                       ? Icons.visibility_off_outlined
//                       : Icons.visibility_outlined,
//                   color: Colors.white30,
//                   size: 20),
//             ),
//             isDense: true,
//             contentPadding: const EdgeInsets.symmetric(vertical: 8),
//           ),
//         ),
//       ],
//     );
//   }
// }

// // ── Local widget aliases ─────────
// class TopBar extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
//       child: Row(
//         children: [
//           IconButton(
//             icon: const Icon(Icons.arrow_back_ios_new_rounded,
//                 color: Colors.white70, size: 20),
//             onPressed: () => Navigator.maybePop(context),
//           ),
//           const Spacer(),
//           IconButton(
//             icon: const Icon(Icons.home_outlined,
//                 color: Colors.white70, size: 22),
//             onPressed: () =>
//                 Navigator.of(context).popUntil((r) => r.isFirst),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class FuelConnectLogo extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return const Text('FuelConnect',
//         style: TextStyle(
//             fontSize: 28,
//             fontWeight: FontWeight.bold,
//             color: Color(0xFFd4af37),
//             letterSpacing: 1));
//   }
// }

// class GradientButton extends StatelessWidget {
//   final String label;
//   final VoidCallback onTap;
//   const GradientButton({required this.label, required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: double.infinity,
//         height: 52,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(30),
//           color: const Color(0xFFd4af37),
//         ),
//         child: Center(
//           child: Text(label,
//               style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 15,
//                   fontWeight: FontWeight.bold,
//                   letterSpacing: 0.8)),
//         ),
//       ),
//     );
//   }
// }

// class FooterText extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return const Text(
//       'Powered By FuelConnect Version 1.0.0',
//       style: TextStyle(color: Colors.white24, fontSize: 11),
//     );
//   }
// }