import 'package:flutter/material.dart';

import '../../../../core/theme/text_style.dart';

class Roundedcontainer extends StatelessWidget {
 final String img;
 final String num;
 final Color clr;
   Roundedcontainer({super.key, required this.img, required this.clr, required this.num});

  @override
  Widget build(BuildContext context) {
    return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      height: 28,
      decoration: BoxDecoration(
        color: clr,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
            Image.asset(
              img,
              height: 20,
              width: 20,
              fit: BoxFit.contain,
            ),
          const SizedBox(width: 5),
          Text(
            num,
            style: TextStyles.Roboto20mediumBlack,
          ),
        ],
      ),
    ),
  );
  }
}
