import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../Settings/constants/sized_box.dart';
import '../../../../Settings/utils/p_colors.dart';
import '../../../shedule_plan/model/schedule_model.dart';

class OrderCard extends StatelessWidget {
  final ScheduleModel schedule;
  final bool isExpanded;
  final VoidCallback? onToggleExpand;
  final VoidCallback? onReschedule;
  final VoidCallback? onCancel;

  const OrderCard({
    super.key,
    required this.schedule,
    this.isExpanded = false,
    this.onToggleExpand,
    this.onReschedule,
    this.onCancel,
  });

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

  @override
  Widget build(BuildContext context) {
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
                  _buildProgressLine(schedule.status.toLowerCase() == 'in_progress'),
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
                _buildDetailRow(
                  'Discount',
                  'NA',
                  Icons.discount,
                ),
                
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
                  onTap: onToggleExpand,
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
                        isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                        color: PColors.primaryColor,
                        size: 20,
                      ),
                    ],
                  ),
                ),

                // Action Buttons
                if (schedule.status.toLowerCase() != 'cancelled' &&
                    schedule.status.toLowerCase() != 'completed') ...[
                  SizeBoxH(16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: onReschedule,
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: PColors.lightBlue, width: 1.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: Text(
                            'Reschedule',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: PColors.primaryColor,
                            ),
                          ),
                        ),
                      ),
                      SizeBoxV(12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: onCancel,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: PColors.errorRed,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 14),
                            elevation: 0,
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
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

  Widget _buildDetailRow(String label, String value, IconData icon, {bool isAddress = false}) {
    return Row(
      crossAxisAlignment: isAddress ? CrossAxisAlignment.start : CrossAxisAlignment.center,
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
