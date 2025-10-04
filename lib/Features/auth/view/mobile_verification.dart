import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../../Settings/common/widgets/custom_elevated_button.dart';
import '../../../../Settings/common/widgets/custom_text_feild.dart';
import '../../../../Settings/constants/sized_box.dart';
import '../../../../Settings/utils/p_colors.dart';
import '../../../../Settings/utils/p_pages.dart';
import '../../../../Settings/utils/p_text_styles.dart';
import '../common/widgets/heading_section.dart';
import '../view_model.dart/auth_view_model.dart';


class MobileNumberVerficationScreen extends StatelessWidget {
  const MobileNumberVerficationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Consumer<AuthViewModel>(
            builder: (context, viewModel, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(flex: 1),
                  HeadingSection(
                    title: "Mobile No",
                  ),
                  const SizeBoxH(45),
                  Row(
                    children: [
                      Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: PColors.black, width: 1.3),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "+91",
                              style: PTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.keyboard_arrow_down,
                              size: 20,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                      const SizeBoxV(12),
                      Expanded(
                        child: CustomTextFeild(
                          hintText: "Enter mobile number",
                          controller: viewModel.phoneController,
                          keyboardType: TextInputType.phone,
                          maxLength: 10,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      ),
                    ],
                  ),

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

                  const SizeBoxH(30),

                  viewModel.isLoading
                      ? const CircularProgressIndicator()
                      : CustomElavatedTextButton(
                          onPressed: () async {
                            viewModel.clearError();

                            bool success = await viewModel.sendOTP();
                            if (success && context.mounted) {
                              Navigator.pushNamed(
                                context,
                                PPages.otpVerification,
                              );
                            }
                          },
                          text: 'Get OTP',
                        ),
                  const Spacer(flex: 2),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}