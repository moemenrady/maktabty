import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../core/theme/app_pallete.dart';
import '../../../admin/data/model/item_model.dart';

class ServiceProviderItemCard extends StatelessWidget {
  final ItemModel item;
  final VoidCallback onTap;

  const ServiceProviderItemCard({
    Key? key,
    required this.item,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
              ),
              child: item.imageUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: item.imageUrl,
                      height: 150.h,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        height: 150.h,
                        width: double.infinity,
                        color: Colors.grey.shade200,
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppPallete.binkForText.withOpacity(0.5),
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        height: 150.h,
                        width: double.infinity,
                        color: Colors.grey.shade200,
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          size: 40.sp,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    )
                  : Container(
                      height: 150.h,
                      width: double.infinity,
                      color: Colors.grey.shade200,
                      child: Icon(
                        Icons.image_outlined,
                        size: 40.sp,
                        color: Colors.grey.shade400,
                      ),
                    ),
            ),

            // Product Info
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  Text(
                    item.name,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.h),

                  // Product Price
                  Row(
                    children: [
                      Text(
                        'EGP ${item.retailPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: AppPallete.binkForText,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppPallete.binkForText.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          'x${item.quantity}',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: AppPallete.binkForText,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),

                  // Profit
                  Row(
                    children: [
                      Icon(
                        Icons.trending_up,
                        size: 16.sp,
                        color: Colors.green.shade600,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        'Profit: EGP ${(item.retailPrice - item.wholesalePrice).toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.green.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
