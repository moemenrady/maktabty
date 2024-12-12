import 'package:flutter/material.dart';
import 'package:mktabte/core/theme/text_style.dart';

List reviews = ["Excellent joystick company! Their products are durable,\n responsive, and enhance gaming experience remarkably.\n Highly recommend!",
"Excellent joystick company! Their products are durable,\n responsive, and enhance gaming experience remarkably.\n Highly recommend!",
"Excellent joystick company! Their products are durable,\n responsive, and enhance gaming experience remarkably.\n Highly recommend!",
"Excellent joystick company! Their products are durable,\n responsive, and enhance gaming experience remarkably.\n Highly recommend!",];
List names = ["OSOS","OSOS","OSOS","OSOS",];


Widget ReviewCard() {
    return SizedBox(
              height: 101,
      width: 214,
              child: ListView.builder(
                  itemCount: reviews.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.grey.shade100, ),
                        child: Column(children: [
                          Text(reviews[index],style: TextStyles.Blinker12regularlightBlack,),
                          Text(names[index],style: TextStyles.Blinker14semiBoldBlack,)
                        ],),  
                      ),
                    );
                  }),
            );




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
}


