import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mktabte/core/theme/app_pallete.dart';

import '../../../../../core/theme/text_style.dart';

class CustomCartCard extends StatelessWidget {
  const CustomCartCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 72.h,
          width: 72.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.r),
            image: const DecorationImage(
                image: AssetImage("assets/images/offer2.jpg"),
                fit: BoxFit.cover),
          ),
        ),
        SizedBox(width: 16.w),
        Padding(
          padding: EdgeInsets.all(10.h),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 133.w, maxHeight: 42.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Product Names",
                  style: TextStyles.blinker20SemiBoldBlack,
                  overflow: TextOverflow.fade,
                ),
                Text(
                  "Product Description",
                  style: TextStyles.blinker14RegularDarkGrey,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
        _buildOutlinedButton("assets/images/arrow_down.png"),
        _buildQtyColumn("1"),
        _buildOutlinedButton("assets/images/arrow_up.png"),
        _buildPriceColumn("\$100"),
        Padding(
          padding: EdgeInsets.only(bottom: 40.h),
          child: _buildOutlinedButton("assets/images/delete.png"),
        ),
      ],
    );
  }

  Widget _buildOutlinedButton(String icon) {
    return Image.asset(
      icon,
      width: 19.w,
      height: 19.h,
    );
  }

  Column _buildQtyColumn(String content) {
    return Column(
      children: [
        Text(content, style: TextStyles.blinker20SemiBoldLightBlack),
        Text("Qty", style: TextStyles.blinker14RegularDarkGrey),
      ],
    );
  }

  Column _buildPriceColumn(String content) {
    return Column(
      children: [
        Text(content, style: TextStyles.blinker20SemiBoldLightBlack),
        Text("Price", style: TextStyles.blinker14RegularDarkGrey),
      ],
    );
  }
}
