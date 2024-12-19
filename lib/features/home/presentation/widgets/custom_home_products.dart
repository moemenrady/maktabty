import 'package:flutter/material.dart';

import '../screens/home.dart';
import '../screens/productscreen.dart';

class CustomHomeProducts extends StatelessWidget {
  const CustomHomeProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
              child: ListView.builder(
                itemCount: offers.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Product(),
                          ));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 343,
                        height: 351,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                                image: AssetImage(offers[index]),
                                fit: BoxFit.cover)),
                      ),
                    ),
                  );
                },
              ),
            );
  }
}
