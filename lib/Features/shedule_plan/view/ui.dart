import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../Settings/constants/sized_box.dart';
import '../../../Settings/constants/text_styles.dart';
import '../../../Settings/utils/p_colors.dart';
import '../../auth/view_model.dart/auth_view_model.dart';
import '../../pick_up_screen/view/ui.dart';
import '../view_model.dart/schedule_view_model.dart';


class ScheduleWashScreen extends StatefulWidget {
  const ScheduleWashScreen({Key? key}) : super(key: key);

  @override
  State<ScheduleWashScreen> createState() => _ScheduleWashScreenState();
}

class _ScheduleWashScreenState extends State<ScheduleWashScreen> {
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
      body: Consumer<ScheduleViewModel>(
        builder: (context, scheduleProvider, child) {
          return Stack(
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

                    // Error Message
                    if (scheduleProvider.errorMessage != null) ...[
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red.withOpacity(0.3)),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.error_outline, color: Colors.red, size: 20),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  scheduleProvider.errorMessage!,
                                  style: TextStyle(color: Colors.red, fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizeBoxH(12),
                    ],

                    // Pickup Location
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionLabel('Pickup Location', Icons.location_on),
                          SizeBoxH(12),
                          _buildLocationCard(scheduleProvider),
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
                          _buildSectionLabel(
                            'When should we pick up?',
                            Icons.calendar_today,
                          ),
                          SizeBoxH(12),
                          Row(
                            children: [
                              Expanded(child: _buildDateCard(scheduleProvider)),
                              SizeBoxV(12),
                              Expanded(child: _buildTimeCard(scheduleProvider)),
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
                                  scheduleProvider,
                                  'Regular',
                                  Icons.star_outline,
                                  '2-3 Days',
                                  'regular',
                                ),
                              ),
                              SizeBoxV(12),
                              Expanded(
                                child: _buildServiceTypeCard(
                                  scheduleProvider,
                                  'Express',
                                  Icons.flash_on,
                                  '24 Hours',
                                  'express',
                                ),
                              ),
                              SizeBoxV(12),
                              Expanded(
                                child: _buildServiceTypeCard(
                                  scheduleProvider,
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
                          _buildSectionLabel(
                            'Wash Type',
                            Icons.local_laundry_service,
                          ),
                          SizeBoxH(12),
                          _buildWashTypeCard(
                            scheduleProvider,
                            'Dry Cleaning & Steam Press',
                            Icons.iron,
                            'Perfect for delicate fabrics',
                            'dry_clean',
                          ),
                          SizeBoxH(12),
                          _buildWashTypeCard(
                            scheduleProvider,
                            'Wash & Steam Press',
                            Icons.local_laundry_service,
                            'Deep clean with professional press',
                            'wash_press',
                          ),
                          SizeBoxH(12),
                          _buildWashTypeCard(
                            scheduleProvider,
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
                  child: _buildScheduleButton(scheduleProvider),
                ),
              ),

              // Loading Overlay
              if (scheduleProvider.isLoading)
                Container(
                  color: Colors.black54,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: PColors.primaryColor,
                    ),
                  ),
                ),
            ],
          );
        },
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

  Widget _buildLocationCard(ScheduleViewModel provider) {
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
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MapLocationPickerScreen(),
              ),
            );

            if (result != null) {
              provider.setLocation(
                result['address'],
                result['location'],
              );
            }
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
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        provider.selectedLocation ?? 'Choose Pickup Location',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: provider.selectedLocation != null
                              ? PColors.primaryColor
                              : PColors.darkGray.withOpacity(0.5),
                        ),
                      ),
                      if (provider.selectedLocation != null)
                        Text(
                          'Tap to change',
                          style: TextStyle(
                            fontSize: 12,
                            color: PColors.darkGray.withOpacity(0.5),
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

  Widget _buildDateCard(ScheduleViewModel provider) {
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
              provider.setDate(date);
            }
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.calendar_today,
                  color: PColors.primaryColor,
                  size: 22,
                ),
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
                  provider.selectedDate != null
                      ? '${provider.selectedDate!.day}/${provider.selectedDate!.month}/${provider.selectedDate!.year}'
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

  Widget _buildTimeCard(ScheduleViewModel provider) {
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
            _showTimeSlotBottomSheet(provider);
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
                  provider.selectedTimeSlot ?? 'Select',
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
    ScheduleViewModel provider,
    String title,
    IconData icon,
    String subtitle,
    String value,
  ) {
    final isSelected = provider.selectedServiceType == value;
    return GestureDetector(
      onTap: () => provider.setServiceType(value),
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
    ScheduleViewModel provider,
    String title,
    IconData icon,
    String subtitle,
    String value,
  ) {
    final isSelected = provider.selectedWashType == value;
    return GestureDetector(
      onTap: () => provider.setWashType(value),
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
            // Handle get rate card - navigate to rate card screen
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

  Widget _buildScheduleButton(ScheduleViewModel scheduleProvider) {
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
          onTap: scheduleProvider.isLoading
              ? null
              : () async {
                  final authProvider = Provider.of<AuthViewModel>(
                    context,
                    listen: false,
                  );
                  
                  final userId = authProvider.currentUser?.uid;
                  
                  if (userId == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please login to schedule a wash'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  final success = await scheduleProvider.createSchedule(userId);
                  
                  if (success && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.white),
                            SizedBox(width: 8),
                            Text('Schedule created successfully!'),
                          ],
                        ),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 3),
                      ),
                    );
                    
                    // Navigate back or to orders screen
                    Navigator.pop(context);
                  }
                },
          borderRadius: BorderRadius.circular(16),
          child: Center(
            child: scheduleProvider.isLoading
                ? SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
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

  void _showTimeSlotBottomSheet(ScheduleViewModel provider) {
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
            ...timeSlots.map(
              (slot) => Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: InkWell(
                  onTap: () {
                    provider.setTimeSlot(slot);
                    Navigator.pop(context);
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: provider.selectedTimeSlot == slot
                          ? PColors.primaryColor.withOpacity(0.1)
                          : PColors.lightGray.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: provider.selectedTimeSlot == slot
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
              ),
            ),
            SizeBoxH(12),
          ],
        ),
      ),
    );
  }
}