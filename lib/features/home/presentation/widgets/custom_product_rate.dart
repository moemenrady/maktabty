import 'package:flutter/material.dart';

import '../../../../core/theme/text_style.dart';
import 'roundedcontainer.dart';

class CustomProductRate extends StatelessWidget {
  const CustomProductRate({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
                  children: [
                    Roundedcontainer(img: "assets/images/Star Rating.png", clr: Color.fromARGB(118, 255, 128, 55), num: "4.0"),
                    const SizedBox(width: 5),
                    Roundedcontainer(img: "assets/images/like_icon.png", clr: Color.fromARGB(157, 31, 124, 253), num: "3.9"),
                    
                    
                    const SizedBox(width: 5),
                    Text(
                      "130 Review",
                      style: TextStyles.Roboto15regularlightBlack,
                    ),
                  ],
                );
  }
}