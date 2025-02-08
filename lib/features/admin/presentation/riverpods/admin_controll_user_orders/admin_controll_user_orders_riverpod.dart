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
    state = state.copyWith(state: AdminControlUserOrderState.loading);

    final result = await repository.updateOrderState(orderId, newState);

    result.fold(
      (failure) => state = state.copyWith(
        state: AdminControlUserOrderState.error,
        errorMessage: failure.message,
      ),
      (_) async {
        // Update the local state
        final updatedOrders = state.orders.map((order) {
          if (order.orderId == orderId) {
            return order.copyWith(orderState: newState.name);
          }
          return order;
        }).toList();

        // Fetch fresh data to ensure sync
        await getUserOrders();

        state = state.copyWith(
          state: AdminControlUserOrderState.success,
          orders: updatedOrders,
          filteredOrders: updatedOrders,
        );
      },
    );
  }

  Future<void> cancelOrder(
      UserOrderModel order, List<Map<String, dynamic>> itemUpdates) async {
    state = state.copyWith(state: AdminControlUserOrderState.loading);

    // First update the order state
    final orderUpdateResult = await repository.updateOrderState(
      order.orderId,
      OrderState.cancelled,
    );

    await orderUpdateResult.fold(
      (failure) async {
        state = state.copyWith(
          state: AdminControlUserOrderState.error,
          errorMessage: failure.message,
        );
      },
      (_) async {
        // Then update the item quantities
        final quantityUpdateResult =
            await repository.updateItemQuantities(itemUpdates);

        await quantityUpdateResult.fold(
          (failure) async {
            // If quantity update fails, rollback order state
            final rollbackResult = await repository.updateOrderState(
              order.orderId,
              OrderState.preparing,
            );

            rollbackResult.fold(
              (rollbackFailure) {
                state = state.copyWith(
                  state: AdminControlUserOrderState.error,
                  errorMessage:
                      'Critical error: Failed to rollback order state. Please contact support.',
                );
              },
              (_) {
                state = state.copyWith(
                  state: AdminControlUserOrderState.error,
                  errorMessage:
                      'Failed to update item quantities. Order cancellation reversed.',
                );
              },
            );
          },
          (_) async {
            // Both updates successful
            await getUserOrders();
            state = state.copyWith(
              state: AdminControlUserOrderState.successCancelOrder,
            );
          },
        );
      },
    );
  }

  void applyFilters() {
    var filtered = state.orders;

    // Apply state filter
    if (state.selectedState != null) {
      filtered = filtered
          .where(
              (order) => order.orderState.toOrderState() == state.selectedState)
          .toList();
    }

    // Apply location filter
    if (state.selectedLocation.isNotEmpty) {
      filtered = filtered
          .where((order) => order.region == state.selectedLocation)
          .toList();
    }

    state = state.copyWith(filteredOrders: filtered);
  }

  void filterByState(OrderState orderState) {
    state = state.copyWith(selectedState: orderState);
    applyFilters();
  }

  void filterByLocation(String location) {
    state = state.copyWith(selectedLocation: location);
    applyFilters();
  }

  void filterOrders(String query) {
    if (query.isEmpty) {
      applyFilters();
      return;
    }

    final filtered = state.orders.where((order) {
      final matchesQuery =
          order.itemName.toLowerCase().contains(query.toLowerCase()) ||
              order.orderId.toLowerCase().contains(query.toLowerCase());

      final matchesState = state.selectedState == null ||
          order.orderState.toOrderState() == state.selectedState;

      final matchesLocation = state.selectedLocation.isEmpty ||
          order.region == state.selectedLocation;

      return matchesQuery && matchesState && matchesLocation;
    }).toList();

    state = state.copyWith(filteredOrders: filtered);
  }
}
