import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mktabte/core/theme/text_style.dart';

List reviews = [
  "Excellent joystick company! Their products are durable ,responsive, and enhance gaming experience remarkably. Highly recommend!",
  "Excellent joystick company! Their products are durable,\n responsive, and enhance gaming experience remarkably.\n Highly recommend!",
  "Excellent joystick company! Their products are durable,\n responsive, and enhance gaming experience remarkably.\n Highly recommend!",
  "Excellent joystick company! Their products are durable,\n responsive, and enhance gaming experience remarkably.\n Highly recommend!",
];
List names = [
  "OSOS",
  "OSOS",
  "OSOS",
  "OSOS",
];

class ReviewCard extends StatelessWidget {
  const ReviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
    height: 101.h,
    child: ListView.builder(
        itemCount: reviews.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 101.h,
                width: 214.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey.shade100,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        maxLines: 3,
                        "Excellent joystick company! Their products are durable ,responsive, and enhance gaming experience remarkably. Highly recommend!  Excellent joystick company! Their products are durable ,responsive, and enhance gaming experience remarkably. Highly recommend! Excellent joystick company! Their products are durable ,responsive, and enhance gaming experience remarkably. Highly recommend!",
                        style: TextStyles.Blinker12regularlightBlack,
                      ),
                      SizedBox(
                        height: 3.h,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8.0,0,0,1),
                        child: Row(
                          children: [
                            Image.asset("assets/images/user1.png"),
                            Spacer(),
                            Text(
                              names[index],
                              style: TextStyles.Blinker14semiBoldBlack,
                            ),
                            Spacer(),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ));
        }),
  );
  }
}

  // return Padding(
  //   padding: const EdgeInsets.all(8.0),
  //   child: Container(
  //     height: 101,
  //     width: 214,
  //     decoration: BoxDecoration(
  //       color: Colors.grey.shade100,
  //       borderRadius: BorderRadius.circular(8),
  //       border: Border.all(color: Colors.grey.shade300),
  //     ),
  //     child: Column(
  //       children: [
  //         Text(rev,style: TextStyles.Blinker12regularlightBlack,),
  //         Text(name,style: TextStyles.Blinker14semiBoldBlack,)
  //       ],
  //     ),
  //   ),
  // );

