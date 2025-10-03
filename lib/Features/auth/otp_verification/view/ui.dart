
import 'package:flutter/material.dart';

import '../../../../Settings/common/widgets/custom_elevated_button.dart';
import '../../../../Settings/common/widgets/custom_text_feild.dart';
import '../../../../Settings/constants/sized_box.dart';
import '../../../../Settings/utils/p_colors.dart';
import '../../../../Settings/utils/p_pages.dart';
import '../../../../Settings/utils/p_text_styles.dart';

class OTPVerficationScreen extends StatelessWidget {
  const OTPVerficationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizeBoxH(59),
              Center(
                child: Text("OTP Verification", style: PTextStyles.displaySmall),
              ),
        
              Text(
                "Enter the code that was sent to your number",
                style: PTextStyles.bodySmall.copyWith(color: PColors.darkGray),
              ),
         
              SizeBoxH(40),
        
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  6,
                  (index) =>
                      SizedBox(width: 45, child: CustomTextFeild(hintText: "")),
                ),
              ),
        
              SizeBoxH(20),
        
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Didn’t receive the code? ",
                    style: PTextStyles.bodySmall.copyWith(
                      color: PColors.darkGray,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Text('Resend in 58 sec', style: PTextStyles.bodySmall.copyWith(color: PColors.secondoryColor)),
                ],
              ),
        
              const SizedBox(height: 30),
        
              CustomElavatedTextButton(
                onPressed: ()
                 =>
                    Navigator.pushNamed(context, PPages.registrationPageUi),
                text: 'Verify',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
