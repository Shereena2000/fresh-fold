import 'package:flutter/material.dart';
import 'package:fresh_fold/Settings/common/widgets/custom_app_bar.dart';

import '../../../Settings/constants/sized_box.dart';
import '../../../Settings/constants/text_styles.dart';
import '../../../Settings/utils/p_colors.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool whatsappNotifications = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Profile"),
      body: 

          // Profile Content
          SingleChildScrollView(
            child: Column(
              children: [
                SizeBoxH(24),
            
                // Contact Information Section
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader('Contact Information'),
                      SizeBoxH(16),
                      _buildContactCard(
                        icon: Icons.email_outlined,
                        label: 'Email',
                        value: 'shereenajamezz@gma...',
                        isVerified: false,
                        onTap: () {},
                      ),
                      SizeBoxH(12),
                      _buildContactCard(
                        icon: Icons.phone_outlined,
                        label: 'Phone Number',
                        value: '7592946170',
                        isVerified: true,
                        onTap: () {},
                      ),
                      SizeBoxH(12),
                      _buildAddButton(
                        'Add Alternative Phone Number',
                        Icons.add_circle_outline,
                        () {},
                      ),
                    ],
                  ),
                ),
            
                SizeBoxH(24),
            
                // Personal Information Section
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader('Personal Information'),
                      SizeBoxH(16),
                      _buildInfoCard(
                        icon: Icons.person_outline,
                        label: 'Gender',
                        value: 'Not specified',
                        onTap: () {},
                      ),
                      SizeBoxH(12),
                      _buildInfoCard(
                        icon: Icons.cake_outlined,
                        label: 'Date of Birth',
                        value: 'Not specified',
                        onTap: () {},
                      ),
                      SizeBoxH(12),
                      _buildInfoCard(
                        icon: Icons.work_outline,
                        label: 'Profession',
                        value: 'Not specified',
                        onTap: () {},
                      ),
                      SizeBoxH(12),
                      _buildInfoCard(
                        icon: Icons.location_city_outlined,
                        label: 'City',
                        value: 'Chennai',
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
            
                SizeBoxH(24),
            
             
            
                SizeBoxH(24),
            
                // Address Section
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildSectionHeader('Saved Addresses'),
                          TextButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.add, size: 20),
                            label: Text('Add'),
                            style: TextButton.styleFrom(
                              foregroundColor: PColors.primaryColor,
                            ),
                          ),
                        ],
                      ),
                      SizeBoxH(16),
                      _buildAddressCard(),
                    ],
                  ),
                ),
            
                SizeBoxH(32),
            
                // Edit Profile Button
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: _buildEditProfileButton(),
                ),
            
                SizeBoxH(32),
              ],
            ),
          ),);
  
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: getTextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: PColors.primaryColor,
      ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String label,
    required String value,
    required bool isVerified,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: PColors.lightGray, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: PColors.primaryColor.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: PColors.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: PColors.primaryColor, size: 24),
                ),
                SizeBoxV(16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: getTextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: PColors.darkGray.withOpacity(0.6),
                        ),
                      ),
                      SizeBoxH(4),
                      Text(
                        value,
                        style: getTextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: PColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isVerified)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: PColors.successGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: PColors.successGreen,
                          size: 16,
                        ),
                        SizeBoxV(4),
                        Text(
                          'Verified',
                          style: getTextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: PColors.successGreen,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: PColors.errorRed.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: PColors.errorRed,
                          size: 16,
                        ),
                        SizeBoxV(4),
                        Text(
                          'Not Verified',
                          style: getTextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: PColors.errorRed,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddButton(String text, IconData icon, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: PColors.primaryColor.withOpacity(0.3),
          width: 1.5,
          style: BorderStyle.solid,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: PColors.primaryColor, size: 22),
                SizeBoxV(10),
                Text(
                  text,
                  style: getTextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: PColors.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: PColors.lightGray, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: PColors.primaryColor.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: PColors.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: PColors.primaryColor, size: 24),
                ),
                SizeBoxV(16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: getTextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: PColors.darkGray.withOpacity(0.6),
                        ),
                      ),
                      SizeBoxH(4),
                      Text(
                        value,
                        style: getTextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: value == 'Not specified'
                              ? PColors.darkGray.withOpacity(0.4)
                              : PColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: PColors.primaryColor.withOpacity(0.5),
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  


  Widget _buildAddressCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: PColors.lightGray, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: PColors.primaryColor.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: PColors.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.home,
                        color: PColors.primaryColor,
                        size: 20,
                      ),
                    ),
                    SizeBoxV(12),
                    Expanded(
                      child: Text(
                        'Home Address',
                        style: getTextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: PColors.primaryColor,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit, color: PColors.primaryColor, size: 20),
                      onPressed: () {},
                    ),
                  ],
                ),
                SizeBoxH(12),
                Padding(
                  padding: EdgeInsets.only(left: 42),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '134',
                        style: getTextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: PColors.darkGray,
                        ),
                      ),
                      SizeBoxH(4),
                      Text(
                        'XR5J+7RG, Mohammed Ali Rd, Bhuleshwar,',
                        style: getTextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: PColors.darkGray.withOpacity(0.7),
                        ),
                      ),
                      Text(
                        'Mumbai, Maharashtra 400003, India',
                        style: getTextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: PColors.darkGray.withOpacity(0.7),
                        ),
                      ),
                      SizeBoxH(8),
                      Row(
                        children: [
                          Icon(
                            Icons.location_city,
                            size: 14,
                            color: PColors.darkGray.withOpacity(0.5),
                          ),
                          SizeBoxV(6),
                          Text(
                            'Bhuleshwar, Mumbai - 400003',
                            style: getTextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: PColors.darkGray.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
Widget _buildEditProfileButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [PColors.primaryColor, PColors.secondoryColor],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: PColors.primaryColor.withOpacity(0.3),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Handle edit profile
          },
          borderRadius: BorderRadius.circular(16),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.edit, color: Colors.white, size: 20),
                SizeBoxV(10),
                Text(
                  'Edit Profile',
                  style: getTextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}