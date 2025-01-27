import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/theme/text_style.dart';
import '../../../auth/data/_auth_service.dart';
import '../../../auth/presentation/riverpod/login_state.dart';
import '../../../auth/presentation/screens/login.dart';
import '../widgets/custom_profile_option.dart';

final supabase = Supabase.instance.client;

class UserProfileScreen extends ConsumerStatefulWidget {
  const UserProfileScreen({super.key});

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<UserProfileScreen> {
  final authservice = AuthService();

  // Logout function
  void logout(BuildContext context) async {
    await authservice.signout();

    // Check if the widget is still mounted before updating the state
    // if (mounted) {
    //   ref.read(loginStateProvider.notifier).logOut();
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(builder: (context) => const LoginPage()),
    //   );
    // }
  }

  late String userName;

  @override
  void initState() {
    super.initState();
    fetchUserName();
  }

  void fetchUserName() {
    // Safely fetch the user name from the metadata
    final name = authservice.getCurrentUserName();
    setState(() {
      userName = name ?? "Guest";
    });
  }

  @override
  Widget build(BuildContext context) {
    final userName = authservice.getCurrentUserName(); // Get user's name
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User info (Avatar & Name)
            Row(
              children: [
                Image.asset(
                  "assets/images/user2.png",
                  width: 52.w,
                  height: 52.h,
                ),
                SizedBox(width: 10.w),
                Text(userName ?? "Guest", style: TextStyles.Inter17mediumBlack),
              ],
            ),
            SizedBox(height: 30.h),

            // Profile Options List
            Expanded(
              child: ListView(
                children: [
                  CustomProfileOption(
                    OntapFN: () {},
                    iconPath: "assets/images/dark_light_mode_icon.png",
                    title: "Dark Mode",
                    textStyle: TextStyles.Inter15regularBlack,
                  ),
                  SizedBox(height: 18.h),
                  CustomProfileOption(
                    OntapFN: () {},
                    iconPath: "assets/images/Info_icon.png",
                    title: "Account Information",
                    textStyle: TextStyles.Inter15regularBlack,
                  ),
                  SizedBox(height: 18.h),
                  CustomProfileOption(
                    OntapFN: () {},
                    iconPath: "assets/images/bag_icon.png",
                    title: "Order",
                    textStyle: TextStyles.Inter15regularBlack,
                  ),
                  SizedBox(height: 18.h),
                  CustomProfileOption(
                    OntapFN: () {},
                    iconPath: "assets/images/wallet_icon.png",
                    title: "My Cards",
                    textStyle: TextStyles.Inter15regularBlack,
                  ),
                  SizedBox(height: 18.h),
                  CustomProfileOption(
                    OntapFN: () {},
                    iconPath: "assets/images/wishlist_icon.png",
                    title: "Wishlist",
                    textStyle: TextStyles.Inter15regularBlack,
                  ),
                  SizedBox(height: 18.h),
                  CustomProfileOption(
                    OntapFN: () {},
                    iconPath: "assets/images/setting_icon.png",
                    title: "Settings",
                    textStyle: TextStyles.Inter15regularBlack,
                  ),
                ],
              ),
            ),

            // Logout Button
            CustomProfileOption(
              OntapFN: () {
                logout(
                    context); // Logout function does not need ref, just the context
              },
              iconPath: "assets/images/Logout.png",
              title: "Logout",
              textStyle: TextStyles.Inter15mediumbinkForText,
            ),
            SizedBox(height: 50.h),
          ],
        ),
      ),
    );
  }
}
