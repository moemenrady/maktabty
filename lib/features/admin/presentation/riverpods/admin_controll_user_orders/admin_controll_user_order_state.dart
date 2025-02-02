// ignore_for_file: public_member_api_docs, sort_constructors_first


import 'package:flutter/foundation.dart';

import '../../../../orders/data/models/user_order_model.dart';

enum AdminControlUserOrderState {
  initial,
  loading,
  success,
  error,
}

extension AdminControlUserOrderStateX on AdminControlUserOrderRiverpodState {
  bool isLoading() => state == AdminControlUserOrderState.loading;
  bool isSuccess() => state == AdminControlUserOrderState.success;
  bool isError() => state == AdminControlUserOrderState.error;
  bool isInitial() => state == AdminControlUserOrderState.initial;
}

class AdminControlUserOrderRiverpodState {
  final AdminControlUserOrderState state;
  final List<UserOrderModel> orders;
  final List<UserOrderModel> filteredOrders;
  final String? errorMessage;
  AdminControlUserOrderRiverpodState({
    required this.state,
    this.orders = const [],
    this.filteredOrders = const [],
    this.errorMessage = "un expected error",
  });

  AdminControlUserOrderRiverpodState copyWith({
    AdminControlUserOrderState? state,
    List<UserOrderModel>? orders,
    List<UserOrderModel>? filteredOrders,
    String? errorMessage,
  }) {
    return AdminControlUserOrderRiverpodState(
      state: state ?? this.state,
      orders: orders ?? this.orders,
      filteredOrders: filteredOrders ?? this.filteredOrders,
      errorMessage: errorMessage ?? this.errorMessage,
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
