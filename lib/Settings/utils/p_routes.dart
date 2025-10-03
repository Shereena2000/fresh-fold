import 'package:flutter/material.dart';


import '../../Features/auth/mobile_num_verification/view/ui.dart';
import '../../Features/auth/otp_verification/view/ui.dart';
import '../../Features/auth/registration/view/ui.dart';
import '../../Features/wrapper_screen/view/ui.dart';
import '../../Features/on_boarding/view/ui.dart';
import '../../Features/splash/view/splash_screen.dart';
import 'p_pages.dart';

class Routes {
  static Route<dynamic>? genericRoute(RouteSettings settings) {
    switch (settings.name) {
      case PPages.splash:
        return MaterialPageRoute(builder: (context) => SplashScreen());
      case PPages.login:
        return MaterialPageRoute(
          builder: (context) => MobileNumberVerficationScreen(),
        );
      case PPages.onboarding:
        return MaterialPageRoute(builder: (context) => OnBoardingScreen());
      case PPages.otpVerification:
        return MaterialPageRoute(builder: (context) => OTPVerficationScreen());

      case PPages.registrationPageUi:
        return MaterialPageRoute(builder: (context) => RegistrationScreen());
      case PPages.wrapperPageUi:
        return MaterialPageRoute(builder: (context) => WrapperScreen());



      default:
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(title: Text('Page Not Found')),
            body: Center(child: Text('Route ${settings.name} not found')),
          ),
        );
    }
  }
}
