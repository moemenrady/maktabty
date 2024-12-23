import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomProfileOption extends StatelessWidget {
  final String iconPath;
  final String title;
  final TextStyle textStyle;
  Function() OntapFN;
  CustomProfileOption({super.key, required this.iconPath, required this.title, required this.textStyle,required this.OntapFN});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: OntapFN,
      child: Row(
        children: [
          Image.asset(iconPath, width: 25.w, height: 25.h),
          SizedBox(width: 12.w),
          Text(title, style: textStyle),
        ],
      ),
    );
  }
}