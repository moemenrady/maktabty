import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomCachedNetworkImageProvider extends StatelessWidget {
  final String imageUrl;

  const CustomCachedNetworkImageProvider({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      cacheManager: CacheManager(Config(
        'ground_image',
        stalePeriod: const Duration(days: 3),
        maxNrOfCacheObjects: 200,
      )),
      width: 323.w,
      fit: BoxFit.cover,
      height: 170.h,
      imageUrl: imageUrl,
      progressIndicatorBuilder: (context, url, downloadProgress) {
        return Center(
          child: CircularProgressIndicator(
            value: downloadProgress.progress,
          ),
        );
      },
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}
