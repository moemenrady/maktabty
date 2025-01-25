import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/comman/helpers/gap.dart';
import '../../../../../core/comman/helpers/order_state_enum.dart';
import '../../../../../core/theme/app_pallete.dart';
import '../../../../../core/theme/text_style.dart';
import '../../../../orders/data/models/user_order_model.dart';
import '../../screens/admin_order_details_screen.dart';

class AdminOrderCard extends ConsumerWidget {
  final UserOrderModel order;
  final Function(String orderId, OrderState newState) onStateChanged;

  const AdminOrderCard({
    super.key,
    required this.order,
    required this.onStateChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdminOrderDetailsScreen(order: order),
          ),
        );
      },
      child: Container(
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
          children: [
            _buildHeader(context),
            _buildContent(),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppPallete.lightOrange.withOpacity(0.1),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.r),
          topRight: Radius.circular(16.r),
        ),
      ),
      child: Row(
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
          const Spacer(),
          _buildStateDropdown(context),
          Gap.w12,
          Text(
            order.orderCreatedAt.toString().split(' ')[0],
            style: TextStyles.Blinker14regular,
          ),
        ],
      ),
    );
  }

  Widget _buildStateDropdown(BuildContext context) {
    Color getStatusColor(OrderState status) {
      switch (status) {
        case OrderState.delivered:
          return Colors.green;
        case OrderState.preparing:
          return Colors.orange;
        case OrderState.cancelled:
          return Colors.red;
      }
    }

    String getStatusText(OrderState status) {
      switch (status) {
        case OrderState.delivered:
          return 'Delivered';
        case OrderState.preparing:
          return 'Preparing';
        case OrderState.cancelled:
          return 'Cancelled';
      }
    }

    return PopupMenuButton<OrderState>(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
        decoration: BoxDecoration(
          color:
              getStatusColor(order.orderState.toOrderState()).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                color: getStatusColor(order.orderState.toOrderState()),
                shape: BoxShape.circle,
              ),
            ),
            Gap.w8,
            Text(
              getStatusText(order.orderState.toOrderState()),
              style: TextStyles.Blinker14regular.copyWith(
                color: getStatusColor(order.orderState.toOrderState()),
              ),
            ),
            Gap.w4,
            Icon(
              Icons.arrow_drop_down,
              color: getStatusColor(order.orderState.toOrderState()),
              size: 20.w,
            ),
          ],
        ),
      ),
      onSelected: (OrderState newState) {
        onStateChanged(order.orderId, newState);
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
                  color: getStatusColor(state),
                  shape: BoxShape.circle,
                ),
              ),
              Gap.w8,
              Text(
                getStatusText(state),
                style: TextStyles.Blinker14regular.copyWith(
                  color: getStatusColor(state),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildImagesRow(),
              Gap.w16,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.itemName,
                      style: TextStyles.Blinker16regularlightBlack,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Gap.h8,
                    Text(
                      'Quantity: ${order.totalQuantity}',
                      style: TextStyles.Blinker14regular,
                    ),
                  ],
                ),
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
    );
  }

  Widget _buildImagesRow() {
    const maxImages = 3; // Maximum number of images to show
    final imageSize = order.items.length == 1
        ? 80.w
        : order.items.length == 2
            ? 70.w
            : order.items.length == 3
                ? 60.w
                : 40.w;

    return SizedBox(
      height: 80.w,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...order.items.take(maxImages).map((item) => Padding(
                padding: EdgeInsets.only(right: 4.w),
                child: Container(
                  width: imageSize,
                  height: imageSize,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    color: Colors.grey[200],
                    image: DecorationImage(
                      image: NetworkImage(item.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              )),
          if (order.items.length > maxImages)
            Container(
              width: imageSize,
              height: imageSize,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                  Center(
                    child: Text(
                      '+${order.items.length - maxImages}',
                      style: TextStyles.Blinker14regular.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total Amount',
            style: TextStyles.Blinker14regular,
          ),
          Text(
            '\$${order.totalPrice.toStringAsFixed(2)}',
            style: TextStyles.Blinker16regularlightOrange,
          ),
        ],
      ),
    );
  }
}
