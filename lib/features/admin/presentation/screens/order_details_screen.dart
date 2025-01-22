import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_pallete.dart';
import '../../../../core/theme/text_style.dart';
import '../../data/model/oders_summary_model.dart';
import '../riverpods/view_orders_summary/view_orders_summary_riverpod.dart';

class OrderDetailsScreen extends ConsumerWidget {
  final String orderId;

  const OrderDetailsScreen({
    super.key,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(viewOrdersSummaryProvider);
    final orderItems =
        state.orders.where((order) => order.orderId == orderId).toList();

    if (orderItems.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('Order not found')),
      );
    }

    final firstItem = orderItems.first;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Order Details',
          style: TextStyles.Inter28SemiBoldBlack.copyWith(fontSize: 24.h),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        toolbarHeight: 56.h,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildOrderInfo(firstItem),
                  SizedBox(height: 24.h),
                  Text(
                    'Items',
                    style: TextStyles.Inter19semiBoldBlack.copyWith(
                        fontSize: 19.h),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final item = orderItems[index];
                  return Padding(
                    padding: EdgeInsets.only(bottom: 16.h),
                    child: _buildItemCard(item),
                  );
                },
                childCount: orderItems.length,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: _buildTotalSection(orderItems),
            ),
          ),
          // Add bottom padding for safe area
          SliverPadding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom)),
        ],
      ),
    );
  }

  Widget _buildOrderInfo(OrderSummaryModel order) {
    return Container(
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
          Text(
            'Order #${order.orderId}',
            style: TextStyles.Inter17mediumBlack.copyWith(fontSize: 17.h),
          ),
          SizedBox(height: 8.h),
          Text(
            'Date: ${order.orderCreatedAt.toString().split(' ')[0]}',
            style: TextStyles.Inter15regularBlack.copyWith(fontSize: 15.h),
          ),
          SizedBox(height: 8.h),
          Text(
            'Customer: ${order.userName}',
            style: TextStyles.Inter15regularBlack.copyWith(fontSize: 15.h),
          ),
          SizedBox(height: 8.h),
          Text(
            'Delivery Address:',
            style: TextStyles.Inter15regularBlack.copyWith(fontSize: 15.h),
          ),
          Text(
            '${order.region} - ${order.address}',
            style: TextStyles.Inter15regularBlack.copyWith(fontSize: 15.h),
          ),
        ],
      ),
    );
  }

  Widget _buildItemCard(OrderSummaryModel item) {
    return Container(
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
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Image.network(
              item.imageUrl,
              width: 80.w,
              height: 80.w,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 80.w,
                  height: 80.w,
                  color: Colors.grey[200],
                  child: Icon(Icons.error, size: 30.h, color: Colors.red),
                );
              },
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.itemName,
                  style:
                      TextStyles.Inter15regularBlack.copyWith(fontSize: 15.h),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Quantity: ${item.transactionQuantity}',
                  style:
                      TextStyles.Inter15regularBlack.copyWith(fontSize: 15.h),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Price: \$${item.itemPrice}',
                  style:
                      TextStyles.Inter15regularBlack.copyWith(fontSize: 15.h),
                ),
              ],
            ),
          ),
          Text(
            '\$${(item.itemPrice * item.transactionQuantity).toStringAsFixed(2)}',
            style: TextStyles.Inter15mediumbinkForText.copyWith(fontSize: 15.h),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalSection(List<OrderSummaryModel> items) {
    final total = items.fold<double>(
      0,
      (sum, item) => sum + (item.itemPrice * item.transactionQuantity),
    );

    return Container(
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total Amount',
            style: TextStyles.Inter17mediumBlack.copyWith(fontSize: 17.h),
          ),
          Text(
            '\$${total.toStringAsFixed(2)}',
            style: TextStyles.Lato20boldBlack.copyWith(fontSize: 20.h),
          ),
        ],
      ),
    );
  }
}
