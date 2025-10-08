import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../Settings/constants/sized_box.dart';
import '../../../Settings/utils/p_colors.dart';
import '../../../Settings/common/widgets/custom_app_bar.dart';
import '../../../Settings/common/widgets/custom_text_feild.dart';
import '../../../Settings/common/widgets/custom_elevated_button.dart';
import '../../auth/view_model.dart/auth_view_model.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  late TextEditingController _locationController;
  late TextEditingController _professionController;
  late TextEditingController _alternativePhoneController;
  
  String? _selectedGender;
  DateTime? _selectedDateOfBirth;

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthViewModel>(context, listen: false);
    final user = authProvider.currentUser;

    _fullNameController = TextEditingController(text: user?.fullName);
    _emailController = TextEditingController(text: user?.email);
    _locationController = TextEditingController(text: user?.location);
    _professionController = TextEditingController(text: user?.profession);
    _alternativePhoneController = TextEditingController(text: user?.alternativePhone);
    _selectedGender = user?.gender;
    _selectedDateOfBirth = user?.dateOfBirth;
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _locationController.dispose();
    _professionController.dispose();
    _alternativePhoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Edit Profile"),
      body: Consumer<AuthViewModel>(
        builder: (context, authProvider, child) {
          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  // Full Name
                  CustomTextFeild(
                    controller: _fullNameController,
                    hintText: "Full Name",
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  SizeBoxH(16),

                  // Email
                  CustomTextFeild(
                    controller: _emailController,
                    hintText: "Email",
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  SizeBoxH(16),

                  // Gender Selection
                  _buildGenderSelector(),
                  SizeBoxH(16),

                  // Date of Birth
                  _buildDatePicker(),
                  SizeBoxH(16),

                  // Profession
                  CustomTextFeild(
                    controller: _professionController,
                    hintText: "Profession",
                    prefixIcon: Icon(Icons.work_outline),
                  ),
                  SizeBoxH(16),

                  // Location
                  CustomTextFeild(
                    controller: _locationController,
                    hintText: "Location",
                    prefixIcon: Icon(Icons.location_on_outlined),
                  ),
                  SizeBoxH(16),

                  // Alternative Phone
                  CustomTextFeild(
                    controller: _alternativePhoneController,
                    hintText: "Alternative Phone Number",
                    keyboardType: TextInputType.phone,
                    prefixIcon: Icon(Icons.phone_outlined),
                  ),
                  SizeBoxH(32),

                  // Error Message
                  if (authProvider.errorMessage != null) ...[
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        authProvider.errorMessage!,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    SizeBoxH(16),
                  ],

                  // Save Button
                  CustomElavatedTextButton(
                    text: authProvider.isLoading ? "Saving..." : "Save Changes",
                    onPressed: authProvider.isLoading ? null : _saveProfile,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGenderSelector() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: PColors.lightGray),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedGender,
          hint: Text('Select Gender'),
          isExpanded: true,
          items: ['Male', 'Female', 'Other'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedGender = newValue;
            });
          },
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: _selectedDateOfBirth ?? DateTime(2000),
          firstDate: DateTime(1950),
          lastDate: DateTime.now(),
        );
        if (date != null) {
          setState(() {
            _selectedDateOfBirth = date;
          });
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: PColors.lightGray),
        ),
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.cake_outlined, color: PColors.primaryColor),
            SizeBoxV(12),
            Text(
              _selectedDateOfBirth != null
                  ? '${_selectedDateOfBirth!.day}/${_selectedDateOfBirth!.month}/${_selectedDateOfBirth!.year}'
                  : 'Select Date of Birth',
              style: TextStyle(
                color: _selectedDateOfBirth != null
                    ? PColors.primaryColor
                    : PColors.darkGray.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthViewModel>(context, listen: false);

      final success = await authProvider.updateProfile(
        fullName: _fullNameController.text.trim(),
        email: _emailController.text.trim(),
        location: _locationController.text.trim(),
        profession: _professionController.text.trim(),
        alternativePhone: _alternativePhoneController.text.trim(),
        gender: _selectedGender,
        dateOfBirth: _selectedDateOfBirth,
      );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    }
  }
}