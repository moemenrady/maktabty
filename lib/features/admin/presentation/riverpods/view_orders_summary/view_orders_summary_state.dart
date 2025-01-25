import '../../../../../core/comman/entitys/oders_summary_model.dart';

enum ViewOrdersSummaryStatus { initial, loading, success, failure }

class ViewOrdersSummaryState {
  final ViewOrdersSummaryStatus status;
  final List<OrderSummaryModel> orders;
  final String? error;
  final DateTime? startDate;
  final DateTime? endDate;

  ViewOrdersSummaryState({
    required this.status,
    required this.orders,
    this.error,
    this.startDate,
    this.endDate,
  });

  factory ViewOrdersSummaryState.initial() {
    return ViewOrdersSummaryState(
      status: ViewOrdersSummaryStatus.initial,
      orders: [],
    );
  }

  ViewOrdersSummaryState copyWith({
    ViewOrdersSummaryStatus? status,
    List<OrderSummaryModel>? orders,
    String? error,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return ViewOrdersSummaryState(
      status: status ?? this.status,
      orders: orders ?? this.orders,
      error: error ?? this.error,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  bool isLoading() => status == ViewOrdersSummaryStatus.loading;
  bool isSuccess() => status == ViewOrdersSummaryStatus.success;
  bool isError() => status == ViewOrdersSummaryStatus.failure;
}
