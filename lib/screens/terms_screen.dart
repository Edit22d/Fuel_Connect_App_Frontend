import 'package:flutter/material.dart';
import '../auth/theme.dart';

class TermsScreen extends StatelessWidget {
  final String section; // 'terms' or 'privacy'
  const TermsScreen({super.key, this.section = 'terms'});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF0D0D0D) : const Color(0xFFF7F7F9);
    final surface = isDark ? const Color(0xFF1A1A1A) : Colors.white;
    final textPrimary = isDark ? Colors.white : const Color(0xFF111111);
    final textSecondary = isDark ? Colors.white60 : Colors.black54;
    final divider = isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE5E5E5);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: textPrimary, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          section == 'terms' ? 'Terms & Conditions' : 'Privacy Policy',
          style: TextStyle(
            color: textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: AppTheme.gold.withOpacity(0.3), width: 1),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.gold.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      section == 'terms'
                          ? Icons.gavel_rounded
                          : Icons.privacy_tip_rounded,
                      color: AppTheme.gold,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    section == 'terms'
                        ? 'TERMS & CONDITIONS'
                        : 'PRIVACY POLICY',
                    style: const TextStyle(
                      color: AppTheme.gold,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Fuel Connect Mobile Delivery Platform',
                    style: TextStyle(
                      color: textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    section == 'terms'
                        ? 'Last updated: June 10, 2026'
                        : 'Last updated: June 10, 2026',
                    style: TextStyle(
                      color: textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Gold divider
            Container(
              height: 2,
              decoration: BoxDecoration(
                gradient: AppTheme.buttonGradient,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            const SizedBox(height: 20),

            if (section == 'terms') ...[
              ..._buildTermsSections(textPrimary, textSecondary, surface, divider),
            ] else ...[
              ..._buildPrivacySections(textPrimary, textSecondary, surface, divider),
            ],

            const SizedBox(height: 32),

            // Footer
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.gold.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: AppTheme.gold.withOpacity(0.2), width: 1),
              ),
              child: Row(
                children: [
                  const Icon(Icons.local_gas_station,
                      color: AppTheme.gold, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Questions? Contact us at\nsupport@fuelconnect.ug',
                      style: TextStyle(
                        color: textSecondary,
                        fontSize: 12,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildTermsSections(Color textPrimary, Color textSecondary,
      Color surface, Color divider) {
    final sections = [
      {
        'title': '1. ACCEPTANCE OF TERMS',
        'icon': Icons.check_circle_outline_rounded,
        'content':
            'By downloading, installing, or using the Fuel Connect mobile delivery application ("App"), you agree to be fully bound by these Terms & Conditions. Fuel Connect is a licensed fuel delivery platform operating under applicable petroleum distribution laws. If you do not agree to these terms, you must immediately cease using the App and delete it from your device.',
      },
      {
        'title': '2. FUEL DELIVERY SERVICE',
        'icon': Icons.local_shipping_rounded,
        'content':
            'Fuel Connect facilitates on-demand mobile delivery of petroleum products (petrol, diesel, and kerosene) directly to your verified location. Orders are fulfilled by our certified delivery partners. Delivery is available within designated service zones only. Minimum order quantities and delivery time windows apply depending on your area. We reserve the right to refuse delivery to any location we deem unsafe, inaccessible, or restricted by local fire safety regulations.',
      },
      {
        'title': '3. PAYMENT & PRICING',
        'icon': Icons.payment_rounded,
        'content':
            'All fuel prices are displayed per litre and are subject to change in line with the Energy Regulatory Authority guidelines. Payment is processed securely at the point of order through supported mobile money platforms, debit/credit cards, and Fuel Connect wallet. A delivery service fee applies per order. Fuel Connect does not store your full card or mobile money credentials — all transactions are encrypted end-to-end via our PCI-DSS certified payment gateway.',
      },
      {
        'title': '4. DRIVER & DELIVERY STANDARDS',
        'icon': Icons.verified_user_rounded,
        'content':
            'All Fuel Connect delivery drivers are background-checked, certified in fuel handling, and carry valid petroleum transport licenses. Drivers operate approved tanker vehicles fitted with anti-spill equipment and safety shut-off valves. Any driver misconduct, dangerous behaviour, or safety violation should be reported immediately through the in-app support feature. Fuel Connect maintains zero tolerance for drivers handling fuel in an unsafe manner.',
      },
      {
        'title': '5. USER RESPONSIBILITIES',
        'icon': Icons.person_pin_circle_rounded,
        'content':
            'You must ensure your delivery location is accessible, safe, and compliant with local fire safety regulations. You must be present or have an authorised representative present at the time of delivery. You are responsible for providing suitable and safe storage containers or tanks for the delivered fuel. You must ensure no open flames, sparks, or smoking occurs within 10 metres of the delivery point. You agree not to use the App for any fraudulent, illegal, or resale purposes.',
      },
      {
        'title': '6. CANCELLATION & REFUND POLICY',
        'icon': Icons.cancel_outlined,
        'content':
            'Orders may be cancelled free of charge within 10 minutes of placement. Cancellations made after the driver has departed attract a 15% processing fee. Cancellations at the point of delivery (driver arrived) attract a 25% fee plus transport costs. Refunds for valid cancellations are processed within 2–5 business days to the original payment method. Fuel Connect reserves the right to cancel any order in cases of safety concerns, pricing errors, or stock unavailability, with full refund issued.',
      },
      {
        'title': '7. LIABILITY DISCLAIMER',
        'icon': Icons.gavel_rounded,
        'content':
            'Fuel Connect is not liable for any damages, losses, or injuries arising from the improper storage, handling, or use of delivered fuel by the customer. Our liability for any service failure is limited to the value of the affected order. Fuel Connect is not responsible for delays caused by traffic, weather, or force majeure events beyond our control. We do not guarantee specific delivery times though we strive to meet all stated ETAs.',
      },
      {
        'title': '8. DATA PRIVACY & LOCATION TRACKING',
        'icon': Icons.location_on_rounded,
        'content':
            'Fuel Connect collects your GPS location data solely to facilitate accurate fuel delivery to your location. Location tracking is only active when you have an active or pending order. We do not sell your location data or personal information to third parties. Your data is stored in encrypted servers compliant with applicable data protection laws. You may request deletion of your personal data by contacting support@fuelconnect.ug.',
      },
      {
        'title': '9. ACCOUNT TERMINATION',
        'icon': Icons.block_rounded,
        'content':
            'Fuel Connect reserves the right to suspend or permanently terminate your account if you violate these Terms, engage in fraudulent activity, attempt to circumvent our pricing systems, or use the platform to facilitate illegal fuel trade. Upon termination, all pending orders will be cancelled and refunds issued where applicable. You may appeal a termination decision by contacting our support team within 14 days.',
      },
      {
        'title': '10. GOVERNING LAW',
        'icon': Icons.balance_rounded,
        'content':
            'These Terms & Conditions are governed by the laws of Uganda, including the Petroleum Supply Act and relevant consumer protection regulations. Any disputes arising under these Terms shall be subject to the exclusive jurisdiction of the courts of Kampala, Uganda. Fuel Connect is a registered business operating under the Uganda National Bureau of Standards petroleum distribution guidelines.',
      },
    ];

    return sections
        .map((s) => _buildSection(
              title: s['title'] as String,
              content: s['content'] as String,
              icon: s['icon'] as IconData,
              textPrimary: textPrimary,
              textSecondary: textSecondary,
              surface: surface,
            ))
        .toList();
  }

  List<Widget> _buildPrivacySections(Color textPrimary, Color textSecondary,
      Color surface, Color divider) {
    final sections = [
      {
        'title': '1. INFORMATION WE COLLECT',
        'icon': Icons.data_usage_rounded,
        'content':
            'We collect: Full name, email, phone number, and delivery address when you register. GPS location during active orders. Payment method details (securely tokenised — never stored in plain text). Device information (model, OS version) for App compatibility. Usage data such as order history and preferences to improve our service.',
      },
      {
        'title': '2. HOW WE USE YOUR INFORMATION',
        'icon': Icons.manage_accounts_rounded,
        'content':
            'We use your information to: Process and deliver your fuel orders accurately. Send order status updates and delivery notifications. Verify your identity and prevent fraudulent orders. Personalise your app experience and show relevant fuel promotions. Comply with petroleum distribution regulatory requirements. Improve our App and delivery operations through anonymised analytics.',
      },
      {
        'title': '3. SHARING OF INFORMATION',
        'icon': Icons.share_rounded,
        'content':
            'We share your information only: With the assigned delivery driver (name, phone, and delivery location only). With our payment processing partners for transaction fulfilment. With regulatory authorities if required by law. We never sell your personal data to third-party advertisers or data brokers.',
      },
      {
        'title': '4. DATA SECURITY',
        'icon': Icons.lock_rounded,
        'content':
            'All data transmitted between the App and our servers is encrypted using TLS 1.3. Sensitive credentials are stored using AES-256 encryption. Payment data is handled by PCI-DSS Level 1 certified payment processors. Our servers are hosted on ISO 27001 certified cloud infrastructure with regular penetration testing.',
      },
      {
        'title': '5. YOUR RIGHTS',
        'icon': Icons.verified_rounded,
        'content':
            'You have the right to: Access all personal data we hold about you. Request correction of inaccurate data. Request deletion of your account and associated data. Opt out of marketing communications at any time. Export your order history data. To exercise these rights, contact privacy@fuelconnect.ug.',
      },
      {
        'title': '6. LOCATION DATA',
        'icon': Icons.gps_fixed_rounded,
        'content':
            'Location tracking is used exclusively for delivery purposes. We only access your precise location when you have an active delivery order. Background location is not tracked when the App is closed. Location history is retained for 90 days for dispute resolution purposes, after which it is permanently deleted.',
      },
      {
        'title': '7. COOKIES & ANALYTICS',
        'icon': Icons.analytics_rounded,
        'content':
            'We use anonymised analytics (no personally identifiable information) to understand app performance and improve delivery efficiency. No third-party advertising cookies are used. You can opt out of analytics through the Settings > Privacy menu.',
      },
      {
        'title': '8. CHILDREN\'S PRIVACY',
        'icon': Icons.child_care_rounded,
        'content':
            'The Fuel Connect platform is intended for users aged 18 and above. We do not knowingly collect personal information from minors. If we become aware that a minor has created an account, we will immediately terminate the account and delete all associated data.',
      },
      {
        'title': '9. CHANGES TO THIS POLICY',
        'icon': Icons.update_rounded,
        'content':
            'We may update this Privacy Policy from time to time. Material changes will be notified through in-app alerts and email at least 14 days before they take effect. Continued use of the App after the effective date of changes constitutes acceptance of the updated policy.',
      },
      {
        'title': '10. CONTACT US',
        'icon': Icons.mail_rounded,
        'content':
            'For privacy-related enquiries: Email: privacy@fuelconnect.ug | Phone: +256 (0) 800 100 200 | Address: Fuel Connect Ltd., Plot 14, Industrial Area, Kampala, Uganda.',
      },
    ];

    return sections
        .map((s) => _buildSection(
              title: s['title'] as String,
              content: s['content'] as String,
              icon: s['icon'] as IconData,
              textPrimary: textPrimary,
              textSecondary: textSecondary,
              surface: surface,
            ))
        .toList();
  }

  Widget _buildSection({
    required String title,
    required String content,
    required IconData icon,
    required Color textPrimary,
    required Color textSecondary,
    required Color surface,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppTheme.gold, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: AppTheme.gold,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              content,
              style: TextStyle(
                color: textSecondary,
                fontSize: 13,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}