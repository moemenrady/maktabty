import 'package:flutter/material.dart';

PreferredSizeWidget MainAppBar(bool backarrow,String txt){

return AppBar(
        automaticallyImplyLeading: backarrow,
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
      );}