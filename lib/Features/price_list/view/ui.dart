import 'package:flutter/material.dart';
import 'package:fresh_fold/Settings/common/widgets/custom_app_bar.dart';
import 'package:fresh_fold/Settings/constants/sized_box.dart';
import 'package:provider/provider.dart';

import '../../../Settings/common/widgets/custom_tab_section.dart';
import '../view_model/price_view_model.dart';
import 'widgets/price_table.dart';

class PriceListScreen extends StatefulWidget {
  const PriceListScreen({super.key});

  @override
  State<PriceListScreen> createState() => _PriceListScreenState();
}

class _PriceListScreenState extends State<PriceListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PriceViewModel>(context, listen: false).loadAllCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Price List"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              SizeBoxH(12),
              Expanded(
                child: CustomTabSection(
                  tabTitles: const ["Regular", "Express", "Premium"],
                  tabContents: [
                    PriceTable(category: 'regular'),
                    PriceTable(category: 'express'),
                    PriceTable(category: 'premium'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

