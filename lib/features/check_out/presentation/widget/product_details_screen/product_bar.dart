import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mktabte/features/check_out/presentation/riverpods/check_out/check_out_state.dart';

import '../../../../../core/comman/app_user/app_user_riverpod.dart';
import '../../../../admin/data/model/item_model.dart';
import '../../riverpods/check_out/check_out_riverpod.dart';
import '../../screen/cart_page.dart';

class ProductBar extends ConsumerWidget {
  final ItemModel item;
  const ProductBar({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Stack(children: [
        Positioned(
          left: 0,
          right: 0,
          bottom: 3,
          child: Container(
            height: 60.h,
            width: 296.w,
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
                        height: 45,
                        width: 150,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF68B3B),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Consumer(builder: (context, ref, child) {
                          final checkOutState =
                              ref.watch(checkOutRiverpodProvider);
                          return checkOutState.isLoading()
                              ? const Center(child: CircularProgressIndicator())
                              : TextButton(
                                  onPressed: () {
                                    ref
                                        .read(checkOutRiverpodProvider.notifier)
                                        .addItemToCart(
                                            item.id,
                                            ref
                                                .read(appUserRiverpodProvider)
                                                .user!
                                                .id!);
                                  },
                                  child: const Text(
                                    "Add to cart",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                );
                        })),
                    Container(
                      width: 150,
                      height: 45,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF68B3B),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const CartPage()));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/Add_Item_Cart.png",
                              width: 18.w,
                              height: 18.h,
                            ),
                            const SizedBox(width: 5),
                            const Text(
                              "Go To Cart",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 45,
                      decoration: BoxDecoration(
                        color: const Color(0x00f68b3b),
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
                            color: Color(0xFFB05A1B),
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
