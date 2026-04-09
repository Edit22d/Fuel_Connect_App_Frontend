// import 'package:flutter/material.dart';
// import 'otp_verification_screen.dart';

// class VerifyEmailScreen extends StatefulWidget {
//   final String email;
//   const VerifyEmailScreen({Key? key, required this.email}) : super(key: key);

//   @override
//   State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
// }

// // ---------------- Shared Widgets -----------------
// Widget _TopBar() => SizedBox(height: 50); // Placeholder, actual TopBar defined below

// Widget _FuelConnectLogo() => Image.asset(
//       'assets/images/logo.png',
//       width: 100,
//       height: 100,
//       fit: BoxFit.contain,
//     );

// class _VerifyEmailScreenState extends State<VerifyEmailScreen>
//     with SingleTickerProviderStateMixin {
//   final List<TextEditingController> _boxCtrl =
//       List.generate(4, (_) => TextEditingController());
//   final List<FocusNode> _focusNodes =
//       List.generate(4, (_) => FocusNode());

//   late AnimationController _ctrl;
//   late Animation<double> _fadeAnim;
//   late Animation<Offset> _slideAnim;

//   @override
//   void initState() {
//     super.initState();
//     _ctrl = AnimationController(
//         vsync: this, duration: const Duration(milliseconds: 700));
//     _fadeAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
//     _slideAnim = Tween<Offset>(begin: const Offset(0, 0.07), end: Offset.zero)
//         .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
//     _ctrl.forward();
//   }

//   @override
//   void dispose() {
//     _ctrl.dispose();
//     for (final c in _boxCtrl) c.dispose();
//     for (final f in _focusNodes) f.dispose();
//     super.dispose();
//   }

//   void _onVerify() {
//     final code = _boxCtrl.map((c) => c.text).join();
//     if (code.length < 4) {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//         content: Text('Please enter the 4-digit code'),
//         backgroundColor: Color(0xFFd4af37),
//       ));
//       return;
//     }
//     Navigator.push(
//       context,
//       _slideRoute(OtpVerificationScreen(email: widget.email)),
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
//               _TopBar(),
//               Expanded(
//                 child: SingleChildScrollView(
//                   padding: const EdgeInsets.symmetric(horizontal: 32),
//                   child: SlideTransition(
//                     position: _slideAnim,
//                     child: Column(
//                       children: [
//                         const SizedBox(height: 16),
//                         _FuelConnectLogo(),
//                         const SizedBox(height: 36),
//                         const Text(
//                           'Verify your\nEmail',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             color: Color(0xFFd4af37),
//                             fontSize: 30,
//                             fontWeight: FontWeight.bold,
//                             height: 1.25,
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         Text(
//                           'Please enter the 4 digit code sent to\n${widget.email}',
//                           textAlign: TextAlign.center,
//                           style: const TextStyle(
//                               color: Colors.white38, fontSize: 13, height: 1.6),
//                         ),
//                         const SizedBox(height: 40),

//                         // 4 code boxes
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: List.generate(4, (i) {
//                             return Container(
//                               margin: const EdgeInsets.symmetric(horizontal: 8),
//                               width: 58,
//                               height: 58,
//                               decoration: BoxDecoration(
//                                 color: const Color(0xFFd4af37).withOpacity(0.18),
//                                 borderRadius: BorderRadius.circular(10),
//                                 border: Border.all(
//                                   color: const Color(0xFFd4af37).withOpacity(0.5),
//                                   width: 1.5,
//                                 ),
//                               ),
//                               child: Center(
//                                 child: TextField(
//                                   controller: _boxCtrl[i],
//                                   focusNode: _focusNodes[i],
//                                   textAlign: TextAlign.center,
//                                   keyboardType: TextInputType.number,
//                                   maxLength: 1,
//                                   style: const TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 22,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                   decoration: const InputDecoration(
//                                     border: InputBorder.none,
//                                     counterText: '',
//                                     isDense: true,
//                                     contentPadding: EdgeInsets.zero,
//                                   ),
//                                   onChanged: (v) {
//                                     if (v.isNotEmpty && i < 3) {
//                                       FocusScope.of(context)
//                                           .requestFocus(_focusNodes[i + 1]);
//                                     } else if (v.isEmpty && i > 0) {
//                                       FocusScope.of(context)
//                                           .requestFocus(_focusNodes[i - 1]);
//                                     }
//                                   },
//                                 ),
//                               ),
//                             );
//                           }),
//                         ),
//                         const SizedBox(height: 24),

//                         // Resend OTP
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             const Text(
//                               "Didn't get the OTP?  ",
//                               style:
//                                   TextStyle(color: Colors.white38, fontSize: 12),
//                             ),
//                             GestureDetector(
//                               onTap: () {
//                                 ScaffoldMessenger.of(context)
//                                     .showSnackBar(const SnackBar(
//                                   content: Text('OTP resent!'),
//                                   backgroundColor: Color(0xFFd4af37),
//                                 ));
//                               },
//                               child: const Text(
//                                 'Resend OTP',
//                                 style: TextStyle(
//                                   color: Color(0xFFd4af37),
//                                   fontSize: 12,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 56),

//                         // Verify OTP button (solid color)
//                         _SolidButton(label: 'Verify OTP', onTap: _onVerify),
//                         const SizedBox(height: 30),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               const Padding(
//                 padding: EdgeInsets.only(bottom: 18),
//                 child: _FooterText(),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// PageRouteBuilder _slideRoute(Widget page) => PageRouteBuilder(
//       pageBuilder: (_, __, ___) => page,
//       transitionsBuilder: (_, anim, __, child) => SlideTransition(
//         position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
//             .animate(CurvedAnimation(parent: anim, curve: Curves.easeInOut)),
//         child: child,
//       ),
//       transitionDuration: const Duration(milliseconds: 400),
//     );

// // ---------------- Widgets ----------------
// class _SolidButton extends StatelessWidget {
//   final String label;
//   final VoidCallback onTap;
//   const _SolidButton({required this.label, required this.onTap});

//   @override
//   Widget build(BuildContext context) => GestureDetector(
//         onTap: onTap,
//         child: Container(
//           width: double.infinity,
//           height: 52,
//           decoration: BoxDecoration(
//             color: const Color(0xFFd4af37),
//             borderRadius: BorderRadius.circular(30),
//           ),
//           child: Center(
//             child: Text(label,
//                 style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 15,
//                     fontWeight: FontWeight.bold,
//                     letterSpacing: 0.8)),
//           ),
//         ),
//       );
// }

// class _FooterText extends StatelessWidget {
//   const _FooterText();
//   @override
//   Widget build(BuildContext context) => const Text(
//         'Powered By FuelConnect Version 1.0.0',
//         style: TextStyle(color: Colors.white24, fontSize: 11),
//       );
// }