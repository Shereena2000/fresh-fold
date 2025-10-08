import 'package:flutter/material.dart';
import 'package:fresh_fold/Settings/common/widgets/custom_app_bar.dart';
import 'package:fresh_fold/Settings/utils/p_colors.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:CustomAppBar(title: 'Privacy Policy'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildPrivacyPolicyContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SizedBox(
      width: double.infinity,
    
      child:  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PRIVACY POLICY FOR FRESH FOLD',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: PColors.primaryColor,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Last Updated: October 2025',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: PColors.secondoryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyPolicyContent() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Fresh Fold ("we," "our," or "us") is committed to protecting your privacy. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our mobile application.',
          style: TextStyle(fontSize: 14, height: 1.5),
        ),
        SizedBox(height: 24),
        
        // Section 1
        SectionTitle(title: '1. INFORMATION WE COLLECT'),
        SubSectionTitle(title: '1.1 Personal Information'),
        Text(
          '• Name and email address\n'
          '• Phone number\n'
          '• Account credentials (username and password)\n'
          '• Profile information (gender, date of birth, profession, location)\n'
          '• Alternative contact numbers',
          style: TextStyle(fontSize: 14, height: 1.5),
        ),
        SizedBox(height: 16),
        SubSectionTitle(title: '1.2 Location Information'),
        Text(
          '• Precise location data (GPS) for pickup and delivery services\n'
          '• Saved addresses for laundry pickup locations\n'
          '• We collect location data only when you use our services and with your explicit permission',
          style: TextStyle(fontSize: 14, height: 1.5),
        ),
        SizedBox(height: 16),
        SubSectionTitle(title: '1.3 Service Information'),
        Text(
          '• Laundry service preferences (wash type, service type)\n'
          '• Schedule and booking information\n'
          '• Order history and status',
          style: TextStyle(fontSize: 14, height: 1.5),
        ),
        SizedBox(height: 16),
        SubSectionTitle(title: '1.4 Device Information'),
        Text(
          '• Device type and operating system\n'
          '• Unique device identifiers\n'
          '• App usage statistics',
          style: TextStyle(fontSize: 14, height: 1.5),
        ),
        SizedBox(height: 16),
        SubSectionTitle(title: '1.5 Firebase Services'),
        Text(
          'We use Firebase services which may collect:\n'
          '• Authentication data\n'
          '• Cloud Firestore database information\n'
          '• App performance and crash data',
          style: TextStyle(fontSize: 14, height: 1.5),
        ),
        SizedBox(height: 24),

        // Section 2
        SectionTitle(title: '2. HOW WE USE YOUR INFORMATION'),
        Text(
          'We use collected information to:\n'
          '• Create and manage your account\n'
          '• Process and fulfill laundry service requests\n'
          '• Schedule pickup and delivery services\n'
          '• Provide location-based services\n'
          '• Send service notifications and updates\n'
          '• Improve our app functionality and user experience\n'
          '• Respond to customer support inquiries\n'
          '• Ensure app security and prevent fraud',
          style: TextStyle(fontSize: 14, height: 1.5),
        ),
        SizedBox(height: 24),

        // Section 3
        SectionTitle(title: '3. LOCATION DATA USAGE'),
        Text(
          'We collect location data to:\n'
          '• Enable accurate pickup and delivery address selection\n'
          '• Display your location on Google Maps\n'
          '• Provide efficient routing for our service providers\n'
          '• Save frequently used addresses\n\n'
          'You can disable location permissions in your device settings, but this may limit app functionality.',
          style: TextStyle(fontSize: 14, height: 1.5),
        ),
        SizedBox(height: 24),

        // Section 4
        SectionTitle(title: '4. DATA SHARING AND DISCLOSURE'),
        SubSectionTitle(title: '4.1 We DO NOT sell your personal information.'),
        SubSectionTitle(title: '4.2 We may share information with:'),
        Text(
          '• Service providers who assist in app operations (Firebase, Google Maps)\n'
          '• Laundry service partners for order fulfillment\n'
          '• Legal authorities if required by law',
          style: TextStyle(fontSize: 14, height: 1.5),
        ),
        SizedBox(height: 24),

        // Section 5
        SectionTitle(title: '5. THIRD-PARTY SERVICES'),
        Text(
          'Our app uses third-party services:\n\n'
          'Google Maps Platform\n'
          '• For location services and map display\n'
          '• Subject to Google\'s Privacy Policy\n\n'
          'Firebase (Google)\n'
          '• Authentication\n'
          '• Cloud Firestore database\n'
          '• Subject to Firebase Privacy Policy',
          style: TextStyle(fontSize: 14, height: 1.5),
        ),
        SizedBox(height: 24),

        // Section 6
        SectionTitle(title: '6. DATA SECURITY'),
        Text(
          'We implement industry-standard security measures:\n'
          '• Encrypted data transmission\n'
          '• Secure Firebase authentication\n'
          '• Protected cloud storage\n'
          '• Regular security updates\n\n'
          'However, no method of electronic storage is 100% secure.',
          style: TextStyle(fontSize: 14, height: 1.5),
        ),
        SizedBox(height: 24),

        // Section 7
        SectionTitle(title: '7. DATA RETENTION'),
        Text(
          '• Active account data: Retained while your account is active\n'
          '• Deleted accounts: Data removed within 30 days of account deletion\n'
          '• Service history: May be retained for business records as required by law',
          style: TextStyle(fontSize: 14, height: 1.5),
        ),
        SizedBox(height: 24),

        // Section 8
        SectionTitle(title: '8. YOUR RIGHTS'),
        Text(
          'You have the right to:\n'
          '• Access your personal data\n'
          '• Correct inaccurate information\n'
          '• Delete your account and associated data\n'
          '• Withdraw location permissions\n'
          '• Opt-out of non-essential communications\n\n'
          'To exercise these rights, contact us at shereenajamezz@gmail.com',
          style: TextStyle(fontSize: 14, height: 1.5),
        ),
        SizedBox(height: 24),

        // Section 9
        SectionTitle(title: '9. CHILDREN\'S PRIVACY'),
        Text(
          'Our app is not intended for users under 13 years of age. We do not knowingly collect information from children under 13.',
          style: TextStyle(fontSize: 14, height: 1.5),
        ),
        SizedBox(height: 24),

        // Section 10
        SectionTitle(title: '10. PERMISSIONS REQUIRED'),
        Text(
          'Android Permissions:\n'
          '• ACCESS_FINE_LOCATION: For precise pickup location\n'
          '• ACCESS_COARSE_LOCATION: For approximate location services\n'
          '• INTERNET: For app functionality and cloud services',
          style: TextStyle(fontSize: 14, height: 1.5),
        ),
        SizedBox(height: 24),

        // Section 11
        SectionTitle(title: '11. PAYMENT INFORMATION'),
        Text(
          'Currently, our app does not process payments. When payment features are added, we will update this policy and implement secure payment processing through certified third-party providers. We will never store credit card information on our servers.',
          style: TextStyle(fontSize: 14, height: 1.5),
        ),
        SizedBox(height: 24),

        // Section 12
        SectionTitle(title: '12. CHANGES TO THIS POLICY'),
        Text(
          'We may update this Privacy Policy periodically. We will notify you of significant changes through:\n'
          '• In-app notifications\n'
          '• Email notifications\n'
          '• Updated "Last Updated" date\n\n'
          'Continued use of the app after changes constitutes acceptance of the updated policy.',
          style: TextStyle(fontSize: 14, height: 1.5),
        ),
        SizedBox(height: 24),

        // Section 13
        SectionTitle(title: '13. COOKIES AND TRACKING'),
        Text(
          'We do not use cookies in our mobile app. Firebase may use analytics to improve service quality.',
          style: TextStyle(fontSize: 14, height: 1.5),
        ),
        SizedBox(height: 24),

        // Section 14
        SectionTitle(title: '14. INTERNATIONAL DATA TRANSFERS'),
        Text(
          'Your data may be transferred to and stored on servers located outside your country. We ensure appropriate safeguards are in place for such transfers.',
          style: TextStyle(fontSize: 14, height: 1.5),
        ),
        SizedBox(height: 24),

        // Section 15
        SectionTitle(title: '15. CONTACT US'),
        Text(
          'For privacy concerns or questions:\n'
          'Fresh Fold\n'
          'Email: shereenajamezz@gmail.com',
          style: TextStyle(fontSize: 14, height: 1.5),
        ),
        SizedBox(height: 24),

        // Section 16
        SectionTitle(title: '16. COMPLIANCE'),
        Text(
          'This Privacy Policy complies with:\n'
          '• General Data Protection Regulation (GDPR) for EU users\n'
          '• Information Technology Act, 2000 (India)\n'
          '• Other applicable data protection laws',
          style: TextStyle(fontSize: 14, height: 1.5),
        ),
        SizedBox(height: 24),

        // Section 17
        SectionTitle(title: '17. YOUR CONSENT'),
        Text(
          'By using Fresh Fold, you consent to this Privacy Policy and agree to its terms.\n\n'
          'Email: shereenajamezz@gmail.com',
          style: TextStyle(fontSize: 14, height: 1.5),
        ),
        SizedBox(height: 40),
      ],
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style:  TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: PColors.primaryColor,
      ),
    );
  }
}

class SubSectionTitle extends StatelessWidget {
  final String title;

  const SubSectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style:  TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color:PColors.black,
      ),
    );
  }
}