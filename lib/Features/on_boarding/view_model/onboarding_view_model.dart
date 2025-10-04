import 'package:flutter/material.dart';
import 'package:fresh_fold/Settings/utils/p_pages.dart';
import '../model/onboarding_model.dart';
import '../../../Settings/utils/images.dart';

class OnBoardingViewModel extends ChangeNotifier {
  final PageController pageController = PageController();

  int currentIndex = 0;

  final List<OnBoardingModel> pages = [
    OnBoardingModel(
      image: Images.onboarding_1,
      title: "FREE HOME PICK-UP &\n DROP-OFF SERVICE",
      description:
          "Don't stress over the pile of clothes! Choose our service with just a few clicks, then sit back and relax. Let the experts handle your laundry!",
    ),
    OnBoardingModel(
      image: Images.onboarding_2,
      title: "QUICK & EASY BOOKING",
      description:
          "Book your laundry service in seconds with our easy-to-use app and save your valuable time.",
    ),
    OnBoardingModel(
      image: Images.onboarding_3,
      title: "PREMIUM QUALITY CARE",
      description:
          "Your clothes deserve the best. We provide premium quality care with professional cleaning and packaging.",
    ),
  ];

  void setCurrentPage(int index) {
    currentIndex = index;
    notifyListeners();
  }

  void skipToEnd() {
    pageController.jumpToPage(pages.length - 1);
  }
  void goToLogin(BuildContext context) {
  Navigator.pushReplacementNamed(context, PPages.login); 
}

}
