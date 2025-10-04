import 'package:flutter/material.dart';
import 'package:fresh_fold/Settings/common/widgets/custom_app_bar.dart';
import 'package:fresh_fold/Settings/constants/sized_box.dart';
import 'package:fresh_fold/Settings/utils/p_colors.dart';
import 'package:fresh_fold/Settings/utils/p_pages.dart';
import 'package:fresh_fold/Settings/utils/p_text_styles.dart';

import '../../auth/repositories/auth_repositories.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Menu"),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            const SizedBox(height: 20),
            _buildMenuItem(
              icon: Icons.person,
              title: 'My Profile',
              onTap: () {
                Navigator.pushNamed(context, PPages.profilePageUi);
              },
            ),
            _buildMenuItem(
              icon: Icons.favorite,
              title: 'About Us',
              onTap: () {},
            ),
            _buildMenuItem(
              icon: Icons.local_offer,
              title: 'Terms of Use',
              onTap: () {
                Navigator.pushNamed(context, '/discount');
              },
            ),
            _buildMenuItem(
              icon: Icons.save_alt,
              title: 'Privacy Policy',
              onTap: () {},
            ),
            _buildMenuItem(
              icon: Icons.logout,
              title: 'Logout',
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Logout"),
                    content: const Text("Are you sure you want to log out?"),
                    actions: [
                      TextButton(
                        onPressed: () =>
                            Navigator.of(context).pop(), 
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () async {
                          Navigator.of(context).pop(); 

                          try {
                            await AuthRepository().signOut();

                            Navigator.pushReplacementNamed(context, "/login");
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Logout failed: $e")),
                            );
                          }
                        },
                        child: const Text("Logout"),
                      ),
                    ],
                  ),
                );
              },
            ),

            SizeBoxH(8),

            // const Padding(
            //   padding: EdgeInsets.all(8.0),
            //   child: AppVersionWidget(),
            // )
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: PColors.primaryColor),
          title: Text(title, style: const TextStyle(color: Colors.black)),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            color: Colors.black,
            size: 15,
          ),
          onTap: onTap,
        ),
        const Divider(height: 1, color: Colors.grey),
      ],
    );
  }

  _legalInfo({required String title, required Function onTap}) => Padding(
    padding: const EdgeInsets.all(8.0),
    child: GestureDetector(
      onTap: () => onTap(),
      child: Text(title, style: PTextStyles.labelSmall),
    ),
  );
}

// class AppVersionWidget extends StatelessWidget {
//   const AppVersionWidget({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: FutureBuilder<PackageInfo>(
//         future: PackageInfo.fromPlatform(),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return Text('Error: ${snapshot.error}');
//           }
//           if (snapshot.connectionState == ConnectionState.done) {
//             final version = snapshot.data!;
//             return Text(
//                 'Version: ${version.version} (${version.buildNumber})',
//                 style: extraSmallText);
//           } else {
//             return const CircularProgressIndicator();
//           }
//         },
//       ),
//     );
//   }
// }
