import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/comman/helpers/gap.dart';
import '../../../../core/comman/helpers/order_state_enum.dart';
import '../../../../core/theme/app_pallete.dart';
import '../../../../core/theme/text_style.dart';
import '../../../../core/utils/show_snack_bar.dart';
import '../../data/models/user_order_model.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../features/orders/presentation/riverpods/user_orders_riverpod/user_orders_riverpod.dart';

class UserOrderDetailsScreen extends ConsumerWidget {
  final UserOrderModel order;

  const UserOrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(userOrdersProvider, (previous, next) {
      if (next.isSuccessCancelOrder()) {
        showSnackBar(
            context, "Order cancelled successfully and inventory updated");
        Navigator.pop(context);
      } else if (next.isError()) {
        showSnackBar(
          context,
          next.errorMessage ?? "An unexpected error occurred",
        );
      }
    });

    final state = ref.watch(userOrdersProvider);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                _buildAppBar(context),
                SliverToBoxAdapter(child: Gap.h20),
                _buildOrderInfo(context),
                SliverToBoxAdapter(child: Gap.h20),
                _buildItemsList(),
                SliverToBoxAdapter(child: Gap.h20),
                _buildTotalSection(),
                SliverToBoxAdapter(child: Gap.h20),
              ],
            ),
            if (state.isLoading())
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
      floatingActionButton: order.orderState == "preparing"
          ? FloatingActionButton.extended(
              onPressed: state.isLoading()
                  ? null
                  : () => _showCancelConfirmation(context, ref),
              backgroundColor: state.isLoading() ? Colors.grey : Colors.red,
              label: const Text('Cancel Order'),
              icon: const Icon(Icons.cancel),
            )
          : null,
    );
  }

  void _showCancelConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Order'),
        content: const Text(
          'Are you sure you want to cancel this order? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(userOrdersProvider.notifier).cancelOrder(order);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Yes, Cancel Order'),
          ),
        ],
      ),
    );
  }

  OrderState get _orderState => order.orderState.toOrderState();

  Color _getStatusColor(OrderState status) {
    switch (status) {
      case OrderState.delivered:
        return Colors.green;
      case OrderState.preparing:
        return Colors.orange;
      case OrderState.cancelled:
        return Colors.red;
    }
  }

  String _getStatusText(OrderState status) {
    switch (status) {
      case OrderState.delivered:
        return 'Delivered';
      case OrderState.preparing:
        return 'Preparing';
      case OrderState.cancelled:
        return 'Cancelled';
    }
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      floating: true,
      title: Text(
        'Order Details',
        style: TextStyles.Blinker20semiBoldBlack,
      ),
      centerTitle: true,
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildOrderInfo(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: order.orderId));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Order ID copied to clipboard',
                          style: TextStyles.Blinker14regular,
                        ),
                        backgroundColor: AppPallete.lightOrange,
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      SizedBox(
                        width: 80.w,
                        child: Text(
                          '#${order.orderId}',
                          style: TextStyles.Blinker16regularlightOrange,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(
                        Icons.copy_rounded,
                        size: 16.w,
                        color: AppPallete.lightOrange,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: _getStatusColor(_orderState).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8.w,
                        height: 8.w,
                        decoration: BoxDecoration(
                          color: _getStatusColor(_orderState),
                          shape: BoxShape.circle,
                        ),
                      ),
                      Gap.w8,
                      Text(
                        _getStatusText(_orderState),
                        style: TextStyles.Blinker14regular.copyWith(
                          color: _getStatusColor(_orderState),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Gap.h16,
            Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 20.w,
                  color: AppPallete.lightGrey,
                ),
                Gap.w8,
                Text(
                  order.orderCreatedAt.toString().split(' ')[0],
                  style: TextStyles.Blinker14regular,
                ),
              ],
            ),
            Gap.h12,
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 20.w,
                  color: AppPallete.lightGrey,
                ),
                Gap.w8,
                Expanded(
                  child: Text(
                    '${order.region} - ${order.address}',
                    style: TextStyles.Blinker14regular.copyWith(
                      color: AppPallete.lightGrey,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemsList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final item = order.items[index];
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
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
                Gap.w16,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 180.w,
                        child: Text(
                          item.itemName,
                          style: TextStyles.Blinker16regularlightBlack,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Gap.h8,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Quantity: ${item.quantity}',
                            style: TextStyles.Blinker14regular,
                          ),
                          Text(
                            '\$${(item.itemPrice * item.quantity).toStringAsFixed(2)}',
                            style: TextStyles.Blinker16regularlightOrange,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        childCount: order.items.length,
      ),
    );
  }

  Widget _buildTotalSection() {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppPallete.lightOrange.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Items',
                  style: TextStyles.Blinker14regular,
                ),
                Text(
                  order.totalQuantity.toString(),
                  style: TextStyles.Blinker16regularlightBlack,
                ),
              ],
            ),
            Gap.h12,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Amount',
                  style: TextStyles.Blinker16regularlightBlack,
                ),
                Text(
                  '\$${order.itemPrice.toStringAsFixed(2)}',
                  style: TextStyles.Blinker20semiBoldBlack.copyWith(
                    color: AppPallete.lightOrange,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
