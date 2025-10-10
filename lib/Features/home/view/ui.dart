import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fresh_fold/Settings/utils/p_pages.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Settings/common/widgets/custom_elevated_button.dart';
import '../../../Settings/constants/sized_box.dart';
import '../../../Settings/constants/text_styles.dart';
import '../../../Settings/utils/p_colors.dart';
import '../../notification/view_model/notification_view_model.dart';
import '../../notification/service/notification_listener_service.dart';
import '../../auth/view_model.dart/auth_view_model.dart';
import '../view_model/home_view_model.dart';
import '../../promo/model/promo_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  final NotificationListenerService _notificationListener = NotificationListenerService();
  final String supportPhoneNumber = '9253141908';
  
  @override
  
  void initState() {
    super.initState();
    
    // Start listening for schedule status changes and load promos
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setupNotificationListener();
      _loadPromos();
    });
  }

  void _loadPromos() {
    final homeViewModel = Provider.of<HomeViewModel>(context, listen: false);
    homeViewModel.loadPromos();
  }

  void _setupNotificationListener() {
    final authProvider = Provider.of<AuthViewModel>(context, listen: false);
    final userId = authProvider.currentUser?.uid;
    
    if (userId != null) {
      print('🎯 Setting up notification listener for user: $userId');
      _notificationListener.startListening(userId);
    }
  }
 // Method to make phone call
  Future<void> _makePhoneCall() async {
    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: supportPhoneNumber,
    );

    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        // Show error if phone app cannot be launched
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Could not launch phone dialer'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      // Handle any errors
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PColors.scaffoldColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Custom App Bar
              Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello! 👋',
                          style: getTextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: PColors.darkGray.withOpacity(0.7),
                          ),
                        ),
                        SizeBoxH(4),
                        Text(
                          'Welcome Back',
                          style: getTextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: PColors.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        _buildNotificationIconWithBadge(),
                        SizeBoxV(8),
                         _buildIconButton(Icons.phone,_makePhoneCall)
                      ],
                    ),
                  ],
                ),
              ),

              // Promo Carousel
              Consumer<HomeViewModel>(
                builder: (context, homeViewModel, child) {
                  if (homeViewModel.isLoadingPromos) {
                    return Container(
                      height: 180,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: PColors.primaryColor,
                        ),
                      ),
                    );
                  }

                  if (homeViewModel.promos.isEmpty) {
                    return Container(
                      height: 180,
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: PColors.lightGray,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          'No promos available',
                          style: TextStyle(
                            color: PColors.darkGray,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: [
                      CarouselSlider(
                        options: CarouselOptions(
                          height: 180,
                          autoPlay: true,
                          enlargeCenterPage: true,
                          viewportFraction: 0.85,
                          aspectRatio: 16 / 9,
                          autoPlayInterval: Duration(seconds: 3),
                          autoPlayAnimationDuration: Duration(milliseconds: 600),
                          onPageChanged: (index, reason) {
                            homeViewModel.updateCurrentPromoPage(index);
                          },
                        ),
                        items: homeViewModel.promos.map((promo) {
                          return Builder(
                            builder: (BuildContext context) {
                              return _buildPromoCard(promo);
                            },
                          );
                        }).toList(),
                      ),
                      
                      // Page Indicator
                      SizeBoxH(12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          homeViewModel.promos.length,
                          (index) => _buildIndicator(
                            index == homeViewModel.currentPromoPage
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),

              SizeBoxH(24),

              // Features Section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Why Choose Us?',
                      style: getTextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: PColors.primaryColor,
                      ),
                    ),
                    SizeBoxH(16),
                    _buildFeatureItem(
                      Icons.check_circle,
                      'Free Pickup & Delivery',
                      'Doorstep service at your convenience',
                    ),
                    SizeBoxH(12),
                    _buildFeatureItem(
                      Icons.eco,
                      'Eco-Friendly Products',
                      'Safe for your clothes and environment',
                    ),
                    SizeBoxH(12),
                    _buildFeatureItem(
                      Icons.star,
                      'Quality Guarantee',
                      '100% satisfaction or money back',
                    ),
                    SizeBoxH(12),
                    _buildFeatureItem(
                      Icons.schedule,
                      'Quick Turnaround',
                      'Same day and express services available',
                    ),
                  ],
                ),
              ),

              SizeBoxH(32),

              CustomElavatedTextButton(
                text: "Schedule Wash",
                icon: Icon(Icons.event_note, color: Colors.white, size: 24),
                onPressed: () {
                  Navigator.pushNamed(context, PPages.schedulePageUi);
                },
              ),

              SizeBoxH(32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationIconWithBadge() {
    final authProvider = Provider.of<AuthViewModel>(context);
    final userId = authProvider.currentUser?.uid;

    if (userId == null) {
      return _buildIconButton(Icons.notifications_outlined, () => Navigator.pushNamed(context, PPages.notificationPageUi),);
      
    }

    return Consumer<NotificationViewModel>(
      builder: (context, notificationProvider, _) {
        return StreamBuilder<int>(
          stream: notificationProvider.streamUnreadCount(userId),
          builder: (context, snapshot) {
            final unreadCount = snapshot.data ?? 0;

            return Stack(
              clipBehavior: Clip.none,
              children: [
                _buildIconButton(Icons.notifications_outlined, () => Navigator.pushNamed(context, PPages.notificationPageUi),),
                if (unreadCount > 0)
                  Positioned(
                    right: 3,
                    top: 0,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      constraints: BoxConstraints(
                        minWidth: 18,
                        minHeight: 18,
                      ),
                      decoration: BoxDecoration(
                        color: PColors.primaryColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                       
                      ),
                      child: Center(
                        child: Text(
                          unreadCount > 99 ? '99+' : unreadCount.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildIconButton(IconData icon,VoidCallback onTap)  {
    return InkWell(
      onTap:onTap,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: PColors.lightGray,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: PColors.primaryColor, size: 22),
      ),
    );
  }

  Widget _buildPromoCard(PromoModel promo) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.network(
          promo.imageUrl,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
                color: PColors.primaryColor,
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: PColors.lightGray,
              child: Center(
                child: Icon(
                  Icons.image_not_supported,
                  color: PColors.darkGray,
                  size: 50,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildIndicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: isActive ? PColors.primaryColor : PColors.lightGray,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String subtitle) {
    return Container(
      padding: EdgeInsets.all(16),
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
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: PColors.successGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: PColors.successGreen, size: 24),
          ),
          SizeBoxV(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: getTextStyle(
                    fontSize: 15,
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
        ],
      ),
    );
  }
}