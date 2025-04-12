import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mktabte/features/home/presentation/screens/userwishlistscreen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/comman/app_user/app_user_riverpod.dart';
import '../../../../core/theme/text_style.dart';
import '../../../../core/utils/biometric_helper.dart';
import '../../../../core/utils/show_snack_bar.dart';
import '../../../admin/presentation/screens/admin_control_user_orders.dart';
import '../../../admin/presentation/screens/category_page.dart';
import '../../../admin/presentation/screens/item_page.dart';
import '../../../admin/presentation/screens/view_orders_summary.dart';
import '../../../service_provider/presentation/screens/become_service_provider_screen.dart';
import '../../../service_provider/presentation/screens/service_provider_item_page.dart';
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

    void checkBiometric(void Function() onSuccess) async {
      final authResult = await BiometricHelper.authenticate();
      authResult.fold(
        (error) => showSnackBar(context, error),
        (authenticated) {
          if (authenticated) {
            onSuccess();
          }
        },
      );
    }

    final user = ref.read(appUserRiverpodProvider).user;
    final userName = user?.name;
    final userState = user?.state ?? 0;

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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(userName ?? 'User',
                        style: TextStyles.Inter17mediumBlack),
                    if (userState == 2)
                      Container(
                        margin: EdgeInsets.only(top: 4.h),
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF96AD).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: const Color(0xFFFF96AD),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          'Service Provider',
                          style: TextStyle(
                            color: const Color(0xFFF83758),
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
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
                      checkBiometric(() {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ViewOrdersSummaryScreen()));
                      });
                    },
                    iconPath: "assets/images/setting_icon.png",
                    title: "View Orders",
                    textStyle: TextStyles.Inter15regularBlack,
                  ),
                  SizedBox(height: 18.h),
                  CustomProfileOption(
                    OntapFN: () {
                      checkBiometric(() {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const AdminControlUserOrders()));
                      });
                    },
                    iconPath: "assets/images/setting_icon.png",
                    title: "Control User Orders",
                    textStyle: TextStyles.Inter15regularBlack,
                  ),
                  SizedBox(height: 18.h),

                  // Service Provider Section
                  if (userState != 2) ...[
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 8.h),
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: Colors.pink.shade50,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.w),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.workspace_premium,
                                  color: const Color(0xFFF83758),
                                  size: 20.w,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  'Service Provider Panel',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          CustomProfileOption(
                            OntapFN: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ServiceProviderItemPage(),
                                ),
                              );
                            },
                            iconPath: "assets/images/bag_icon.png",
                            title: "Manage My Products",
                            textStyle: TextStyles.Inter15regularBlack,
                          ),
                          SizedBox(height: 5.h),
                        ],
                      ),
                    ),
                    SizedBox(height: 18.h),
                  ],

                  //for user
                  SizedBox(height: 18.h),
                  CustomProfileOption(
                    OntapFN: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const UserInfoScreen()));
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

                  // Show Service Provider option only for regular users
                  if (userState != 2) ...[
                    SizedBox(height: 18.h),
                    CustomProfileOption(
                      OntapFN: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const BecomeServiceProviderScreen(),
                          ),
                        );
                      },
                      iconPath: "assets/images/Star Rating.png",
                      title: "Become a Service Provider",
                      textStyle: TextStyles.Inter15regularBlack,
                    ),
                  ],
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
