import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_pallete.dart';
import '../../../../../core/theme/text_style.dart';

class CustomCartAppBar extends StatelessWidget {
  const CustomCartAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildOutlinedButton(
          Icons.arrow_back_ios_rounded,
        ),
        Text(
          "Cart",
          style: TextStyles.blinker24SemiBoldLightGrey,
        )
      ],
    );
  }

  Widget _buildOutlinedButton(IconData icon) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        shape: const CircleBorder(),
        side: const BorderSide(color: AppPallete.blackForText, width: 2),
      ),
      child: Icon(
        icon,
        size: 12.h,
        color: AppPallete.blackForText,
      ),
    );
  }
}
