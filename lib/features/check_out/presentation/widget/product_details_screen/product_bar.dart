import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mktabte/features/check_out/presentation/riverpods/check_out/check_out_state.dart';
import 'package:mktabte/main.dart';

import '../../riverpods/check_out/check_out_riverpod.dart';

class ProductBar extends ConsumerWidget {
  const ProductBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checkOutState = ref.watch(checkOutRiverpodProvider);
    return Scaffold(
      body: Stack(children: [
        Positioned(
          left: 0,
          right: 0,
          bottom: 3,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 5.0),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 40,
                      width: 150,
                      decoration: BoxDecoration(
                        color: Color(0xFFF68B3B),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: checkOutState.isLoading()
                          ? const Center(child: CircularProgressIndicator())
                          : TextButton(
                              onPressed: () {
                                ref
                                    .read(checkOutRiverpodProvider.notifier)
                                    .addItemToCart(
                                        "8aad2a80-b210-11ef-a14c-af15a5030040",
                                        1);
                              },
                              child: const Text(
                                "Add to cart",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                    ),
                    Container(
                      width: 150,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Color(0xFFF68B3B),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: InkWell(
                        onTap: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("assets/images/btns/cart_btn_img.png",width: 18.w,height: 18.h,),
                            const SizedBox(width: 5),
                            const Text(
                              "Buy Now",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Color(0xFFF68B3B),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: InkWell(
                        onTap: () {},
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor:
                              const Color.fromARGB(69, 235, 122, 147)
                                  .withOpacity(0.8),
                          child: const Icon(
                            Icons.favorite_border_outlined,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        ),
      ]),
    );
  }
}
