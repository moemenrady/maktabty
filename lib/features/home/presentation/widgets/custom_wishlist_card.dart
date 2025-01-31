import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/comman/app_user/app_user_riverpod.dart';
import '../../../../core/theme/text_style.dart';
import '../../../admin/data/model/item_model.dart';
import '../../../check_out/presentation/screen/product_details_creen.dart';
import '../../data/repository/home_repository.dart';
import '../riverpods/wishlist_riverpod/wishlist_riverpod.dart';

class CustomWishlistCard extends ConsumerWidget {
  final List<ItemModel> wishListItems;
  const CustomWishlistCard({super.key, required this.wishListItems});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                    InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ProductDetailsScreen(item: item)),
                          );
                        },
                        child: Container(
                          width: 88.w,
                          height: 88.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: NetworkImage(item.imageUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        )),
                    const SizedBox(width: 16.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: TextStyles.Inter15regularBlack,
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          "EGP ${item.retailPrice.toString()}",
                          style: TextStyles.Inter15regularBlack,
                        ),
                        const SizedBox(height: 8.0),
                        Container(
                          width: 117.w,
                          height: 32.h,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF9E56),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: InkWell(
                            onTap: () async {
                              await ref
                                  .read(wishlistProvider.notifier)
                                  .addItemToCart(
                                      item.id,
                                      ref
                                          .read(appUserRiverpodProvider)
                                          .user!
                                          .id!);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/images/shopping-cart_black.png",
                                  width: 16.w,
                                  height: 16.w,
                                ),
                                const SizedBox(width: 5),
                                const Text(
                                  "Add to cart",
                                  style: TextStyle(color: Colors.black),
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
                  onTap: () {
                    ref.read(wishlistProvider.notifier).removeFromFavorites(
                        ref.read(appUserRiverpodProvider).user!.id!, item.id);
                  },
                  child: Image.asset(
                    "assets/images/heart.png",
                    width: 20.w,
                    height: 19.75.h,
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
