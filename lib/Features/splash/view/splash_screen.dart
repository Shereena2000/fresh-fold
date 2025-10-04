import 'package:flutter/material.dart';
import 'package:fresh_fold/Settings/constants/sized_box.dart';
import 'package:fresh_fold/Settings/constants/text_styles.dart';
import 'package:provider/provider.dart';
import '../../../Settings/helper/preference_helper.dart';
import '../../../Settings/utils/p_colors.dart';
import '../../../Settings/utils/p_pages.dart';
import '../../auth/view_model.dart/auth_view_model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    final authProvider = Provider.of<AuthViewModel>(context, listen: false);
    
    // Check if user is authenticated
    final authStatus = await authProvider.checkAuthStatus();
    
    // Check if onboarding was completed
    final onboardingCompleted = await PreferenceHelper.isOnboardingCompleted();

    if (!mounted) return;

    // Navigation logic
    if (authStatus == 'wrapper') {
      // User is fully authenticated and registered
      Navigator.pushNamedAndRemoveUntil(
        context,
        PPages.wrapperPageUi,
        (route) => false,
      );
    } else if (authStatus == 'registration') {
      // User is authenticated but needs to complete registration
      Navigator.pushNamedAndRemoveUntil(
        context,
        PPages.registrationPageUi,
        (route) => false,
      );
    } else {
      // User is not authenticated
      if (onboardingCompleted) {
        // Skip onboarding, go directly to login
        Navigator.pushNamedAndRemoveUntil(
          context,
          PPages.login,
          (route) => false,
        );
      } else {
        // Show onboarding for first-time users
        Navigator.pushNamedAndRemoveUntil(
          context,
          PPages.onboarding,
          (route) => false,
        );
      }
    }
  }

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