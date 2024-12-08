import 'package:flutter/material.dart';

List wishListImgs = [
  "assets/images/blackcontroller.png",
  "assets/images/blackcontroller1.png",
  "assets/images/whitecontroller.png"
];
List wishListTitles = [
  "black controller",
  "black controller",
  "white controller"
];
List wishListPrices = ["\$150", "\$120", "\$200"];

class UserWishlist extends StatelessWidget {
  const UserWishlist({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Colors.orange,
            height: 350,
            width: double.infinity,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Spacer(),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "WishList",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Spacer(
                  flex: 2,
                ),
              ],
            ),
          ),
          //positioned ard
          Expanded(
              child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListView.builder(
                itemCount: wishListImgs.length,
                itemBuilder: (context, index) {}),
          ))
        ],
      ),
    );
  }
}
