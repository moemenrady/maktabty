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

  Future<void> cancelOrder(UserOrderModel order) async {
    state = state.copyWith(state: UserOrdersState.loading);

    // First try to update order state to cancelled
    final orderUpdateResult =
        await repository.updateOrderState(order.orderId, 'cancelled');

    await orderUpdateResult.fold(
      (failure) {
        state = state.copyWith(
          state: UserOrdersState.error,
          errorMessage: failure.message,
        );
      },
      (_) async {
        // Prepare item quantity updates
        final itemUpdates = order.items.map((item) {
          return {
            'item_id': item.itemId,
            'new_quantity': item.quantity + item.itemCurrentQuantity,
          };
        }).toList();

        // Try to update item quantities
        final quantityUpdateResult =
            await repository.updateItemQuantities(itemUpdates);

        await quantityUpdateResult.fold(
          (failure) async {
            // If quantity update fails, rollback order state
            final rollbackResult =
                await repository.updateOrderState(order.orderId, 'preparing');

            rollbackResult.fold(
              (rollbackFailure) {
                state = state.copyWith(
                  state: UserOrdersState.error,
                  errorMessage:
                      'Critical error: Failed to rollback order state. Please contact support.',
                );
              },
              (_) {
                state = state.copyWith(
                  state: UserOrdersState.error,
                  errorMessage:
                      'Failed to update item quantities. Order cancellation reversed.',
                );
              },
            );
          },
          (_) async {
            // Both updates successful
            await getUserOrders(order.userId);
            state = state.copyWith(
              state: UserOrdersState.successCancelOrder,
            );
          },
        );
      },
    );
  }
}
