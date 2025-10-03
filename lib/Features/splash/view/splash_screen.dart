// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:fresh_fold/Settings/constants/sized_box.dart';
import 'package:fresh_fold/Settings/constants/text_styles.dart';
import 'package:fresh_fold/Settings/utils/p_text_styles.dart';
import '../../../Settings/utils/p_colors.dart';
import '../../../Settings/utils/p_pages.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    checkLogin();
    super.initState();
  }

Future<void> checkLogin() async {
    await Future.delayed(const Duration(seconds: 3)); // splash delay

    // Example if you have login check
    // await LoggedInUser.getUserDetails();
    // if (LoggedInUser.accessToken != null) {
    //   Navigator.pushNamedAndRemoveUntil(
    //       context, PPages.mainPageui, (route) => false);
    // } else {
    //   Navigator.pushNamedAndRemoveUntil(
    //       context, PPages.onboarding, (route) => false);
    // }

    // For now just onboarding
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        PPages.onboarding,
        (route) => false,
      );
    }}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PColors.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Fresh Fold",
              style: getTextStyle(
                color: PColors.lightBlue,
                fontSize: 50,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizeBoxH(40),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(PColors.lightBlue),
              strokeWidth: 3,
            ),
          ],
        ),
      ),
    );
  }
}
