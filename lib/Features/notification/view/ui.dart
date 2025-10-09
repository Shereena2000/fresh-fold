import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fresh_fold/Settings/common/widgets/custom_app_bar.dart';
import 'package:fresh_fold/Settings/utils/p_colors.dart';
import 'package:fresh_fold/Settings/utils/p_text_styles.dart';
import '../../auth/view_model.dart/auth_view_model.dart';
import '../model/app_notification.dart';
import '../view_model/notification_view_model.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _markAllAsRead();
    });
  }

  void _markAllAsRead() {
    final authProvider = Provider.of<AuthViewModel>(context, listen: false);
    final notificationProvider = Provider.of<NotificationViewModel>(context, listen: false);
    
    final userId = authProvider.currentUser?.uid;
    if (userId != null) {
      // Mark all notifications as read when user navigates to notification screen
      notificationProvider.markAllAsReadOnNavigate(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthViewModel>(context);
    final userId = authProvider.currentUser?.uid;

    return Scaffold(
      appBar: CustomAppBar(
        title: "Notifications",
        actions: [
          Consumer<NotificationViewModel>(
            builder: (context, notificationProvider, child) {
              if (notificationProvider.notifications.isEmpty) {
                return SizedBox.shrink();
              }
              return PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, color: PColors.primaryColor),
                onSelected: (value) async {
                  if (value == 'mark_all_read' && userId != null) {
                    await notificationProvider.markAllAsRead(userId);
                  } else if (value == 'delete_all' && userId != null) {
                    _showDeleteAllDialog(notificationProvider, userId);
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'mark_all_read',
                    child: Row(
                      children: [
                        Icon(Icons.done_all, size: 20, color: PColors.primaryColor),
                        SizedBox(width: 8),
                        Text('Mark all as read'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete_all',
                    child: Row(
                      children: [
                        Icon(Icons.delete_sweep, size: 20, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Delete all'),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: userId == null
          ? _buildEmptyState('Please login to view notifications')
          : Consumer<NotificationViewModel>(
              builder: (context, notificationProvider, child) {
                if (notificationProvider.isLoading) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: PColors.primaryColor,
                    ),
                  );
                }

                if (notificationProvider.errorMessage != null) {
                  return _buildErrorState(
                    notificationProvider.errorMessage!,
                    () {
                      // Just refresh by rebuilding
                      setState(() {});
                    },
                  );
                }

                return StreamBuilder<List<NotificationModel>>(
                  stream: notificationProvider.streamNotifications(userId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: PColors.primaryColor,
                        ),
                      );
                    }

                    if (snapshot.hasError) {
                      return _buildErrorState(
                        'Error loading notifications',
                        () {
                          // Just refresh by rebuilding
                          setState(() {});
                        },
                      );
                    }

                    final notifications = snapshot.data ?? [];

                    if (notifications.isEmpty) {
                      return _buildEmptyState('No notifications yet');
                    }

                    return RefreshIndicator(
                      onRefresh: () async {
                        // Just refresh the stream by rebuilding
                        setState(() {});
                      },
                      color: PColors.primaryColor,
                      child: ListView.builder(
                        padding: EdgeInsets.all(16),
                        itemCount: notifications.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Dismissible(
                              key: Key(notifications[index].notificationId),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                              onDismissed: (direction) {
                                notificationProvider.deleteNotification(
                                  userId,
                                  notifications[index].notificationId,
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Notification deleted'),
                                    backgroundColor: Colors.red,
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              },
                              child: NotificationCard(
                                notification: notifications[index],
                                onTap: () async {
                                  if (!notifications[index].isRead) {
                                    await notificationProvider.markAsRead(
                                      userId,
                                      notifications[index].notificationId,
                                    );
                                  }
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none_rounded,
            size: 80,
            color: PColors.lightGray,
          ),
          SizedBox(height: 16),
          Text(
            message,
            style: PTextStyles.labelSmall.copyWith(
              color: PColors.darkGray.withOpacity(0.6),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error, VoidCallback onRetry) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 80,
            color: Colors.red.withOpacity(0.5),
          ),
          SizedBox(height: 16),
          Text(
            error,
            style: PTextStyles.labelSmall.copyWith(
              color: Colors.red,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(
              backgroundColor: PColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAllDialog(NotificationViewModel provider, String userId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete All Notifications?'),
        content: Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await provider.deleteAllNotifications(userId);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('All notifications deleted'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const NotificationCard({
    super.key,
    required this.notification,
    required this.onTap,
  });

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'pending':
        return Icons.pending_actions_rounded;
      case 'confirmed':
        return Icons.event_available_rounded;
      case 'picked_up':
        return Icons.local_shipping_rounded;
      case 'processing':
        return Icons.local_laundry_service_rounded;
      case 'ready':
        return Icons.check_circle_outline_rounded;
      case 'delivered':
        return Icons.verified_rounded;
      case 'cancelled':
        return Icons.cancel_rounded;
      case 'payment_request':
      case 'pay_request':
        return Icons.payment_rounded;
      case 'paid':
        return Icons.check_circle_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  String _getTimeDifference(DateTime time) {
    final difference = DateTime.now().difference(time);
    
    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    if (difference.inDays < 7) return '${difference.inDays}d ago';
    
    return '${time.day}/${time.month}/${time.year}';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: notification.isRead 
                ? PColors.lightGray 
                : PColors.primaryColor.withOpacity(0.3),
          ),
          color: notification.isRead 
              ? Colors.white 
              : PColors.primaryColor.withOpacity(0.05),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon Container
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: notification.isRead
                      ? PColors.lightGray
                      : PColors.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getStatusIcon(notification.status),
                  color: PColors.primaryColor,
                  size: 24,
                ),
              ),
              SizedBox(width: 12),
              
              // Text Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.message,
                      style: PTextStyles.labelSmall.copyWith(
                        fontWeight: notification.isRead 
                            ? FontWeight.w400 
                            : FontWeight.w600,
                      ),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        if (!notification.isRead) ...[
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: PColors.primaryColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 8),
                        ],
                        Spacer(),
                        Text(
                          _getTimeDifference(notification.createdAt),
                          style: PTextStyles.labelSmall.copyWith(
                            color: PColors.lightBlue,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
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