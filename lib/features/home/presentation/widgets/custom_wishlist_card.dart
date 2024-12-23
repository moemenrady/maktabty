import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/text_style.dart';
import '../screens/userwishlistscreen.dart';

class CustomWishlistCard extends StatelessWidget {
  const CustomWishlistCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
                color: Colors.white,
                elevation: 20,
                child: ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: wishListItems.length,
                  itemBuilder: (context, index) {
                    final item = wishListItems[index];
                    return Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Image.asset(
                                item["image"]!,
                                width: 88.w,
                                height: 88.h,
                              ),
                              const SizedBox(width: 16.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item["title"]!,
                                    style: TextStyles.Inter15regularBlack,
                                  ),
                                  const SizedBox(height: 8.0),
                                  Text(
                                    item["price"]!,
                                    style: TextStyles.Inter15regularBlack,
                                  ),
                                  const SizedBox(height: 8.0),
                                  //button
                                  Container(
                                    width: 117.w,
                                    height: 32.h,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFFF9E56),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: InkWell(
                                      onTap: () {},
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            "assets/images/shopping-cart_black.png",
                                            width: 16.w,
                                            height: 16.w,
                                          ),
                                          const SizedBox(width: 5),
                                          const Text(
                                            "Add to cart",
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 8.h,
                          left: 88.w,
                          child: InkWell(
                              onTap: () {},
                              child: Image.asset(
                                "assets/images/btns/favorite_btn_img.png",
                                width: 20.w,
                                height: 19.75.h,
                              )),
                        )
                      ],
                    );
                  },
                ),
              );
  }
}