import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Settings/constants/sized_box.dart';
import '../../../Settings/constants/text_styles.dart';
import '../../../Settings/utils/p_colors.dart';




class ScheduleWashScreen extends StatefulWidget {
  const ScheduleWashScreen({Key? key}) : super(key: key);

  @override
  State<ScheduleWashScreen> createState() => _ScheduleWashScreenState();
}

class _ScheduleWashScreenState extends State<ScheduleWashScreen> {
  String? selectedServiceType;
  String? selectedWashType;
  String? selectedLocation;
  DateTime? selectedDate;
  String? selectedTimeSlot;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PColors.scaffoldColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: PColors.primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Schedule Wash',
          style: getTextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: PColors.primaryColor,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section with gradient
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        PColors.primaryColor.withOpacity(0.1),
                        PColors.lightBlue.withOpacity(0.1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  padding: EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Let\'s Get Your\nClothes Fresh & Clean',
                        style: getTextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: PColors.primaryColor,
                          height: 1.3,
                        ),
                      ),
                      SizeBoxH(8),
                      Text(
                        'Schedule your pickup in just a few steps',
                        style: getTextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: PColors.darkGray.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),

                SizeBoxH(24),

                // Pickup Location
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionLabel('Pickup Location', Icons.location_on),
                      SizeBoxH(12),
                      _buildLocationCard(),
                    ],
                  ),
                ),

                SizeBoxH(24),

                // Date & Time Selection
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionLabel('When should we pick up?', Icons.calendar_today),
                      SizeBoxH(12),
                      Row(
                        children: [
                          Expanded(child: _buildDateCard()),
                          SizeBoxV(12),
                          Expanded(child: _buildTimeCard()),
                        ],
                      ),
                    ],
                  ),
                ),

                SizeBoxH(24),

                // Service Type
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionLabel('Service Type', Icons.local_shipping),
                      SizeBoxH(12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildServiceTypeCard(
                              'Regular',
                              Icons.star_outline,
                              '2-3 Days',
                              'regular',
                            ),
                          ),
                          SizeBoxV(12),
                          Expanded(
                            child: _buildServiceTypeCard(
                              'Express',
                              Icons.flash_on,
                              '24 Hours',
                              'express',
                            ),
                          ),
                          SizeBoxV(12),
                          Expanded(
                            child: _buildServiceTypeCard(
                              'Premium',
                              Icons.diamond_outlined,
                              'Same Day',
                              'premium',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizeBoxH(24),

                // Wash Type
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionLabel('Wash Type', Icons.local_laundry_service),
                      SizeBoxH(12),
                      _buildWashTypeCard(
                        'Dry Cleaning & Steam Press',
                        Icons.iron,
                        'Perfect for delicate fabrics',
                        'dry_clean',
                      ),
                      SizeBoxH(12),
                      _buildWashTypeCard(
                        'Wash & Steam Press',
                        Icons.local_laundry_service,
                        'Deep clean with professional press',
                        'wash_press',
                      ),
                      SizeBoxH(12),
                      _buildWashTypeCard(
                        'Steam Press Only',
                        Icons.iron_outlined,
                        'Just ironing service',
                        'press_only',
                      ),
                    ],
                  ),
                ),

                SizeBoxH(24),

                // Get Rate Card
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: _buildGetRateCard(),
                ),

                SizeBoxH(24),
              ],
            ),
          ),

          // Bottom Button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: _buildScheduleButton(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: PColors.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: PColors.primaryColor, size: 18),
        ),
        SizeBoxV(10),
        Text(
          title,
          style: getTextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: PColors.primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildLocationCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: PColors.lightGray, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: PColors.primaryColor.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Handle location selection
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: PColors.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.location_on,
                    color: PColors.primaryColor,
                    size: 24,
                  ),
                ),
                SizeBoxV(16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedLocation ?? 'Choose Pickup Location',
                        style: getTextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: selectedLocation != null
                              ? PColors.primaryColor
                              : PColors.darkGray.withOpacity(0.5),
                        ),
                      ),
                      if (selectedLocation != null) ...[
                        SizeBoxH(4),
                        Text(
                          'Tap to change',
                          style: getTextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: PColors.darkGray.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: PColors.primaryColor,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: PColors.lightGray, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: PColors.primaryColor.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(Duration(days: 30)),
            );
            if (date != null) {
              setState(() => selectedDate = date);
            }
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.calendar_today, color: PColors.primaryColor, size: 22),
                SizeBoxH(8),
                Text(
                  'Date',
                  style: getTextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: PColors.darkGray.withOpacity(0.6),
                  ),
                ),
                SizeBoxH(4),
                Text(
                  selectedDate != null
                      ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                      : 'Select',
                  style: getTextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: PColors.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: PColors.lightGray, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: PColors.primaryColor.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            _showTimeSlotBottomSheet();
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.access_time, color: PColors.primaryColor, size: 22),
                SizeBoxH(8),
                Text(
                  'Time Slot',
                  style: getTextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: PColors.darkGray.withOpacity(0.6),
                  ),
                ),
                SizeBoxH(4),
                Text(
                  selectedTimeSlot ?? 'Select',
                  style: getTextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: PColors.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildServiceTypeCard(
    String title,
    IconData icon,
    String subtitle,
    String value,
  ) {
    final isSelected = selectedServiceType == value;
    return GestureDetector(
      onTap: () => setState(() => selectedServiceType = value),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? PColors.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? PColors.primaryColor : PColors.lightGray,
            width: isSelected ? 2 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? PColors.primaryColor.withOpacity(0.2)
                  : PColors.primaryColor.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : PColors.primaryColor,
              size: 28,
            ),
            SizeBoxH(8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: getTextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : PColors.primaryColor,
              ),
            ),
            SizeBoxH(4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: getTextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w400,
                color: isSelected
                    ? Colors.white.withOpacity(0.9)
                    : PColors.darkGray.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWashTypeCard(
    String title,
    IconData icon,
    String subtitle,
    String value,
  ) {
    final isSelected = selectedWashType == value;
    return GestureDetector(
      onTap: () => setState(() => selectedWashType = value),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected
              ? PColors.primaryColor.withOpacity(0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? PColors.primaryColor : PColors.lightGray,
            width: isSelected ? 2 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? PColors.primaryColor.withOpacity(0.1)
                  : PColors.primaryColor.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? PColors.primaryColor
                    : PColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : PColors.primaryColor,
                size: 24,
              ),
            ),
            SizeBoxV(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: getTextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: PColors.primaryColor,
                    ),
                  ),
                  SizeBoxH(4),
                  Text(
                    subtitle,
                    style: getTextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: PColors.darkGray.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? PColors.primaryColor : PColors.lightGray,
                  width: 2,
                ),
                color: isSelected ? PColors.primaryColor : Colors.transparent,
              ),
              child: isSelected
                  ? Icon(Icons.check, color: Colors.white, size: 16)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGetRateCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            PColors.lightBlue.withOpacity(0.3),
            PColors.primaryColor.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: PColors.lightBlue, width: 1.5),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Handle get rate card
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.receipt_long,
                    color: PColors.primaryColor,
                    size: 24,
                  ),
                ),
                SizeBoxV(16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'View Price List',
                        style: getTextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: PColors.primaryColor,
                        ),
                      ),
                      SizeBoxH(4),
                      Text(
                        'Check our complete rate card',
                        style: getTextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: PColors.darkGray.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: PColors.primaryColor,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScheduleButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [PColors.primaryColor, PColors.secondoryColor],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: PColors.primaryColor.withOpacity(0.3),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Handle schedule wash
          },
          borderRadius: BorderRadius.circular(16),
          child: Center(
            child: Text(
              'Schedule Wash',
              style: getTextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showTimeSlotBottomSheet() {
    final timeSlots = [
      '9:00 AM - 11:00 AM',
      '11:00 AM - 1:00 PM',
      '1:00 PM - 3:00 PM',
      '3:00 PM - 5:00 PM',
      '5:00 PM - 7:00 PM',
    ];

    showModalBottomSheet(
      context: context,
       isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: PColors.lightGray,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizeBoxH(20),
            Text(
              'Select Time Slot',
              style: getTextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: PColors.primaryColor,
              ),
            ),
            SizeBoxH(16),
            ...timeSlots.map((slot) => Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    onTap: () {
                      setState(() => selectedTimeSlot = slot);
                      Navigator.pop(context);
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: selectedTimeSlot == slot
                            ? PColors.primaryColor.withOpacity(0.1)
                            : PColors.lightGray.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: selectedTimeSlot == slot
                              ? PColors.primaryColor
                              : Colors.transparent,
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            color: PColors.primaryColor,
                            size: 20,
                          ),
                          SizeBoxV(12),
                          Text(
                            slot,
                            style: getTextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: PColors.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
            SizeBoxH(12),
          ],
        ),
      ),
    );
  }
}