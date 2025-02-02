import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/text_style.dart';

class CustomGuestProfileButtons extends StatelessWidget {
  const CustomGuestProfileButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Divider(
              color: Color(0xFFCBCBD4),
            ),
            InkWell(
              onTap: () {},
              child: SizedBox(
                height: 64.h,
                width: double.infinity,
                child: Row(
                  children: [
                    Text("Settings", style: TextStyles.Lato16extraBoldBlack),
                    const Spacer(),
                    Image.asset("assets/images/setting_icon.png",
                        width: 25.w, height: 25.h),
                  ],
                ),
              ),
            ),
            const Divider(
              color: Color(0xFFCBCBD4),
            ),
            InkWell(
              onTap: () {},
              child: SizedBox(
                height: 64.h,
                width: double.infinity,
                child: Row(
                  children: [
                    Text("Need help?", style: TextStyles.Lato16extraBoldBlack),
                    const Spacer(),
                    Image.asset("assets/images/Info_icon.png",
                        width: 25.w, height: 25.h),
                  ],
                ),
              ),
            ),
            const Divider(
              color: Color.fromARGB(255, 0, 0, 0),
            ),
    ],);
  }
}