import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/text_style.dart';
import '../widgets/custom_profile_option.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  "assets/images/user2.png",
                  width: 52.w,
                  height: 52.h,
                ),
                SizedBox(width: 10.w),
                Text("SMSM", style: TextStyles.Inter17mediumBlack),
              ],
            ),
            SizedBox(height: 30.h),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
            Spacer(),
            SizedBox(height: 18.h),
            CustomProfileOption(
              OntapFN: () {},
              iconPath: "assets/images/Logout.png",
              title: "Logout",
              textStyle: TextStyles.Inter15mediumbinkForText,
            ),
            SizedBox(
              height: 50.h,
            ),
          ],
        ),
      ),
    );
  }
}
