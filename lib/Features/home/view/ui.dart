import 'package:flutter/material.dart';
import 'package:fresh_fold/Settings/common/widgets/custom_elevated_button.dart';
import 'package:fresh_fold/Settings/constants/sized_box.dart';
import 'package:fresh_fold/Settings/utils/images.dart';
import 'package:fresh_fold/Settings/utils/p_pages.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              //this is promo image container . that is movable. so list of premo autmaically move like netflix
              SizedBox(
                height: 200,
                width: double.infinity,
                child: Image.asset(Images.onboarding_1, fit: BoxFit.cover),
              ),
              SizeBoxH(15),
          //    this is optional
              Lottie.asset(
                'assets/lottie/Launderer.json',

                height: 200,
                repeat: true,
                reverse: false,
                animate: true,
              ),

              SizeBoxH(30),
              CustomElavatedTextButton(text: "Shedule Wash", onPressed: () {
                Navigator.pushNamed(context, PPages.schedulePageUi);
              }),
            ],
          ),
        ),
      ),
    );
  }
}
