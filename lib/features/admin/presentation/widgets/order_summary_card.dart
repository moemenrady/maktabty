import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_pallete.dart';
import '../../../../core/theme/text_style.dart';
import '../../../../core/comman/entitys/oders_summary_model.dart';

class OrderSummaryCard extends StatelessWidget {
  final OrderSummaryModel order;
  final VoidCallback onTap;

  const OrderSummaryCard({
    super.key,
    required this.order,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppPallete.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10.r,
              offset: Offset(0, 5.h),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 100.w,
                  child: Text(
                    'Order #${order.orderId}',
                    style:
                        TextStyles.Inter17mediumBlack.copyWith(fontSize: 17.h),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  order.orderCreatedAt.toString().split(' ')[0],
                  style:
                      TextStyles.Inter15regularBlack.copyWith(fontSize: 15.h),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                const Icon(Icons.location_on_outlined),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    '${order.region} - ${order.address}',
                    style:
                        TextStyles.Inter15regularBlack.copyWith(fontSize: 15.h),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Items: ${order.transactionQuantity}',
                  style:
                      TextStyles.Inter15regularBlack.copyWith(fontSize: 15.h),
                ),
                Text(
                  '\$${(order.itemPrice).toStringAsFixed(2)}',
                  style: TextStyles.Inter15mediumbinkForText.copyWith(
                      fontSize: 15.h),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
