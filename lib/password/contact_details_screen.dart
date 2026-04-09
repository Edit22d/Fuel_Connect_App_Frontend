// import 'package:flutter/material.dart';
// import 'profile_details_screen.dart';
// import 'shared_widgets.dart';

// class ContactDetailsScreen extends StatefulWidget {
//   const ContactDetailsScreen({Key? key}) : super(key: key);

//   @override
//   State<ContactDetailsScreen> createState() => _ContactDetailsScreenState();
// }

// class _ContactDetailsScreenState extends State<ContactDetailsScreen>
//     with SingleTickerProviderStateMixin {
//   final _emailCtrl  = TextEditingController();
//   final _mobileCtrl = TextEditingController();

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
//         Tween<Offset>(begin: const Offset(0, 0.07), end: Offset.zero)
//             .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
//     _ctrl.forward();
//   }

//   @override
//   void dispose() {
//     _ctrl.dispose();
//     _emailCtrl.dispose();
//     _mobileCtrl.dispose();
//     super.dispose();
//   }

//   void _onNext() =>
//       Navigator.push(context, slideRoute(const ProfileDetailsScreen()));

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
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         const SizedBox(height: 16),
//                         FuelConnectLogo(),
//                         const SizedBox(height: 8),
//                         const Text('Contact Details',
//                             style: TextStyle(
//                                 color: Colors.white54,
//                                 fontSize: 11,
//                                 letterSpacing: 1)),
//                         const SizedBox(height: 16),
//                         const Text(
//                           'Enter your\ncontact details',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                               color: Color(0xFFd4af37),
//                               fontSize: 26,
//                               fontWeight: FontWeight.bold,
//                               height: 1.3),
//                         ),
//                         const SizedBox(height: 40),
//                         UnderlineField(
//                           label: 'Email ID',
//                           hint: 'Email ID',
//                           controller: _emailCtrl,
//                           keyboardType: TextInputType.emailAddress,
//                         ),
//                         const SizedBox(height: 20),
//                         UnderlineField(
//                           label: 'Mobile No.',
//                           hint: 'Mobile No.',
//                           controller: _mobileCtrl,
//                           keyboardType: TextInputType.phone,
//                         ),
//                         const SizedBox(height: 56),
//                         // Solid "Next" button
//                         GestureDetector(
//                           onTap: _onNext,
//                           child: Container(
//                             height: 50,
//                             width: double.infinity,
//                             alignment: Alignment.center,
//                             decoration: BoxDecoration(
//                               color: const Color(0xFFd4af37),
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             child: const Text(
//                               'Next',
//                               style: TextStyle(
//                                 color: Color(0xFF0D1117),
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ),
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