import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mktabte/features/check_out/presentation/riverpods/check_out/check_out_riverpod.dart';
import 'package:mktabte/features/check_out/presentation/riverpods/check_out/check_out_state.dart';
import 'package:mktabte/features/home/presentation/widgets/custom_app_bar.dart';
import 'package:mktabte/features/check_out/presentation/widget/product_details_screen/product_bar.dart';

import '../../../../core/comman/widgets/custom_cached_network_image_provider.dart';
import '../../../../core/theme/text_style.dart';
import '../../../../core/utils/show_snack_bar.dart';
import '../../../admin/data/model/item_model.dart';
import '../../../../core/comman/widgets/animated_price_widget.dart';
import '../riverpods/rating/rating_riverpod.dart';
import '../widget/product_details_screen/custom_rating_section.dart';

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

    ref.listen(ratingProvider(item.id), (previous, next) {
      if (next.isSuccessAddRating()) {
        showSnackBar(context, "Rating added successfully");
      } else if (next.isError()) {
        showSnackBar(context, next.errorMessage ?? "Error");
        print(next.errorMessage);
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

                if (item.quantity < 5)
                  Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: Colors.red,
                          size: 20.w,
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: TextStyles.Blinker14regular.copyWith(
                                  color: Colors.red),
                              children: [
                                const TextSpan(
                                  text: 'Only ',
                                ),
                                TextSpan(
                                  text: '${item.quantity} items',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                  text:
                                      ' left in stock ${item.quantity <= 0 ? "" : "- order soon"} ',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
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
//
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
                      CustomRatingSection(
                        item: item,
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
