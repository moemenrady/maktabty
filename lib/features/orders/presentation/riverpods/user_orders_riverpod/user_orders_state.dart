import '../../../data/models/user_order_model.dart';

enum UserOrdersState {
  initial,
  loading,
  success,
  error,
  successCancelOrder,
}

class UserOrdersRiverpodState {
  final UserOrdersState state;
  final String? errorMessage;
  final List<UserOrderModel> orders;
  final List<UserOrderModel> filteredOrders;

  UserOrdersRiverpodState({
    this.state = UserOrdersState.initial,
    this.errorMessage,
    this.orders = const [],
    this.filteredOrders = const [],
  });

  bool isLoading() => state == UserOrdersState.loading;
  bool isSuccess() => state == UserOrdersState.success;
  bool isError() => state == UserOrdersState.error;
  bool isSuccessCancelOrder() => state == UserOrdersState.successCancelOrder;

  UserOrdersRiverpodState copyWith({
    UserOrdersState? state,
    String? errorMessage,
    List<UserOrderModel>? orders,
    List<UserOrderModel>? filteredOrders,
  }) {
    return UserOrdersRiverpodState(
      state: state ?? this.state,
      errorMessage: errorMessage ?? this.errorMessage,
      orders: orders ?? this.orders,
      filteredOrders: filteredOrders ?? this.filteredOrders,
    );
  }
}
