import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomeFavouriteButton extends StatelessWidget {
  final String image;
  final void Function() onTap;
  const CustomeFavouriteButton(
      {super.key, required this.image, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 8,
      right: 8,
      child: InkWell(
          onTap: onTap,
          child: Image.asset(
            image,
            width: 20.w,
            height: 19.75.h,
          )),
    );
  }
}
