import 'package:flutter/material.dart';
import 'package:mktabte/core/theme/text_style.dart';

Widget RoundedContainer(String num, Icon? ico, String? img ,Color clr) {
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
          if (img != null) 
            Image.asset(
              img,
              height: 20,
              width: 20,
              fit: BoxFit.contain,
            ),
          if (img == null && ico != null) 
            Icon(
              ico.icon, 
              color: ico.color,
              size: ico.size ?? 20,
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
