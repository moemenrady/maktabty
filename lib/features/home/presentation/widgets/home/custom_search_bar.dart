import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/text_style.dart';

Widget CustomSearchBar(){
  return SearchBar(
                        hintText: 'Search',
                        hintStyle: WidgetStateProperty.all(
                          TextStyles.Roboto12regularlightGrey,
                        ),
                        leading: Image.asset(
                          "assets/images/search_icon.png",
                          width: 18.w,
                          height: 18.h,
                        ),
                        padding: WidgetStateProperty.all(
                          EdgeInsets.symmetric(horizontal: 16.w),
                        ),
                        elevation: WidgetStateProperty.all(0),
                        backgroundColor: WidgetStateProperty.all(
                          Colors.grey[100],
                        ),
                      );
}