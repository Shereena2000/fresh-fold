import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fresh_fold/Settings/common/widgets/custom_app_bar.dart';
import 'package:fresh_fold/Settings/common/widgets/custom_elevated_button.dart';
import '../../../Settings/constants/sized_box.dart';
import '../../../Settings/constants/text_styles.dart';
import '../../../Settings/utils/p_colors.dart';
import '../../auth/view_model.dart/auth_view_model.dart';
import '../../edit_profile/view/ui.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final authProvider = Provider.of<AuthViewModel>(context, listen: false);
    final user = authProvider.currentUser;
    if (user != null) {
      authProvider.loadUserData(user.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Profile"),
      body: Consumer<AuthViewModel>(
        builder: (context, authProvider, child) {
          final user = authProvider.currentUser;

          if (authProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (user == null) {
            return Center(child: Text('No user data found'));
          }

          return SingleChildScrollView(
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
                        value: user.email ?? 'Not provided',
                        onTap: () {},
                      ),
                      SizeBoxH(12),
                      _buildContactCard(
                        icon: Icons.phone_outlined,
                        label: 'Phone Number',
                        value: user.phoneNumber,
                        onTap: () {},
                      ),
                      if (user.alternativePhone != null) ...[
                        SizeBoxH(12),
                        _buildContactCard(
                          icon: Icons.phone_outlined,
                          label: 'Alternative Phone',
                          value: user.alternativePhone!,
                          onTap: () {},
                        ),
                      ],
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
                        label: 'Full Name',
                        value: user.fullName ?? 'Not specified',
                        onTap: () {},
                      ),
                      SizeBoxH(12),
                      _buildInfoCard(
                        icon: Icons.person_outline,
                        label: 'Gender',
                        value: user.gender ?? 'Not specified',
                        onTap: () {},
                      ),
                      SizeBoxH(12),
                      _buildInfoCard(
                        icon: Icons.cake_outlined,
                        label: 'Date of Birth',
                        value: user.dateOfBirth != null
                            ? '${user.dateOfBirth!.day}/${user.dateOfBirth!.month}/${user.dateOfBirth!.year}'
                            : 'Not specified',
                        onTap: () {},
                      ),
                      SizeBoxH(12),
                      _buildInfoCard(
                        icon: Icons.work_outline,
                        label: 'Profession',
                        value: user.profession ?? 'Not specified',
                        onTap: () {},
                      ),
                      SizeBoxH(12),
                      _buildInfoCard(
                        icon: Icons.location_on_outlined,
                        label: 'Location',
                        value: user.location ?? 'Not specified',
                        onTap: () {},
                      ),
                    ],
                  ),
                ),

                SizeBoxH(32),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: CustomElavatedTextButton(
                    icon: Icon(Icons.edit, color: Colors.white, size: 20),
                    text: "Edit Profile",
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfileScreen(),
                        ),
                      );
                      _loadUserData();
                    },
                  ),
                ),
                SizeBoxH(32),
              ],
            ),
          );
        },
      ),
    );
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
          ],
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
          ],
        ),
      ),
    );
  }
}