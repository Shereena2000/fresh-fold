import 'package:flutter/material.dart';
import 'package:fresh_fold/Settings/common/widgets/custom_app_bar.dart';
import 'package:fresh_fold/Settings/utils/p_colors.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Privacy Policy'),
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
      child: Column(
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
          'Fresh Fold ("we," "our," or "us") is committed to protecting your privacy. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our mobile application for laundry booking and delivery services.',
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
          '• Saved addresses for laundry pickup and delivery locations\n'
          '• We collect location data only when you use our services and with your explicit permission',
          style: TextStyle(fontSize: 14, height: 1.5),
        ),
        SizedBox(height: 16),
        SubSectionTitle(title: '1.3 Service and Order Information'),
        Text(
          '• Laundry service preferences (wash type, service type)\n'
          '• Booking and scheduling information\n'
          '• Order history, status, and tracking details\n'
          '• Order cancellation records\n'
          '• Pickup schedules\n'
          '• Payment amounts and Cash on Delivery (COD) transaction records\n'
          '• Service provider assignment details',
          style: TextStyle(fontSize: 14, height: 1.5),
        ),
        SizedBox(height: 16),
        SubSectionTitle(title: '1.4 Device Information'),
        Text(
          '• Device type and operating system\n'
          '• Unique device identifiers\n'
          '• App usage statistics and preferences',
          style: TextStyle(fontSize: 14, height: 1.5),
        ),
        SizedBox(height: 16),
        SubSectionTitle(title: '1.5 Firebase Services Data'),
        Text(
          'We use Firebase services which may collect:\n'
          '• Authentication data\n'
          '• Cloud Firestore database information\n'
          '• App performance and crash data\n'
          '• User preferences stored via SharedPreferences',
          style: TextStyle(fontSize: 14, height: 1.5),
        ),
        SizedBox(height: 24),

        // Section 2
        SectionTitle(title: '2. HOW WE USE YOUR INFORMATION'),
        Text(
          'We use collected information to:\n'
          '• Create and manage your account\n'
          '• Process and fulfill laundry service bookings\n'
          '• Schedule and reschedule pickup and delivery services\n'
          '• Process order cancellations\n'
          '• Connect you with service providers (vendors) for order fulfillment\n'
          '• Display and update order status in real-time\n'
          '• Calculate and display service charges\n'
          '• Record Cash on Delivery (COD) payment confirmations\n'
          '• Provide location-based services via Google Maps\n'
          '• Send service notifications, order updates, and reminders\n'
          '• Maintain order history and transaction records\n'
          '• Improve our app functionality and user experience\n'
          '• Respond to customer support inquiries\n'
          '• Ensure app security and prevent fraud',
          style: TextStyle(fontSize: 14, height: 1.5),
        ),
        SizedBox(height: 24),

        // Section 3
        SectionTitle(title: '3. ORDER AND PAYMENT PROCESS'),
        SubSectionTitle(title: '3.1 Order Workflow'),
        Text(
          '• Clients book and schedule laundry services through the app\n'
          '• Service providers (vendors) are assigned to pickup orders\n'
          '• Vendors collect laundry items at scheduled times\n'
          '• After processing, vendors set the payment amount based on services rendered\n'
          '• Clients can view the payment amount in the app\n'
          '• All payments are Cash on Delivery (COD) only',
          style: TextStyle(fontSize: 14, height: 1.5),
        ),
        SizedBox(height: 16),
        SubSectionTitle(title: '3.2 Payment Information'),
        Text(
          '• We DO NOT collect or store any credit card, debit card, or banking information\n'
          '• All payments are handled as Cash on Delivery (COD)\n'
          '• Vendors record payment confirmation in the app after receiving cash payment\n'
          '• We maintain records of payment amounts and confirmation status for order tracking and business purposes',
          style: TextStyle(fontSize: 14, height: 1.5),
        ),
        SizedBox(height: 16),
        SubSectionTitle(title: '3.3 Order Management'),
        Text(
          '• Clients can view order status and payment details\n'
          '• Orders can be cancelled through the app before pickup\n'
          '• Order history is maintained for your reference\n'
          '• Payment status is updated by vendors upon cash collection',
          style: TextStyle(fontSize: 14, height: 1.5),
        ),
        SizedBox(height: 24),

        // Section 4
        SectionTitle(title: '4. LOCATION DATA USAGE'),
        Text(
          'We collect and use location data to:\n'
          '• Enable accurate pickup and delivery address selection\n'
          '• Display your current location on Google Maps\n'
          '• Help service providers locate pickup and delivery addresses\n'
          '• Save frequently used addresses for convenience\n'
          '• Optimize routing for efficient service\n\n'
          'You can disable location permissions in your device settings, but this will limit the core functionality of booking and scheduling services.',
          style: TextStyle(fontSize: 14, height: 1.5),
        ),
        SizedBox(height: 24),

        // Section 5
        SectionTitle(title: '5. DATA SHARING AND DISCLOSURE'),
        SubSectionTitle(title: '5.1 We DO NOT sell your personal information.'),
        SizedBox(height: 8),
        SubSectionTitle(title: '5.2 We share information with:'),
        Text(
          '• Service Providers (Vendors): We share necessary order details (name, contact, address, order preferences) with assigned vendors to fulfill your laundry service requests\n'
          '• Technology Service Providers: Firebase (Google) for authentication and data storage, Google Maps Platform for location services\n'
          '• Legal Authorities: If required by law or to protect our rights and safety',
          style: TextStyle(fontSize: 14, height: 1.5),
        ),
        SizedBox(height: 16),
        SubSectionTitle(title: '5.3 Vendor Access'),
        Text(
          'Service providers (vendors) have access to:\n'
          '• Your name and contact information\n'
          '• Pickup and delivery addresses\n'
          '• Service preferences and special instructions\n'
          '• Order scheduling information\n'
          '• Payment amounts (set by them) and payment status',
          style: TextStyle(fontSize: 14, height: 1.5),
        ),
        SizedBox(height: 24),

        // Section 6
        SectionTitle(title: '6. THIRD-PARTY SERVICES'),
        Text(
          'Our app uses the following third-party services:\n\n'
          'Google Maps Platform\n'
          '• For location services and map display\n'
          '• Subject to Google\'s Privacy Policy\n\n'
          'Firebase (Google)\n'
          '• Authentication and user management\n'
          '• Cloud Firestore database for data storage\n'
          '• Subject to Firebase Privacy Policy\n\n'
          'Geolocator & Geocoding\n'
          '• For location detection and address conversion\n\n'
          'We recommend reviewing the privacy policies of these third-party services.',
          style: TextStyle(fontSize: 14, height: 1.5),
        ),
        SizedBox(height: 24),

        // Section 7
        SectionTitle(title: '7. DATA SECURITY'),
        Text(
          'We implement industry-standard security measures:\n'
          '• Encrypted data transmission\n'
          '• Secure Firebase authentication\n'
          '• Protected cloud storage via Cloud Firestore\n'
          '• Secure API key management\n'
          '• Regular security updates\n'
          '• Access controls for vendor and client data\n\n'
          'However, no method of electronic transmission or storage is 100% secure. While we strive to protect your information, we cannot guarantee absolute security.',
          style: TextStyle(fontSize: 14, height: 1.5),
        ),
        SizedBox(height: 24),

        // Section 8
        SectionTitle(title: '8. DATA RETENTION'),
        Text(
          '• Active account data: Retained while your account is active\n'
          '• Order history: Retained for record-keeping and service improvement\n'
          '• Payment records: Maintained for business accounting purposes\n'
          '• Deleted accounts: Personal data removed within 30 days of account deletion request\n'
          '• Transaction records may be retained longer as required by applicable laws',
          style: TextStyle(fontSize: 14, height: 1.5),
        ),
        SizedBox(height: 24),

        // Section 9
        SectionTitle(title: '9. YOUR RIGHTS'),
        Text(
          'You have the right to:\n'
          '• Access your personal data stored in our system\n'
          '• Correct inaccurate or incomplete information\n'
          '• Delete your account and associated personal data\n'
          '• View your complete order history\n'
          '• Withdraw location permissions (may limit app functionality)\n'
          '• Opt-out of non-essential communications\n'
          '• Cancel orders before vendor pickup\n'
          '• Request information about data shared with vendors\n\n'
          'To exercise these rights, contact us at freshfold.growblic@gmail.com',
          style: TextStyle(fontSize: 14, height: 1.5),
        ),
        SizedBox(height: 24),

        // Section 10
        SectionTitle(title: '10. CHILDREN\'S PRIVACY'),
        Text(
          'Our app is not intended for users under 13 years of age. We do not knowingly collect personal information from children under 13. If we discover that we have collected information from a child under 13, we will delete it immediately.',
          style: TextStyle(fontSize: 14, height: 1.5),
        ),
        SizedBox(height: 24),

        // Section 11
        SectionTitle(title: '11. ANDROID PERMISSIONS REQUIRED'),
        Text(
          'The app requires the following Android permissions:\n\n'
          '• ACCESS_FINE_LOCATION: For precise pickup and delivery location selection\n'
          '• ACCESS_COARSE_LOCATION: For approximate location services\n'
          '• INTERNET: For app functionality, cloud services, and real-time updates\n'
          '• DIAL (query): To allow you to contact customer support or vendors via phone\n'
          '• PROCESS_TEXT (query): For text processing features\n\n'
          'You can manage these permissions in your device settings.',
          style: TextStyle(fontSize: 14, height: 1.5),
        ),
        SizedBox(height: 24),

        // Section 12
        SectionTitle(title: '12. CHANGES TO THIS POLICY'),
        Text(
          'We may update this Privacy Policy periodically to reflect changes in our practices or for legal, operational, or regulatory reasons. We will notify you of significant changes through:\n'
          '• In-app notifications\n'
          '• Email notifications\n'
          '• Updated "Last Updated" date at the top of this policy\n\n'
          'Continued use of the app after changes constitutes your acceptance of the updated policy.',
          style: TextStyle(fontSize: 14, height: 1.5),
        ),
        SizedBox(height: 24),

        // Section 13
        SectionTitle(title: '13. ANALYTICS AND TRACKING'),
        Text(
          'We do not use cookies in our mobile app. Firebase Analytics may be used to collect anonymous usage data to improve app performance and user experience. This data is aggregated and does not identify individual users.',
          style: TextStyle(fontSize: 14, height: 1.5),
        ),
        SizedBox(height: 24),

        // Section 14
        SectionTitle(title: '14. INTERNATIONAL DATA TRANSFERS'),
        Text(
          'Your data may be transferred to and stored on servers located outside your country, including servers operated by Firebase/Google. We ensure appropriate safeguards are in place for such transfers in compliance with applicable data protection laws.',
          style: TextStyle(fontSize: 14, height: 1.5),
        ),
        SizedBox(height: 24),

        // Section 15
        SectionTitle(title: '15. CONTACT US'),
        Text(
          'For privacy concerns, questions, or to exercise your rights:\n\n'
          'Fresh Fold\n'
          'Email: freshfold.growblic@gmail.com\n\n'
          'We will respond to your inquiries within a reasonable timeframe.',
          style: TextStyle(fontSize: 14, height: 1.5),
        ),
        SizedBox(height: 24),

        // Section 16
        SectionTitle(title: '16. LEGAL COMPLIANCE'),
        Text(
          'This Privacy Policy complies with:\n'
          '• General Data Protection Regulation (GDPR) for EU users\n'
          '• Information Technology Act, 2000 and related rules (India)\n'
          '• Other applicable data protection and privacy laws\n\n'
          'If you are located in the European Union or other regions with data protection laws, you have additional rights under those regulations.',
          style: TextStyle(fontSize: 14, height: 1.5),
        ),
        SizedBox(height: 24),

        // Section 17
        SectionTitle(title: '17. YOUR CONSENT'),
        Text(
          'By using Fresh Fold, you acknowledge that you have read and understood this Privacy Policy and agree to its terms. If you do not agree with this policy, please do not use our app.\n\n'
          'For any questions or concerns:\n'
          'Email: freshfold.growblic@gmail.com',
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: PColors.primaryColor,
        ),
      ),
    );
  }
}

class SubSectionTitle extends StatelessWidget {
  final String title;

  const SubSectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: PColors.black,
        ),
      ),
    );
  }
}