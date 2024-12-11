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
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 80.w, maxHeight: 50.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Product Names",
                style: TextStyles.blinker20SemiBoldBlack,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                "Product Description",
                style: TextStyles.blinker14RegularDarkGrey,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        _buildOutlinedButton(Icons.keyboard_arrow_up_rounded),
        _buildQtyColumn("1"),
        _buildOutlinedButton(Icons.keyboard_arrow_down_rounded),
        _buildPriceColumn("\$100"),
        Padding(
          padding: EdgeInsets.only(bottom: 40.h),
          child: _buildOutlinedButton(Icons.delete_outline_rounded),
        ),
      ],
    );
  }

  Widget _buildOutlinedButton(IconData icon) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        shape: const CircleBorder(),
        side: const BorderSide(color: AppPallete.lightGrey, width: 0.5),
      ),
      child: Icon(
        icon,
        color: AppPallete.lightGrey,
      ),
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
