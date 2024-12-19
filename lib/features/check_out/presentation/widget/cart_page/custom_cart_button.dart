import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_pallete.dart';

class CustomCartButton extends StatelessWidget {
  final void Function() onpressed;
  const CustomCartButton({super.key, required this.onpressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 7.h),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppPallete.lightOrange,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(1000.r),
          ),
          fixedSize: Size(242.w, 52.h),
        ),
        onPressed: onpressed,
        child: const Text(
          "Proceed Order",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
