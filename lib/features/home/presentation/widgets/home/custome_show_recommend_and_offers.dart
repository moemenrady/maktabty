import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/text_style.dart';
import '../../../../admin/data/model/item_model.dart';
import '../../../../check_out/presentation/screen/product_details_creen.dart';

class CustomeShowRecommendAndOffers extends StatelessWidget {
  final List<ItemModel> items;
  const CustomeShowRecommendAndOffers({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return FadeInRight(
        child: FlutterCarousel(
      items: items.map((item) {
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailsScreen(item: item),
            ),
          ),
          child: Container(
            width: 335.w,
            margin: EdgeInsets.symmetric(horizontal: 8.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r),
              color: const Color.fromARGB(121, 184, 169, 152),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image and overlay section
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(15.r),
                      ),
                      child: Image.network(
                        item.imageUrl,
                        height: 170.h,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 170.h,
                            color: Colors.grey[300],
                            child: const Icon(Icons.error),
                          );
                        },
                      ),
                    ),
                    // Gradient overlay
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(15.r),
                          ),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Description overlay
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.name,
                                        style:
                                            TextStyles.blinker20SemiBoldwhite,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        'Discover our handpicked selection',
                                        style: TextStyles.blinker14regularwhite,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                    vertical: 6.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF68B3B),
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                  child: Text(
                                    'EGP ${item.retailPrice}',
                                    style: TextStyles.blinker14Boldwhite,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h),
                            Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: const Color(0xFFF68B3B),
                                  size: 16.w,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  'Best Quality Guaranteed',
                                  style: TextStyles.blinker14regularwhite,
                                ),
                                const Spacer(),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                    vertical: 6.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        132, 255, 255, 255),
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.shopping_cart_outlined,
                                        color: const Color(0xFFF68B3B),
                                        size: 16.w,
                                      ),
                                      SizedBox(width: 4.w),
                                      Text(
                                        'Buy Now',
                                        style:
                                            TextStyles.Blinker14semiBoldBlack,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
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
        );
      }).toList(),
      options: CarouselOptions(
        height: 200.h,
        viewportFraction: 0.85,
        enlargeCenterPage: true,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        slideIndicator: const CircularSlideIndicator(),
      ),
    ));
  }
}
