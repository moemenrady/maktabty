import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mktabte/core/theme/font_weight_helper.dart';

import '../../../../core/theme/app_pallete.dart';
import '../../../../core/theme/text_style.dart';
import '../widget/cart_page/custom_cart_app_bar.dart';
import '../widget/cart_page/custom_cart_card.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          children: [
            const CustomCartAppBar(),
            Row(
              children: [
                Text(
                  "Product Order",
                  style: TextStyles.blinker20SemiBoldBlack,
                ),
                Text(
                  "Edit",
                  style: TextStyles.blinker16RegularLightBlue,
                ),
              ],
            ),
            SizedBox(
              height: 248.h,
              child: const SingleChildScrollView(
                child: Column(
                  children: [
                    CustomCartCard(),
                    CustomCartCard(),
                    CustomCartCard(),
                    CustomCartCard(),
                    CustomCartCard(),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 7.h),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppPallete.lightOrange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(1000.r),
                  ),
                  fixedSize: Size(242.w, 52.h),
                ),
                onPressed: () {},
                child: const Text(
                  "Proceed Order",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
