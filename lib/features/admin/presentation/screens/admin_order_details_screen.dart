import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mktabte/features/admin/presentation/riverpods/admin_controll_user_orders/admin_controll_user_order_state.dart';
import '../../../../core/comman/helpers/gap.dart';
import '../../../../core/comman/helpers/order_state_enum.dart';
import '../../../../core/theme/app_pallete.dart';
import '../../../../core/theme/text_style.dart';
import '../../../../core/utils/show_snack_bar.dart';
import '../../../orders/data/models/user_order_model.dart';
import '../riverpods/admin_controll_user_orders/admin_controll_user_orders_riverpod.dart';

class AdminOrderDetailsScreen extends ConsumerWidget {
  final UserOrderModel order;

  const AdminOrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(adminControlUserOrdersProvider, (previous, next) {
      if (next.isSuccessCancelOrder()) {
        showSnackBar(
            context, "Order cancelled successfully and inventory updated");
        Navigator.pop(context);
      } else if (next.isSuccess()) {
        showSnackBar(context, "Order status updated successfully");
      } else if (next.isError()) {
        showSnackBar(
            context, next.errorMessage ?? "An unexpected error occurred");
      }
    });

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            _buildAppBar(context),
            SliverToBoxAdapter(child: Gap.h20),
            _buildOrderInfo(context, ref),
            SliverToBoxAdapter(child: Gap.h20),
            _buildItemsList(),
            SliverToBoxAdapter(child: Gap.h20),
            _buildTotalSection(),
            SliverToBoxAdapter(child: Gap.h20),
          ],
        ),
      ),
    );
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

  Widget _buildOrderInfo(BuildContext context, WidgetRef ref) {
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
                Expanded(
                  child: GestureDetector(
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
                        Expanded(
                          child: Text(
                            '#${order.orderId}',
                            style: TextStyles.Blinker16regularlightOrange,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Gap.w4,
                        Icon(
                          Icons.copy_rounded,
                          size: 16.w,
                          color: AppPallete.lightOrange,
                        ),
                      ],
                    ),
                  ),
                ),
                Gap.w16,
                _buildStateDropdown(context, ref),
              ],
            ),
            Gap.h16,
            Row(
              children: [
                Icon(
                  Icons.person_outline,
                  size: 20.w,
                  color: AppPallete.lightGrey,
                ),
                Gap.w8,
                Text(
                  order.userName,
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
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Gap.h12,
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
          ],
        ),
      ),
    );
  }

  Widget _buildStateDropdown(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<OrderState>(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
        decoration: BoxDecoration(
          color:
              _getStatusColor(order.orderState.toOrderState()).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                color: _getStatusColor(order.orderState.toOrderState()),
                shape: BoxShape.circle,
              ),
            ),
            Gap.w8,
            Text(
              _getStatusText(order.orderState.toOrderState()),
              style: TextStyles.Blinker14regular.copyWith(
                color: _getStatusColor(order.orderState.toOrderState()),
              ),
            ),
            Gap.w4,
            Icon(
              Icons.arrow_drop_down,
              color: _getStatusColor(order.orderState.toOrderState()),
              size: 20.w,
            ),
          ],
        ),
      ),
      onSelected: (OrderState newState) async {
        if (newState == OrderState.cancelled) {
          // Show confirmation dialog
          final shouldCancel = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Cancel Order'),
              content:
                  const Text('Are you sure you want to cancel this order?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Yes'),
                ),
              ],
            ),
          );

          if (shouldCancel == true) {
            final itemUpdates = order.items.map((item) {
              return {
                'item_id': item.itemId,
                'new_quantity': item.quantity + item.itemCurrentQuantity,
              };
            }).toList();

            ref
                .read(adminControlUserOrdersProvider.notifier)
                .cancelOrder(order, itemUpdates);
          }
        } else {
          ref
              .read(adminControlUserOrdersProvider.notifier)
              .updateOrderState(order.orderId, newState);
        }
        Navigator.pop(context);
      },
      itemBuilder: (context) => OrderState.values.map((state) {
        return PopupMenuItem(
          value: state,
          child: Row(
            children: [
              Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  color: _getStatusColor(state),
                  shape: BoxShape.circle,
                ),
              ),
              Gap.w8,
              Text(
                _getStatusText(state),
                style: TextStyles.Blinker14regular.copyWith(
                  color: _getStatusColor(state),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildItemsList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final item = order.items[index];
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
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
                Container(
                  width: 80.w,
                  height: 80.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    color: Colors.grey[200],
                    image: DecorationImage(
                      image: NetworkImage(item.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Gap.w16,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: item.itemId));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Item ID copied to clipboard',
                                style: TextStyles.Blinker14regular,
                              ),
                              backgroundColor: AppPallete.lightOrange,
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                '#${item.itemId}',
                                style: TextStyles.Blinker14regular.copyWith(
                                  color: AppPallete.lightGrey,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Gap.w4,
                            Icon(
                              Icons.copy_rounded,
                              size: 14.w,
                              color: AppPallete.lightGrey,
                            ),
                          ],
                        ),
                      ),
                      Gap.h4,
                      Text(
                        item.itemName,
                        style: TextStyles.Blinker16regularlightBlack,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
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
                  order.items.length.toString(),
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
                  '\$${order.totalPrice.toStringAsFixed(2)}',
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
}
