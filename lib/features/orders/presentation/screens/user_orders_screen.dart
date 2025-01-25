import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/comman/helpers/gap.dart';
import '../../../../core/theme/app_pallete.dart';
import '../../../../core/theme/text_style.dart';
import '../riverpods/user_orders_riverpod/user_orders_riverpod.dart';
import '../riverpods/user_orders_riverpod/user_orders_view_model.dart';
import '../widgets/user_orders_screen/order_card.dart';

class UserOrdersScreen extends ConsumerWidget {
  const UserOrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersState = ref.watch(userOrdersProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Gap.h20,
            _buildSearchBar(ref),
            Gap.h20,
            Expanded(
              child: ordersState.isLoading()
                  ? const Center(child: CircularProgressIndicator())
                  : ordersState.isError()
                      ? Center(
                          child: Text(
                            ordersState.errorMessage ?? 'An error occurred',
                            style: TextStyles.Blinker16regularlightBlack,
                          ),
                        )
                      : ordersState.filteredOrders.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/no_orders.png',
                                    height: 200.h,
                                  ),
                                  Gap.h20,
                                  Text(
                                    'No orders found',
                                    style: TextStyles.Blinker20semiBoldBlack,
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              itemCount: ordersState.filteredOrders.length,
                              itemBuilder: (context, index) {
                                final order = ordersState.filteredOrders[index];
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 16.h),
                                  child: OrderCard(order: order),
                                );
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
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
          Text(
            'My Orders',
            style: TextStyles.Blinker20semiBoldBlack,
          ),
          const Spacer(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppPallete.lightOrange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.shopping_bag_outlined,
                  color: AppPallete.lightOrange,
                  size: 18.w,
                ),
                Gap.w8,
                Text(
                  'Orders',
                  style: TextStyles.Blinker16regularlightOrange,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(WidgetRef ref) {
    final viewModel = ref.watch(userOrdersViewModelProvider);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: TextField(
        controller: viewModel.searchController,
        onChanged: (value) {
          ref.read(userOrdersProvider.notifier).filterOrders(value);
        },
        style: TextStyles.Blinker14regular,
        decoration: InputDecoration(
          hintText: 'Search orders by item name...',
          hintStyle: TextStyles.Blinker14regular.copyWith(color: Colors.grey),
          prefixIcon: Icon(Icons.search, size: 20.w),
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        ),
      ),
    );
  }
}
