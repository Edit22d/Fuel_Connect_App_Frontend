// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MaterialApp(
//     home: OnboardingScreen(),
//     debugShowCheckedModeBanner: false,
//   ));
// }

// class OnboardingScreen extends StatelessWidget {
//   const OnboardingScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white, // Clean white background like the screenshot
//       body: SafeArea(
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // Spacer to push content slightly up visually if needed
//               const Spacer(),
              
//               // THE GAUGE / LOGO
//               // We use your specified asset path
//               Container(
//                 width: 280, // Adjust size to match the screenshot ratio
//                 height: 280,
//                 decoration: BoxDecoration(
//                   // Adding a subtle shadow to match the floating feel in the image
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.1),
//                       blurRadius: 20,
//                       spreadRadius: 5,
//                     ),
//                   ],
//                 ),
//                 child: Image.asset(
//                   'assets/images/logo.png',
//                   fit: BoxFit.contain,
//                   // Fallback UI in case the image isn't found yet
//                   errorBuilder: (context, error, stackTrace) {
//                     return Container(
//                       color: Colors.grey[200],
//                       child: const Center(
//                         child: Text("Image not found"),
//                       ),
//                     );
//                   },
//                 ),
//               ),

//               const SizedBox(height: 40),

//               // TEXT: FUEL DELIVERY
//               // Styled with wide letter spacing (letterSpacing) and bold weight
//               const Text(
//                 "FUEL DELIVERY",
//                 style: TextStyle(
//                   fontSize: 26,
//                   fontWeight: FontWeight.w800,
//                   letterSpacing: 3.5, // Wide spacing like in the screenshot
//                   color: Colors.black87,
//                 ),
//               ),

//               const Spacer(),

//               // Optional: A "Next" or "Get Started" button placeholder
//               // (Since the screenshot is cut off, I am adding a standard button here)
//               Padding(
//                 padding: const EdgeInsets.only(bottom: 40.0),
//                 child: ElevatedButton(
//                   onPressed: () {
//                     // Add navigation logic here
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.blue[600], // Matching the pointer color
//                     padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                     elevation: 5,
//                   ),
//                   child: const Text(
//                     "GET STARTED",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                       letterSpacing: 1.2,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }