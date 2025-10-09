import 'package:flutter/material.dart';
import 'package:fresh_fold/Features/auth/view/sigin.dart';
import 'package:fresh_fold/Features/auth/view/sign_up.dart';
import 'package:fresh_fold/Features/legal_info/privacy_policy/view/ui.dart';
import 'package:fresh_fold/Features/price_list/view/ui.dart';
import '../../Features/auth/view/mobile_verification.dart';
import '../../Features/auth/view/otp_verification.dart';
import '../../Features/auth/view/registration.dart';
import '../../Features/notification/view/ui.dart';
import '../../Features/on_boarding/view/ui.dart';
import '../../Features/pick_up_screen/view/ui.dart';
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
        return MaterialPageRoute(builder: (context) => LoginScreen());
              case PPages.signUp:
        return MaterialPageRoute(builder: (context) => SignUpScreen());
      case PPages.mobileVerifcation:
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
      case PPages.pickUpLocationPageUi:
        return MaterialPageRoute(builder: (context) => MapLocationPickerScreen());
    case PPages.privacyPolicyUi:
        return MaterialPageRoute(builder: (context) => PrivacyPolicyScreen());

    case PPages.notificationPageUi:
        return MaterialPageRoute(builder: (context) => NotificationScreen());

 case PPages.priceListPageUi:
        return MaterialPageRoute(builder: (context) => PriceListScreen());



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
