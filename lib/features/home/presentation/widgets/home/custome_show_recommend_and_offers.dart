import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../admin/data/model/item_model.dart';
import '../../../../check_out/presentation/screen/product_details_creen.dart';

class CustomeShowRecommendAndOffers extends StatelessWidget {
  final List<ItemModel> items;
  const CustomeShowRecommendAndOffers({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return FlutterCarousel(
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
            height: 190.h,
            margin: const EdgeInsets.symmetric(horizontal: 1),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                width: 335.w,
                height: 190.h,
                item.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.error),
                  );
                },
              ),
            ),
          ),
        );
      }).toList(),
      options: CarouselOptions(
        height: 190.h,
        viewportFraction: 0.85,
        enlargeCenterPage: true,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        slideIndicator: const CircularSlideIndicator(),
      ),
    );
  }
}
