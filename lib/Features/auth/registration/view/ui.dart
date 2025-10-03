import 'package:flutter/material.dart';
import 'package:fresh_fold/Features/auth/common/widgets/heading_section.dart';
import 'package:fresh_fold/Settings/common/widgets/custom_text_feild.dart';
import 'package:fresh_fold/Settings/constants/sized_box.dart';

import '../../../../Settings/common/widgets/custom_elevated_button.dart';
import '../../../../Settings/utils/p_pages.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            SizeBoxH(15),
            HeadingSection(title: "Registration"),
            SizeBoxH(15),
            CustomTextFeild(
              prefixfn: () {},
              prefixIcon: Icon(Icons.phone),
              hintText: "Mobile Number",
              textHead: "Mobile Number",
            ),
            SizeBoxH(18),
            CustomTextFeild(
              prefixfn: () {},
              prefixIcon: Icon(Icons.person),
              hintText: "Full Name",
              textHead: "Full Name",
            ),
            SizeBoxH(18),
            CustomTextFeild(
              prefixfn: () {},
              prefixIcon: Icon(Icons.email),
              hintText: "Email",
              textHead: "Email",
            ),
            SizeBoxH(18),
            CustomTextFeild(
              prefixfn: () {},
              prefixIcon: Icon(Icons.location_on),
              hintText: "Location",
              textHead: "Location",
            ),
            SizeBoxH(30),
            CustomElavatedTextButton(
              onPressed: () =>
                  Navigator.pushNamed(context, PPages.wrapperPageUi),
              text: 'Register',
            ),
          ],
        ),
      ),
    );
  }
}
