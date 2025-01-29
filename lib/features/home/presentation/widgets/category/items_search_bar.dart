import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/text_style.dart';

class ItemsSearchBar extends StatelessWidget {
  final Function(String) onChanged;

  const ItemsSearchBar({
    super.key,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF68B3B).withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: SearchBar(
        onChanged: onChanged,
        hintText: 'Search for items...',
        hintStyle: WidgetStateProperty.all(
          TextStyles.Blinker16regularorangeColor.copyWith(
            color: Colors.grey[400],
          ),
        ),
        textStyle: WidgetStateProperty.all(
          TextStyles.blinker16semiBoldBlack,
        ),
        leading: Padding(
          padding: EdgeInsets.all(12.w),
          child: Image.asset(
            "assets/images/search_icon.png",
            width: 24.w,
            height: 24.h,
            color: const Color(0xFFF68B3B),
          ),
        ),
        padding: WidgetStateProperty.all(
          EdgeInsets.symmetric(horizontal: 7.w, vertical: 5.h),
        ),
        elevation: WidgetStateProperty.all(0),
        backgroundColor: WidgetStateProperty.all(Colors.white),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
            side: BorderSide(
              color: const Color(0xFFF68B3B).withOpacity(0.2),
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}
