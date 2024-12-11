import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'app_pallete.dart';
import 'font_weight_helper.dart';

class TextStyles {
  static TextStyle blinker24SemiBoldLightGrey = TextStyle(
      fontSize: 24.h,
      fontWeight: FontWeightHelper.semiBold,
      fontFamily: "Blinker",
      color: AppPallete.lightGreyForText);

  static TextStyle blinker20SemiBoldBlack = TextStyle(
      fontSize: 20.h,
      fontWeight: FontWeightHelper.semiBold,
      fontFamily: "Blinker",
      color: AppPallete.blackForText);

  static TextStyle blinker16RegularLightBlue = TextStyle(
      fontSize: 16.h,
      fontWeight: FontWeightHelper.regular,
      fontFamily: "Blinker",
      color: AppPallete.lightBlueForText);

  static TextStyle blinker14RegularDarkGrey = TextStyle(
      fontSize: 14.h,
      fontWeight: FontWeightHelper.regular,
      fontFamily: "Blinker",
      color: AppPallete.darkGreyForText);

  static TextStyle blinker20SemiBoldLightBlack = TextStyle(
      fontSize: 20.h,
      fontWeight: FontWeightHelper.semiBold,
      fontFamily: "Blinker",
      color: AppPallete.lightBlack);
}
