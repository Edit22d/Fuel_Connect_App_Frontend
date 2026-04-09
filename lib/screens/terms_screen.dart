import 'package:flutter/material.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

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
          'Terms & Conditions',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TERMS & CONDITIONS title
            const Center(
              child: Text(
                'TERMS & CONDITIONS',
                style: TextStyle(
                  color: Color(0xFFC4963D),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Divider line
            Container(
              height: 1,
              width: double.infinity,
              color: const Color(0xFFC4963D),
            ),
            const SizedBox(height: 20),
            
            // Terms of Service
            const Text(
              'Terms of Service',
              style: TextStyle(
                color: Color(0xFFC4963D),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Last updated: 2023-01-05',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            
            // Divider line
            Container(
              height: 1,
              width: double.infinity,
              color: Colors.white24,
            ),
            const SizedBox(height: 24),
            
            // 1. ACCEPTANCE OF TERMS
            const Text(
              '1. ACCEPTANCE OF TERMS',
              style: TextStyle(
                color: Color(0xFFC4963D),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'By accessing this app and the FanZone® application, you agree to be bound by these terms. You may not access or use the app if you do not accept these terms. If you continue to access or use the app after reading these terms, your continued access constitutes acceptance of these terms.',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            
            // 2. GENERAL DISCLAIMER
            const Text(
              '2. GENERAL DISCLAIMER',
              style: TextStyle(
                color: Color(0xFFC4963D),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Fan Zone is a platform for fans to share their experiences and connect with other fans. Fan Zone does not endorse any product or service mentioned in the app. Fan Zone is not responsible for any damages that may occur as a result of using the app. Fan Zone disclaims all liability for any losses or damages that may arise from the use of the app.',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            
            // 3. USER IDENTIFICATION
            const Text(
              '3. USER IDENTIFICATION',
              style: TextStyle(
                color: Color(0xFFC4963D),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Users are required to provide accurate identification information when registering on the app. Failure to provide accurate identification may result in the temporary suspension of user accounts. Users must also provide accurate contact information when registering on the app.',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            
            // 4. PROVIDE AND INTERNET ACCESS
            const Text(
              '4. PROVIDE AND INTERNET ACCESS',
              style: TextStyle(
                color: Color(0xFFC4963D),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Fan Zone reserves the right to suspend or terminate an account if it becomes aware of any suspicious activity or if there is evidence of fraudulent behavior. Users are responsible for ensuring they have adequate internet access and connectivity to use the app.',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            
            // 5. CANCELLATION POLICY
            const Text(
              '5. CANCELLATION POLICY',
              style: TextStyle(
                color: Color(0xFFC4963D),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Fan Zone has the right to cancel or suspend an account at any time without prior notice. Cancellation policies may vary depending on the type of account and the specific circumstances. Users should review Fan Zone\'s cancellation policy before signing up for an account.',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            
            // 6. LIABILITY
            const Text(
              '6. LIABILITY',
              style: TextStyle(
                color: Color(0xFFC4963D),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Fan Zone assumes no responsibility for any damages or losses that may occur as a result of using the app. Users should consult with legal professionals before using the app.',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            
            // 7. GUARANTEE
            const Text(
              '7. GUARANTEE',
              style: TextStyle(
                color: Color(0xFFC4963D),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Fan Zone offers a guarantee that the app will work properly for a certain period of time. The length of the guarantee varies depending on the type of account and the specific circumstances. Users should review Fan Zone\'s guarantee policy before using the app.',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            
            // 8. TERMINATION
            const Text(
              '8. TERMINATION',
              style: TextStyle(
                color: Color(0xFFC4963D),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Fan Zone may terminate or suspend an account if it becomes aware of any violations of these terms. Termination may include the termination of the account and any associated services.',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            
            // 9. AGREEMENT TERMS & CONDITIONS
            const Text(
              '9. AGREEMENT TERMS & CONDITIONS',
              style: TextStyle(
                color: Color(0xFFC4963D),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'By using this app, you acknowledge that you have read, understood, and agree to be bound by these Terms & Conditions.',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}