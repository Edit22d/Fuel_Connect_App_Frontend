import 'package:flutter/material.dart';
import '/screens/home_screen.dart';
import '/screens/station_screen.dart';
import '/screens/settings_screen.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D0D),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Support Center',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Gradient hero section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 0.85,
                  colors: [
                    Color(0xFF0D1117),
                    Color(0xFF0D1117),
                    Color(0xFF1A1A1A),
                  ],
                  stops: [0.0, 0.45, 1.0],
                ),
              ),
              child: Column(
                children: [
                  // Glowing circular icon
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const RadialGradient(
                        colors: [Color(0xFFC4963D), Color(0xFFC4963D)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFC4963D).withOpacity(0.6),
                          blurRadius: 24,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.headset_mic,
                        color: Colors.white, size: 40),
                  ),
                  const SizedBox(height: 20),
                  RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'Contact our\n',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            height: 1.25,
                          ),
                        ),
                        TextSpan(
                          text: '24/7 Support\n',
                          style: TextStyle(
                            color: Color(0xFFC4963D),
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            height: 1.25,
                          ),
                        ),
                        TextSpan(
                          text: 'Team',
                          style: TextStyle(
                            color: Color(0xFFC4963D),
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            height: 1.25,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Our specialists are available around the\nclock to assist you with any inquiries.\nFree of charge for all domestic calls.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 28),
                  // Call Now button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFC4963D),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                      icon: const Icon(Icons.call, size: 18),
                      label: const Text(
                        'Call Now',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Toll-Free: 1-800 SUPPORT-247',
                    style: TextStyle(
                      color: Color(0xFFC4963D),
                      fontSize: 11,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // White background buttons: Chat, Email, FAQ
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildWhiteButton(Icons.chat_bubble_outline, 'Chat'),
                  _buildWhiteButton(Icons.email_outlined, 'Email'),
                  _buildWhiteButton(Icons.help_outline, 'FAQ'),
                ],
              ),
            ),
          ],
        ),
      ),
      // Bottom Navigation Bar - Home, Station, Support, Settings
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF0D0D0D),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFC4963D),
        unselectedItemColor: Colors.white54,
        selectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_gas_station_outlined),
            activeIcon: Icon(Icons.local_gas_station),
            label: 'Station',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.headset_mic_outlined),
            activeIcon: Icon(Icons.headset_mic),
            label: 'Support',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0: // Home
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
              break;
            case 1: // Station
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const StationScreen()),
              );
              break;
            case 2: // Support (current screen)
              // Already on support screen
              break;
            case 3: // Settings
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
              break;
          }
        },
        currentIndex: 2, // Support is selected
      ),
    );
  }

  Widget _buildWhiteButton(IconData icon, String label) {
    return GestureDetector(
      onTap: () {
        // Add functionality for Chat, Email, FAQ buttons here
        if (label == 'Chat') {
          // Chat functionality
        } else if (label == 'Email') {
          // Email functionality
        } else if (label == 'FAQ') {
          // FAQ functionality
        }
      },
      child: Container(
        width: 90,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFFC4963D), size: 26),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFFC4963D),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}