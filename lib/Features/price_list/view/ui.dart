import 'package:flutter/material.dart';
import 'package:fresh_fold/Features/price_list/view/widgets/express_table.dart';
import 'package:fresh_fold/Features/price_list/view/widgets/premium_table.dart';
import 'package:fresh_fold/Features/price_list/view/widgets/regular_table.dart';
import 'package:fresh_fold/Settings/common/widgets/custom_app_bar.dart';
import 'package:fresh_fold/Settings/common/widgets/custom_text_feild.dart';
import 'package:fresh_fold/Settings/constants/sized_box.dart';

import '../../../Settings/common/widgets/custom_tab_section.dart';

class PriceListScreen extends StatelessWidget {
  const PriceListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Price List"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              CustomTextFeild(hintText: "Select The Locality"),
              SizeBoxH(12),
              Expanded(
                child: CustomTabSection(
                  tabTitles: const ["Regular", "Express", "Premium"],
                  tabContents: [RegularTable(),ExpressTable(), PremiumTable(),],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
