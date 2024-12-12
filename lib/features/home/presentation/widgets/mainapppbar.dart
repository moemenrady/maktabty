import 'package:flutter/material.dart';

PreferredSizeWidget MainAppBar(BuildContext? context,bool backarrow, String txt) {
  return AppBar(
    automaticallyImplyLeading: false,
    centerTitle: true,
    title: Text(
      txt,
      style: const TextStyle(
        fontFamily: 'DM Sans',
        fontWeight: FontWeight.w500,
        fontSize: 24,
        color: Colors.black,
      ),
    ),
    leading: backarrow
        ? IconButton(
            icon: const Icon(Icons.arrow_circle_left_outlined,size: 30, color: Colors.black),
            onPressed: () {
              Navigator.pop(context!);
            },
          )
        : null,
    actions: const [
      Icon(
        Icons.notifications_outlined,
        size: 30,
      ),
      SizedBox(
        width: 5,
      ),
      Icon(
        Icons.shopping_cart_outlined,
        size: 30,
      ),
    ],
  );
}
