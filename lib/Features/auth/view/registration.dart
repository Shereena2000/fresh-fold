import 'package:flutter/material.dart';
import 'package:fresh_fold/Features/auth/common/widgets/heading_section.dart';
import 'package:fresh_fold/Settings/common/widgets/custom_text_feild.dart';
import 'package:fresh_fold/Settings/constants/sized_box.dart';
import 'package:provider/provider.dart';

import '../../../../Settings/common/widgets/custom_elevated_button.dart';
import '../../../../Settings/utils/p_pages.dart';
import '../../../../Settings/utils/p_text_styles.dart';
import '../view_model.dart/auth_view_model.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Consumer<AuthViewModel>(
            builder: (context, viewModel, child) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    SizeBoxH(15),
                    HeadingSection(title: "Registration"),
                    SizeBoxH(15),
                    
                    CustomTextFeild(
                      prefixfn: () {},
                      prefixIcon: Icon(Icons.phone),
                      hintText: "Mobile Number",
                      textHead: "Mobile Number",
                      controller: viewModel.phoneController,
                       keyboardType: TextInputType.phone,
                   //   readOnly: true,
                    ),
                    SizeBoxH(18),
                    
                    // CustomTextFeild(
                    //   prefixfn: () {},
                    //   prefixIcon: Icon(Icons.person),
                    //   hintText: "Full Name",
                    //   textHead: "Full Name",
                    //   controller: viewModel.fullNameController,
                    // ),
                    // SizeBoxH(18),
                    
                    
                    
                    CustomTextFeild(
                      prefixfn: () {},
                      prefixIcon: Icon(Icons.location_on),
                      hintText: "Location",
                      textHead: "Location",
                      controller: viewModel.locationController,
                    ),
                         SizeBoxH(18),
                    CustomTextFeild(
                      prefixfn: () {},
                      prefixIcon: Icon(Icons.email),
                      hintText: "Email",
                      textHead: "Email",
                      readOnly: true
                      ,
                      controller: viewModel.emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizeBoxH(18),
                    
                    if (viewModel.errorMessage != null) ...[
                      const SizeBoxH(16),
                      Text(
                        viewModel.errorMessage!,
                        style: PTextStyles.bodySmall.copyWith(
                          color: Colors.red,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    
                    SizeBoxH(30),
                    
                    viewModel.isLoading
                        ? const CircularProgressIndicator()
                        : CustomElavatedTextButton(
                            onPressed: () async {
                              viewModel.clearError();
                              bool success = await viewModel.registerUser();
                              
                              if (success && context.mounted) {
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  PPages.wrapperPageUi,
                                  (route) => false,
                                );
                              }
                            },
                            text: 'Register',
                          ),
                  ],
                ),
              );
            },
          ),),),);}
}
