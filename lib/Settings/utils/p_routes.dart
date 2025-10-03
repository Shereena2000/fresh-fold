import 'package:flutter/material.dart';
import '../../Features/auth/mobile_num_verification/view/ui.dart';
import '../../Features/auth/otp_verification/view/ui.dart';
import '../../Features/auth/registration/view/ui.dart';
import '../../Features/on_boarding/view/ui.dart';
import '../../Features/profile/view/ui.dart';
import '../../Features/shedule_plan/view/ui.dart';
import '../../Features/splash/view/splash_screen.dart';
import '../../Features/wrapper/view/ui.dart';
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
      case PPages.schedulePageUi:
        return MaterialPageRoute(builder: (context) => ScheduleWashScreen());
      case PPages.profilePageUi:
        return MaterialPageRoute(builder: (context) => ProfileScreen());


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
