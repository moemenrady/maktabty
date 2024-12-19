import 'package:flutter/material.dart';
import 'package:mktabte/core/theme/text_style.dart';

class CustomAppBar extends StatelessWidget {
  final String txt;
  final bool hasArrow;
  final bool hasIcons;

  CustomAppBar({
    super.key,
    required this.txt,
    required this.hasArrow,
    required this.hasIcons,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (hasArrow)
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Image.asset("assets/images/btns/backarrow_btn_img.png"),
          ),
        Expanded(
          child: Center(
            child: Text(
              txt,
              style: TextStyles.DMSans20mediumBlack,
            ),
          ),
        ),
        if (hasIcons) ...[
          IconButton(
            onPressed: () {},
            icon: Image.asset("assets/images/btns/black_notification_btn_img.png"),
          ),
          IconButton(
            onPressed: () {},
            icon: Image.asset("assets/images/btns/black_cart_btn_img.png"),
          ),
        ],
      ],
    );
  }
}
