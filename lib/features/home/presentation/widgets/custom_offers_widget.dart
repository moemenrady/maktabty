import 'package:flutter/material.dart';

import '../screens/home.dart';

class CustomOffersWidget extends StatelessWidget {
  const CustomOffersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
              height: 200,
              child: ListView.builder(
                  itemCount: offers.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 335,
                        height: 190,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                                image: AssetImage(offers[index]),
                                fit: BoxFit.cover)),
                      ),
                    );
                  }),
            );
  }
}
