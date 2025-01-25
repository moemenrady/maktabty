import 'package:flutter/material.dart';
import 'package:mktabte/core/theme/text_style.dart';
import 'package:mktabte/features/check_out/presentation/screen/cart_page.dart';

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
              style: TextStyles.DMSans20mediumlightBlack,
            ),
          ),
        ),
        if (hasIcons) ...[
          IconButton(
            onPressed: () {},
            icon: Image.asset("assets/images/btns/black_notification_btn_img.png"),
          ),
          IconButton(
            onPressed: () {Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CartPage(),
          ),
        );},
            icon: Image.asset("assets/images/btns/black_cart_btn_img.png"),
          ),
        ],
      ],
    );
  }
}
