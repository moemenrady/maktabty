import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mktabte/features/admin/presentation/riverpods/admin_controll_user_orders/admin_controll_user_order_state.dart';
import '../../../../core/comman/helpers/gap.dart';
import '../../../../core/comman/helpers/order_state_enum.dart';
import '../../../../core/theme/app_pallete.dart';
import '../../../../core/theme/text_style.dart';
import '../../../orders/presentation/riverpods/user_orders_riverpod/user_orders_view_model.dart';
import '../riverpods/admin_controll_user_orders/admin_controll_user_orders_riverpod.dart';
import '../widgets/admin_controll_user_orders/admin_order_card.dart';

class AdminControlUserOrders extends ConsumerWidget {
  const AdminControlUserOrders({super.key});

  final List<String> cairoRegions = const [
    'Nasr City',
    'Maadi',
    'Heliopolis',
    'Downtown',
    'Zamalek',
    '6th of October',
    'New Cairo',
    'Dokki',
    'Mohandessin',
    'Giza',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersState = ref.watch(adminControlUserOrdersProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Gap.h20,
            _buildFilters(context, ref),
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
                          ? _buildEmptyState()
                          : ListView.builder(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              itemCount: ordersState.filteredOrders.length,
                              itemBuilder: (context, index) {
                                final order = ordersState.filteredOrders[index];
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 16.h),
                                  child: AdminOrderCard(
                                    order: order,
                                    onStateChanged: (orderId, newState) {
                                      ref
                                          .read(adminControlUserOrdersProvider
                                              .notifier)
                                          .updateOrderState(orderId, newState);
                                    },
                                  ),
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
          Row(
            children: [
              Icon(
                Icons.shopping_bag_outlined,
                color: AppPallete.lightOrange,
                size: 18.w,
              ),
              Gap.w8,
              Text(
                'Manage Orders',
                style: TextStyles.Blinker20semiBoldBlack,
              ),
            ],
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
                  Icons.admin_panel_settings,
                  color: AppPallete.lightOrange,
                  size: 18.w,
                ),
                Gap.w8,
                Text(
                  'Admin',
                  style: TextStyles.Blinker16regularlightOrange,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          // Order State Filter
          Expanded(
            child: DropdownButtonFormField<OrderState>(
              decoration: InputDecoration(
                labelText: 'Order Status',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
              ),
              items: OrderState.values.map((state) {
                return DropdownMenuItem(
                  value: state,
                  child: Text(
                    state.name,
                    style: TextStyles.Blinker14regular,
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  ref
                      .read(adminControlUserOrdersProvider.notifier)
                      .filterByState(value);
                }
              },
            ),
          ),
          Gap.w12,
          // Location Filter
          Expanded(
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
              ),
              items: [
                const DropdownMenuItem(
                  value: '',
                  child: Text('All Locations'),
                ),
                ...cairoRegions.map((region) {
                  return DropdownMenuItem(
                    value: region,
                    child: Text(
                      region,
                      style: TextStyles.Blinker14regular,
                    ),
                  );
                }),
              ],
              onChanged: (value) {
                ref
                    .read(adminControlUserOrdersProvider.notifier)
                    .filterByLocation(value ?? '');
              },
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
          ref.read(adminControlUserOrdersProvider.notifier).filterOrders(value);
        },
        style: TextStyles.Blinker14regular,
        decoration: InputDecoration(
          hintText: 'Search by order ID or item name...',
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

  Widget _buildEmptyState() {
    return Center(
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
    );
  }
}
