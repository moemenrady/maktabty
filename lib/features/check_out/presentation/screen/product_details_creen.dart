import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mktabte/features/check_out/presentation/riverpods/check_out/check_out_riverpod.dart';
import 'package:mktabte/features/check_out/presentation/riverpods/check_out/check_out_state.dart';
import 'package:mktabte/features/home/presentation/widgets/custom_app_bar.dart';
import 'package:mktabte/features/check_out/presentation/widget/product_details_screen/product_bar.dart';
import 'package:mktabte/features/check_out/presentation/widget/product_details_screen/review_card.dart';

import '../../../../core/comman/app_user/app_user_riverpod.dart';
import '../../../../core/comman/widgets/custom_cached_network_image_provider.dart';
import '../../../../core/theme/text_style.dart';
import '../../../../core/utils/show_snack_bar.dart';
import '../../../admin/data/model/item_model.dart';
import '../../../../core/comman/widgets/animated_price_widget.dart';

class ProductDetailsScreen extends ConsumerWidget {
  final ItemModel item;
  const ProductDetailsScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(checkOutRiverpodProvider, (previous, next) {
      if (next.isSuccessAddItemToCart()) {
        showSnackBar(
          context,
          "Item added to cart",
        );
      }
    });

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero Image with gradient overlay
                Stack(
                  children: [
                    Container(
                      height: 400.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Hero(
                        tag: 'product_${item.id}',
                        child: InteractiveViewer(
                          minScale: 0.5,
                          maxScale: 2.0,
                          child: CustomCachedNetworkImageProvider(
                            imageUrl: item.imageUrl,
                          ),
                        ),
                      ),
                    ),
                    // Gradient overlay at the bottom
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.white,
                              Colors.white.withOpacity(0),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              item.name,
                              style: TextStyles.Inter18SemiBoldlightBlack,
                            ),
                          ),
                          AnimatedPriceWidget(
                            price: item.retailPrice,
                            style: TextStyles.Roboto20mediumBlack,
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),

                      Text(
                        "Description",
                        style: TextStyles.Blinker20semiBoldBlack,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        item.description,
                        style: TextStyles.Blinker16regularlightBlack,
                      ),
                      SizedBox(height: 24.h),

                      // Reviews Section
                      Text(
                        "Reviews",
                        style: TextStyles.Blinker20semiBoldBlack,
                      ),
                      SizedBox(height: 16.h),
                      Container(
                        padding: EdgeInsets.all(20.w),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(15.r),
                          border: Border.all(
                            color: Colors.grey.shade200,
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                  5,
                                  (index) => Icon(
                                        Icons.star,
                                        color: Colors.yellow,
                                        size: 24.w, // Adjust the size as needed
                                      )),
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              'No Reviews Yet',
                              style: TextStyles.Blinker18semiBoldBlack,
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'Be the first to review this product',
                              style: TextStyles.Blinker14regular.copyWith(
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 100.h), // Space for bottom bar
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Custom App Bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 16,
                left: 16,
                right: 16,
                bottom: 16,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.transparent,
                  ],
                ),
              ),
              child: CustomAppBar(
                txt: "",
                hasArrow: true,
                hasIcons: true,
              ),
            ),
          ),
          // Product Bar at bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ProductBar(item: item),
          ),
        ],
      ),
    );
  }
}
