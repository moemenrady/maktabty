import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/comman/helpers/order_state_enum.dart';
import '../../../../orders/data/models/user_order_model.dart';
import '../../../data/repository/admin_repository.dart';
import 'admin_controll_user_order_state.dart';

final adminControlUserOrdersProvider = StateNotifierProvider.autoDispose<
    AdminControlUserOrdersRiverpod, AdminControlUserOrderRiverpodState>(
  (ref) => AdminControlUserOrdersRiverpod(
    repository: ref.watch(adminRepositoryProvider),
  )..getUserOrders(),
);

class AdminControlUserOrdersRiverpod
    extends StateNotifier<AdminControlUserOrderRiverpodState> {
  final AdminRepository repository;

  AdminControlUserOrdersRiverpod({required this.repository})
      : super(AdminControlUserOrderRiverpodState(
            state: AdminControlUserOrderState.initial));

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

      return UserOrderModel(
        orderId: firstOrder.orderId,
        userId: firstOrder.userId,
        address: firstOrder.address,
        imageUrl: firstOrder.imageUrl,
        itemId: firstOrder.itemId,
        itemName: "${firstOrder.itemName} x ${entry.value.last.itemName}",
        quantity: firstOrder.quantity,
        totalPrice: orders.fold(
          0,
          (sum, order) => sum + (order.itemPrice * order.quantity),
        ),
        region: firstOrder.region,
        userName: firstOrder.userName,
        addressId: firstOrder.addressId,
        orderCreatedAt: firstOrder.orderCreatedAt,
        itemPrice: orders.fold(
          0,
          (sum, order) => sum + (order.itemPrice * order.quantity),
        ),
        totalQuantity: orders.fold(
          0,
          (sum, order) => sum + order.quantity,
        ),
        orderState: firstOrder.orderState,
        items: orders,
      );
    }).toList();
  }

  Future<void> getUserOrders() async {
    state = state.copyWith(state: AdminControlUserOrderState.loading);

    final result = await repository.fetchOrderSummaryForUser();

    result.fold(
      (failure) => state = state.copyWith(
        state: AdminControlUserOrderState.error,
        errorMessage: failure.message,
      ),
      (orders) {
        final mergedOrders = _mergeOrders(orders);
        state = state.copyWith(
          state: AdminControlUserOrderState.success,
          orders: mergedOrders,
          filteredOrders: mergedOrders,
        );
      },
    );
  }

  Future<void> updateOrderState(String orderId, OrderState newState) async {
    final result = await repository.updateOrderState(orderId, newState);

    result.fold(
      (failure) => state = state.copyWith(
        state: AdminControlUserOrderState.error,
        errorMessage: failure.message,
      ),
      (orders) {
        final updatedOrders = state.orders.map((order) {
          if (order.orderId == orderId) {
            return order.copyWith(orderState: newState.name);
          }
          return order;
        }).toList();

        state = state.copyWith(
          orders: updatedOrders,
          filteredOrders: updatedOrders,
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
      return order.itemName.toLowerCase().contains(query.toLowerCase()) ||
          order.orderId.toLowerCase().contains(query.toLowerCase());
    }).toList();

    state = state.copyWith(filteredOrders: filtered);
  }
}
