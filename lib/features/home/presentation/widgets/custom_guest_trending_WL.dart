import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/text_style.dart';
import '../screens/guest_wifhlist_screen.dart';

class CustomGuestTrendingWl extends StatelessWidget {
  const CustomGuestTrendingWl({super.key});

  @override
  Widget build(BuildContext context) {
    return 
                 Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: SizedBox(
                                 height: 285.h,
                                 child: ListView.builder(
                    itemCount: guestwishListItems.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final item = guestwishListItems[index];
                      return InkWell(onTap: (){},
                        child: Stack(
                          children: [
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: 258.w,
                                  height: 285.h,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                    Image.asset(item["image"]!,width: 258.w,height: 160.h,),
                                    Text(
                                              item["title"]!,
                                              style: TextStyles.Lato17regularBlack,
                                            ),
                                            const SizedBox(height: 8.0),
                                            Text(
                                              item["price"]!,
                                              style: TextStyles.Lato16extraBoldBlack,
                                            ),
                                  ],),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 8.h,
                              right: 20.w,
                              child: InkWell(
                                  onTap: () {},
                                  child: Image.asset(
                                    "assets/images/btns/favorite_btn_img.png",
                                    width: 32.w,
                                    height: 32.h,
                                  )),
                            )
                          ],
                        ),
                      );
                    }),
                               ),
                 );
  }
}