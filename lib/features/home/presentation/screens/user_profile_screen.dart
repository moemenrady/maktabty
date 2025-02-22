import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mktabte/features/home/presentation/screens/userwishlistscreen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/comman/app_user/app_user_riverpod.dart';
import '../../../../core/theme/text_style.dart';
import '../../../admin/presentation/screens/admin_control_user_orders.dart';
import '../../../admin/presentation/screens/category_page.dart';
import '../../../admin/presentation/screens/item_page.dart';
import '../../../admin/presentation/screens/view_orders_summary.dart';

import '../../../user/presentation/screens/user_info_screen.dart';
import '../../../orders/presentation/screens/user_orders_screen.dart';
import '../widgets/custom_profile_option.dart';

final supabase = Supabase.instance.client;

class UserProfileScreen extends ConsumerWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void logOut() {
      ref.read(appUserRiverpodProvider.notifier).clearUserData();
    }

    final userName =
        ref.read(appUserRiverpodProvider).user?.name; // Get user's name
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
                Text(userName!, style: TextStyles.Inter17mediumBlack),
              ],
            ),
            SizedBox(height: 30.h),

            // Profile Options List
            Expanded(
              child: ListView(
                children: [
                  //for admin
                  CustomProfileOption(
                    OntapFN: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CategoryPage()));
                    },
                    iconPath: "assets/images/setting_icon.png",
                    title: "My Category",
                    textStyle: TextStyles.Inter15regularBlack,
                  ),
                  SizedBox(height: 18.h),
                  CustomProfileOption(
                    OntapFN: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ItemPage()));
                    },
                    iconPath: "assets/images/setting_icon.png",
                    title: "My Product",
                    textStyle: TextStyles.Inter15regularBlack,
                  ),
                  SizedBox(height: 18.h),
                  CustomProfileOption(
                    OntapFN: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const ViewOrdersSummaryScreen()));
                    },
                    iconPath: "assets/images/setting_icon.png",
                    title: "View Orders",
                    textStyle: TextStyles.Inter15regularBlack,
                  ),
                  SizedBox(height: 18.h),
                  CustomProfileOption(
                    OntapFN: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const AdminControlUserOrders()));
                    },
                    iconPath: "assets/images/setting_icon.png",
                    title: "Control User Orders",
                    textStyle: TextStyles.Inter15regularBlack,
                  ),
                  SizedBox(height: 18.h),
                  //for user
                  // CustomProfileOption(
                  //   OntapFN: () {},
                  //   iconPath: "assets/images/dark_light_mode_icon.png",
                  //   title: "Dark Mode",
                  //   textStyle: TextStyles.Inter15regularBlack,
                  // ),

                  SizedBox(height: 18.h),
                  CustomProfileOption(
                    OntapFN: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const UserInfoScreen()));
                      },
                    iconPath: "assets/images/Info_icon.png",
                    title: "Account Information",
                    textStyle: TextStyles.Inter15regularBlack,
                  ),

                  SizedBox(height: 18.h),
                  CustomProfileOption(
                    OntapFN: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const UserOrdersScreen()),
                      );
                    },
                    iconPath: "assets/images/bag_icon.png",
                    title: "Order",
                    textStyle: TextStyles.Inter15regularBlack,
                  ),
                  // SizedBox(height: 18.h),
                  // CustomProfileOption(
                  //   OntapFN: () {},
                  //   iconPath: "assets/images/wallet_icon.png",
                  //   title: "My Cards",
                  //   textStyle: TextStyles.Inter15regularBlack,
                  // ),
                  SizedBox(height: 18.h),
                  CustomProfileOption(
                    OntapFN: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const UserWishlistScreen()));
                    },
                    iconPath: "assets/images/wishlist_icon.png",
                    title: "Wishlist",
                    textStyle: TextStyles.Inter15regularBlack,
                  ),

                  // SizedBox(height: 18.h),
                  // CustomProfileOption(
                  //   OntapFN: () {},
                  //   iconPath: "assets/images/setting_icon.png",
                  //   title: "Settings",
                  //   textStyle: TextStyles.Inter15regularBlack,
                  // ),
                ],
              ),
            ),

            // Logout Button
            CustomProfileOption(
              OntapFN: () {
                logOut();
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
