import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomHomeAdvertising extends StatelessWidget {
  const CustomHomeAdvertising({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final images = [
      "assets/images/slider1.jpg",
      "assets/images/slider2.jpg",
      "assets/images/slider3.jpg",
      "assets/images/slider4.jpg",
      "assets/images/slider5.jpg",
    ];
    return FlutterCarousel(
      items: images.map((image) {
        return Container(
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
            child: Image.asset(
              width: 335.w,
              height: 190.h,
              image,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.error),
                );
              },
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
