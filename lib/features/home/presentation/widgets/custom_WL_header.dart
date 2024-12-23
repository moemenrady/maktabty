import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/text_style.dart';

class CustomWlHeader extends StatelessWidget {
  const CustomWlHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
                  color: Color(0xFFF68B3B),
                  height: 251.h,
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Wishlist",
                              textAlign: TextAlign.right,
                              style: TextStyles.Lato28boldlightBlack),
                        ),
                        const Spacer(
                          flex: 2,
                        ),
                      ],
                    ),
                  ),
                );
  }
}