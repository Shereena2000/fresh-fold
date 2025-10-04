import 'package:flutter/material.dart';
import 'package:fresh_fold/Features/on_boarding/view_model/onboarding_view_model.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../Settings/constants/sized_box.dart';
import '../../../Settings/utils/p_colors.dart';
import '../../../Settings/utils/p_text_styles.dart';
import '../../../Settings/constants/text_styles.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<OnBoardingViewModel>(
      builder: (context, provider, _) {
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: PageView.builder(
                      controller: provider.pageController,
                      itemCount: provider.pages.length,
                      onPageChanged: provider.setCurrentPage,
                      itemBuilder: (context, index) {
                        final page = provider.pages[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(page.image),
                            SizeBoxH(20),
                            Text(page.title, style: PTextStyles.displayMedium),
                            SizeBoxH(12),
                            Text(
                              page.description,
                              style: PTextStyles.bodyMedium,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  Center(
                    child: SmoothPageIndicator(
                      controller: provider.pageController,
                      count: provider.pages.length,
                      effect: WormEffect(
                        dotHeight: 8,
                        dotWidth: 8,
                        activeDotColor: PColors.primaryColor,
                        dotColor: PColors.lightBlue,
                        spacing: 8,
                      ),
                    ),
                  ),
                  SizeBoxH(20),
                  Row(
                    children: [
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          if (provider.currentIndex ==
                              provider.pages.length - 1) {
                            // Last page → Move to Login
                            provider.goToLogin(context);
                          } else {
                            // Skip → Jump to last page
                            provider.skipToEnd();
                          }
                        },
                        child: Text(
                          provider.currentIndex == provider.pages.length - 1
                              ? "Get Started"
                              : "Skip",
                          style: getTextStyle(
                            color: PColors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
