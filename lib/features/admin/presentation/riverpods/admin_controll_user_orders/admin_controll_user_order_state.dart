// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/foundation.dart';

import '../../../../../core/comman/helpers/order_state_enum.dart';
import '../../../../orders/data/models/user_order_model.dart';

enum AdminControlUserOrderState {
  initial,
  loading,
  success,
  error,
  successCancelOrder,
}

extension AdminControlUserOrderStateX on AdminControlUserOrderRiverpodState {
  bool isLoading() => state == AdminControlUserOrderState.loading;
  bool isSuccess() => state == AdminControlUserOrderState.success;
  bool isError() => state == AdminControlUserOrderState.error;
  bool isInitial() => state == AdminControlUserOrderState.initial;
  bool isSuccessCancelOrder() =>
      state == AdminControlUserOrderState.successCancelOrder;
}

class AdminControlUserOrderRiverpodState {
  final AdminControlUserOrderState state;
  final List<UserOrderModel> orders;
  final List<UserOrderModel> filteredOrders;
  final String? errorMessage;
  final OrderState? selectedState;
  final String selectedLocation;

  AdminControlUserOrderRiverpodState({
    required this.state,
    this.orders = const [],
    this.filteredOrders = const [],
    this.errorMessage = "un expected error",
    this.selectedState,
    this.selectedLocation = '',
  });

  AdminControlUserOrderRiverpodState copyWith({
    AdminControlUserOrderState? state,
    List<UserOrderModel>? orders,
    List<UserOrderModel>? filteredOrders,
    String? errorMessage,
    OrderState? selectedState,
    String? selectedLocation,
  }) {
    return AdminControlUserOrderRiverpodState(
      state: state ?? this.state,
      orders: orders ?? this.orders,
      filteredOrders: filteredOrders ?? this.filteredOrders,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedState: selectedState ?? this.selectedState,
      selectedLocation: selectedLocation ?? this.selectedLocation,
    );
  }

  @override
  String toString() =>
      'AdminControlUserOrderRiverpodState(state: $state, orders: $orders, filteredOrders: $filteredOrders, errorMessage: $errorMessage)';

  @override
  bool operator ==(covariant AdminControlUserOrderRiverpodState other) {
    if (identical(this, other)) return true;

    return other.state == state &&
        listEquals(other.orders, orders) &&
        listEquals(other.filteredOrders, filteredOrders) &&
        other.errorMessage == errorMessage;
  }

  @override
  int get hashCode =>
      state.hashCode ^
      orders.hashCode ^
      filteredOrders.hashCode ^
      errorMessage.hashCode;
}
