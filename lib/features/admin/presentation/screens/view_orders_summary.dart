import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_pallete.dart';
import '../../../../core/theme/text_style.dart';
import '../../../../core/comman/entitys/oders_summary_model.dart';
import '../riverpods/view_orders_summary/view_orders_summary_riverpod.dart';
import '../widgets/order_summary_card.dart';
import 'order_details_screen.dart';

class ViewOrdersSummaryScreen extends ConsumerWidget {
  const ViewOrdersSummaryScreen({super.key});

  List<OrderSummaryModel> _combineOrders(List<OrderSummaryModel> orders) {
    // Group orders by orderId
    final Map<String, List<OrderSummaryModel>> groupedOrders = {};

    for (var order in orders) {
      if (!groupedOrders.containsKey(order.orderId)) {
        groupedOrders[order.orderId] = [];
      }
      groupedOrders[order.orderId]!.add(order);
    }

    // Combine orders with the same ID
    return groupedOrders.entries.map((entry) {
      final orders = entry.value;
      final firstOrder = orders.first;

      // Calculate total price and quantity
      final totalPrice = orders.fold<double>(
        0,
        (sum, order) {
          print(order.itemPrice);
          print(order.transactionQuantity);
          return sum + (order.itemPrice * order.transactionQuantity);
        },
      );

      final totalQuantity = orders.fold<int>(
        0,
        (sum, order) => sum + order.transactionQuantity,
      );

      // Return a combined order
      return OrderSummaryModel(
        orderId: firstOrder.orderId,
        userId: firstOrder.userId,
        address: firstOrder.address,
        region: firstOrder.region,
        userName: firstOrder.userName,
        addressId: firstOrder.addressId,
        orderCreatedAt: firstOrder.orderCreatedAt,
        itemPrice: totalPrice,
        transactionQuantity: totalQuantity,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(viewOrdersSummaryProvider);
    final combinedOrders = _combineOrders(state.orders);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Orders Summary',
          style: TextStyles.Inter28SemiBoldBlack.copyWith(fontSize: 24.h),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        toolbarHeight: 56.h,
      ),
      body: state.isLoading()
          ? const Center(child: CircularProgressIndicator())
          : state.isError()
              ? Center(child: Text(state.error ?? 'An error occurred'))
              : CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: EdgeInsets.all(16.w),
                      sliver: SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildDateFilter(context, ref),
                            SizedBox(height: 16.h),
                            Text(
                              'Total Orders: ${combinedOrders.length}',
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
                            final order = combinedOrders[index];
                            return Padding(
                              padding: EdgeInsets.only(bottom: 16.h),
                              child: OrderSummaryCard(
                                order: order,
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OrderDetailsScreen(
                                        orderId: order.orderId),
                                  ),
                                ),
                              ),
                            );
                          },
                          childCount: combinedOrders.length,
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildDateFilter(BuildContext context, WidgetRef ref) {
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
          Expanded(
            child: GestureDetector(
              onTap: () async {
                final DateTimeRange? dateRange = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                  currentDate: DateTime.now(),
                );

                if (dateRange != null) {
                  ref
                      .read(viewOrdersSummaryProvider.notifier)
                      .fetchOrderSummary(
                        startDate: dateRange.start,
                        endDate: dateRange.end,
                      );
                }
              },
              child: Row(
                children: [
                  const Icon(Icons.calendar_today),
                  SizedBox(width: 8.w),
                  Text(
                    'Filter by Date',
                    style:
                        TextStyles.Inter15regularBlack.copyWith(fontSize: 15.h),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
