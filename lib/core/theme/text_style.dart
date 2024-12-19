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

  static TextStyle Inter18SemiBoldlightBlack = const TextStyle(
      fontSize: 18,
      fontWeight: FontWeightHelper.semiBold,
      fontFamily: "Inter",
      color: AppPallete.lightBlack);

  static TextStyle Roboto20mediumBlack = const TextStyle(
      fontSize: 20,
      fontWeight: FontWeightHelper.medium,
      fontFamily: "Roboto",
      color: AppPallete.blackForText);

  static TextStyle Roboto15regularlightBlack = const TextStyle(
      fontSize: 15,
      fontWeight: FontWeightHelper.regular,
      fontFamily: "Roboto",
      color: AppPallete.lightBlack);

  static TextStyle Blinker20semiBoldBlack = const TextStyle(
      fontSize: 20,
      fontWeight: FontWeightHelper.semiBold,
      fontFamily: "Blinker",
      color: AppPallete.blackForText);

  static TextStyle Blinker16regularlightBlack = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeightHelper.regular,
      fontFamily: "Blinker",
      color: AppPallete.lightBlack);

  static TextStyle Raleway14mediuBlack = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeightHelper.medium,
      fontFamily: "Raleway",
      color: AppPallete.blackForText);

  static TextStyle Blinker12regularlightBlack = const TextStyle(
      fontSize: 12,
      fontWeight: FontWeightHelper.regular,
      fontFamily: "Blinker",
      color: AppPallete.lightBlack);

  static TextStyle Blinker14semiBoldBlack = const TextStyle(
      fontSize: 12,
      fontWeight: FontWeightHelper.semiBold,
      fontFamily: "Blinker",
      color: AppPallete.blackForText);

  static TextStyle blinker16SemiBoldWhite = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeightHelper.semiBold,
    fontFamily: "Blinker",
    color: AppPallete.white,
  );
}
