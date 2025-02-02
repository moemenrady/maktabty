import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/comman/app_user/app_user_riverpod.dart';
import '../../../data/models/user_order_model.dart';
import '../../../data/repository/orders_repository.dart';
import 'user_orders_state.dart';

final userOrdersProvider = StateNotifierProvider.autoDispose<UserOrdersRiverpod,
    UserOrdersRiverpodState>(
  (ref) => UserOrdersRiverpod(
    repository: ref.watch(ordersRepositoryProvider),
  )..getUserOrders(ref.watch(appUserRiverpodProvider).user!.id),
);

class UserOrdersRiverpod extends StateNotifier<UserOrdersRiverpodState> {
  final OrdersRepository repository;

  UserOrdersRiverpod({required this.repository})
      : super(UserOrdersRiverpodState(state: UserOrdersState.initial));

  List<UserOrderModel> _mergeOrders(List<UserOrderModel> orders) {
    final Map<String, List<UserOrderModel>> groupedOrders = {};

    for (var order in orders) {
      if (!groupedOrders.containsKey(order.orderId)) {
        groupedOrders[order.orderId] = [];
      }
      groupedOrders[order.orderId]!.add(order);
    }

    return groupedOrders.entries.map((entry) {
      final orders = entry.value;
      final firstOrder = orders.first;

      final totalPrice = orders.fold<double>(
        0,
        (sum, order) => sum + (order.itemPrice * order.quantity),
      );

      final totalQuantity = orders.fold<int>(
        0,
        (sum, order) => sum + order.quantity,
      );

      return UserOrderModel(
        orderId: firstOrder.orderId,
        userId: firstOrder.userId,
        address: firstOrder.address,
        imageUrl: firstOrder.imageUrl,
        itemId: firstOrder.itemId,
        itemName: "${firstOrder.itemName} x ${entry.value.last.itemName}",
        quantity: firstOrder.quantity,
        totalPrice: totalPrice,
        region: firstOrder.region,
        userName: firstOrder.userName,
        addressId: firstOrder.addressId,
        orderCreatedAt: firstOrder.orderCreatedAt,
        itemPrice: totalPrice,
        totalQuantity: totalQuantity,
        orderState: firstOrder.orderState,
        items: orders,
      );
    }).toList();
  }

  Future<void> getUserOrders(int? userId) async {
    state = state.copyWith(state: UserOrdersState.loading);

    final result = await repository.fetchOrderSummaryForUser(userId: userId!);

    result.fold(
      (failure) => state = state.copyWith(
        state: UserOrdersState.error,
        errorMessage: failure.message,
      ),
      (orders) {
        final mergedOrders = _mergeOrders(orders);
        state = state.copyWith(
          state: UserOrdersState.success,
          orders: mergedOrders,
          filteredOrders: mergedOrders,
        );
      },
    );
  }

  void filterOrders(String query) {
    if (query.isEmpty) {
      state = state.copyWith(filteredOrders: state.orders);
      return;
    }

    final filtered = state.orders.where((order) {
      return order.items.any(
          (item) => item.itemName.toLowerCase().contains(query.toLowerCase()));
    }).toList();

    state = state.copyWith(filteredOrders: filtered);
  }
}
