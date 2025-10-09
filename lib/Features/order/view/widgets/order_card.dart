import 'package:flutter/material.dart';
import 'package:fresh_fold/Settings/common/widgets/custom_outline_button.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../Settings/common/widgets/show_custom_dialog.dart';
import '../../../../Settings/constants/sized_box.dart';
import '../../../../Settings/utils/p_colors.dart';
import '../../../auth/view_model.dart/auth_view_model.dart';
import '../../../shedule_plan/model/schedule_model.dart';
import '../../view_model/order_view_model.dart';
//client
class OrderCard extends StatelessWidget {
  final ScheduleModel schedule;
  final String scheduleId;

  const OrderCard({
    super.key,
    required this.schedule,
    required this.scheduleId,
  });

  // Check if reschedule button should be shown (only for pending/confirmed status)
  bool _shouldShowRescheduleButton() {
    final status = schedule.status.toLowerCase();
    return status == 'pending' || 
           status == 'pickup_requested' || 
           status == 'confirmed';
  }

  Color _getStatusColor() {
    switch (schedule.status.toLowerCase()) {
      case 'completed':
        return PColors.successGreen;
      case 'cancelled':
        return PColors.errorRed;
      case 'in_progress':
        return Colors.orange;
      case 'pending':
      case 'pickup_requested':
      case 'confirmed':
        return PColors.lightBlue;
      default:
        return PColors.primaryColor;
    }
  }

  String _getStatusText() {
    switch (schedule.status.toLowerCase()) {
      case 'pending':
        return 'Pickup Requested';
      case 'pickup_requested':
        return 'Pickup Requested';
      case 'confirmed':
        return 'Confirmed';
      case 'in_progress':
        return 'In Progress';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return schedule.status;
    }
  }

  void _handleReschedule(BuildContext context) async {
    final authProvider = Provider.of<AuthViewModel>(context, listen: false);
    final userId = authProvider.currentUser?.uid;
    final orderViewModel = context.read<OrderViewModel>();

    if (userId == null) return;

    // Step 1: Show Date Picker
    final DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: schedule.pickupDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (newDate == null) return; // User canceled date picker

    // Step 2: Show Time Slot Picker (using a custom bottom sheet)
    final String? newTimeSlot = await _showTimeSlotBottomSheet(context);

    if (newTimeSlot == null) return; // User canceled time slot picker

    // Step 3: Show Confirmation Dialog
    final bool shouldProceed =
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Reschedule Order'),
            content: Text(
              'Are you sure you want to reschedule your pickup to:\n\n${DateFormat('dd-MM-yyyy').format(newDate)} at $newTimeSlot?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('Confirm'),
              ),
            ],
          ),
        ) ??
        false;

    // Step 4: Proceed with Reschedule
    if (shouldProceed && context.mounted) {
      await orderViewModel.rescheduleOrder(
        userId,
        scheduleId,
        newDate,
        newTimeSlot,
      );
    }
  }

  // Helper function to show the time slot picker
  Future<String?> _showTimeSlotBottomSheet(BuildContext context) {
    final timeSlots = [
      '9:00 AM - 11:00 AM',
      '11:00 AM - 1:00 PM',
      '1:00 PM - 3:00 PM',
      '3:00 PM - 5:00 PM',
      '5:00 PM - 7:00 PM',
    ];

    return showModalBottomSheet<String?>(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select a New Time Slot',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            ...timeSlots
                .map(
                  (slot) => ListTile(
                    title: Text(slot),
                    onTap: () => Navigator.of(context).pop(slot),
                  ),
                )
                .toList(),
          ],
        ),
      ),
    );
  }

  void _handleCancel(BuildContext context) {
    final authProvider = Provider.of<AuthViewModel>(context, listen: false);
    final userId = authProvider.currentUser?.uid;

    if (userId == null) return;
 showCustomDialog(
    context: context,
    title: "Cancel Order",
    content: "Are you sure you want to cancel this order?",
    confirmText: "Yes, Cancel",
    cancelText: "No",
   
    onConfirm: () async {
      await context.read<OrderViewModel>().cancelOrder(userId, scheduleId);
    },
  );
    // showDialog(
    //   context: context,
    //   builder: (context) => AlertDialog(
    //     title: Text('Cancel Order'),
    //     content: Text('Are you sure you want to cancel this order?'),
    //     actions: [
    //       TextButton(
    //         onPressed: () => Navigator.pop(context),
    //         child: Text('No'),
    //       ),
    //       ElevatedButton(
    //         style: ElevatedButton.styleFrom(backgroundColor: PColors.errorRed),
    //         onPressed: () async {
    //           await context.read<OrderViewModel>().cancelOrder(
    //             userId,
    //             scheduleId,
    //           );
    //           if (context.mounted) Navigator.pop(context);
    //         },
    //         child: Text('Yes, Cancel'),
    //       ),
    //     ],
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderViewModel>(
      builder: (context, viewModel, child) {
        final isExpanded = viewModel.isExpanded(scheduleId);

        return Container(
          margin: EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: PColors.lightGray, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: PColors.primaryColor.withOpacity(0.08),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Header with status
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: PColors.lightGray.withOpacity(0.5),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: PColors.primaryColor,
                      size: 20,
                    ),
                    SizeBoxV(8),
                    Text(
                      'Pickup Status : ',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: PColors.primaryColor,
                      ),
                    ),
                    Text(
                      _getStatusText(),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: _getStatusColor(),
                      ),
                    ),
                  ],
                ),
              ),

              // Progress Indicator
              if (schedule.status.toLowerCase() != 'cancelled' &&
                  schedule.status.toLowerCase() != 'completed')
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildProgressStep(true, Icons.person, 'Requested'),
                      _buildProgressLine(
                        schedule.status.toLowerCase() == 'in_progress',
                      ),
                      _buildProgressStep(
                        schedule.status.toLowerCase() == 'in_progress',
                        Icons.local_shipping,
                        'Pickup',
                      ),
                    ],
                  ),
                ),

              // Order Details
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow(
                      'Reference ID',
                      schedule.scheduleId,
                      Icons.tag,
                    ),
                    SizeBoxH(12),
                    _buildDetailRow(
                      'Pickup Date',
                      DateFormat('dd-MM-yyyy').format(schedule.pickupDate),
                      Icons.calendar_today,
                    ),
                    SizeBoxH(12),
                    _buildDetailRow(
                      'Service Type',
                      _formatServiceType(schedule.serviceType),
                      Icons.star_outline,
                    ),
                    SizeBoxH(12),
                    _buildDetailRow('Discount', 'NA', Icons.discount),

                    if (isExpanded) ...[
                      SizeBoxH(12),
                      _buildDetailRow(
                        'Address',
                        schedule.pickupLocation,
                        Icons.location_on,
                        isAddress: true,
                      ),
                      SizeBoxH(12),
                      _buildDetailRow(
                        'Wash Type',
                        _formatWashType(schedule.washType),
                        Icons.local_laundry_service,
                      ),
                      SizeBoxH(12),
                      _buildDetailRow(
                        'Time Slot',
                        schedule.timeSlot,
                        Icons.access_time,
                      ),
                    ],

                    // View More/Less Button
                    SizeBoxH(12),
                    GestureDetector(
                      onTap: () => viewModel.toggleExpand(scheduleId),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            isExpanded ? 'View less' : 'View more',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: PColors.primaryColor,
                            ),
                          ),
                          SizeBoxV(4),
                          Icon(
                            isExpanded
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: PColors.primaryColor,
                            size: 20,
                          ),
                        ],
                      ),
                    ),

                    // Action Buttons - only show for pending/confirmed status
                    if (_shouldShowRescheduleButton()) ...[
                      SizeBoxH(16),
                      Row(
                        children: [
                          Expanded(
                            child: CustomOutlineButton(
                              onPressed: () => _handleReschedule(context),
                              text: 'Reschedule',
                              heigth: 50,
                            ),
                          ),
                          SizeBoxV(12),
                          Expanded(
                            child: CustomOutlineButton(
                              text: "Cancel",
                              bordercolor: PColors.errorRed,
                              textcolor: PColors.errorRed,
                              heigth: 50,
                              onPressed: () => _handleCancel(context),
                            ),
                          ),
                        ],
                      ),
                      SizeBoxH(8),
                      Text(
                        '*Reschedule button will be enabled in few seconds',
                        style: TextStyle(
                          fontSize: 11,
                          color: PColors.darkGray.withOpacity(0.5),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProgressStep(bool isActive, IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isActive ? PColors.successGreen : PColors.lightGray,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: isActive ? Colors.white : PColors.darkGray.withOpacity(0.5),
            size: 28,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressLine(bool isActive) {
    return Container(
      width: 80,
      height: 3,
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: isActive ? PColors.successGreen : PColors.lightGray,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value,
    IconData icon, {
    bool isAddress = false,
  }) {
    return Row(
      crossAxisAlignment: isAddress
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      children: [
        Text(
          '$label : ',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: PColors.primaryColor,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: PColors.darkGray,
            ),
            maxLines: isAddress ? 3 : 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String _formatServiceType(String type) {
    switch (type.toLowerCase()) {
      case 'regular':
        return 'Regular';
      case 'express':
        return 'Express';
      case 'premium':
        return 'Premium';
      default:
        return type;
    }
  }

  String _formatWashType(String type) {
    switch (type.toLowerCase()) {
      case 'dry_clean':
        return 'Dry Cleaning & Steam Press';
      case 'wash_press':
        return 'Wash & Steam Press';
      case 'press_only':
        return 'Steam Press Only';
      default:
        return type;
    }
  }
}
