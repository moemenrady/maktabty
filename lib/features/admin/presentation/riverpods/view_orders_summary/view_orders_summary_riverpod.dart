import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repository/admin_repository.dart';
import 'view_orders_summary_state.dart';

final viewOrdersSummaryProvider =
    StateNotifierProvider<ViewOrdersSummaryController, ViewOrdersSummaryState>(
  (ref) => ViewOrdersSummaryController(
    repository: ref.watch(adminRepositoryProvider),
  ),
);

class ViewOrdersSummaryController
    extends StateNotifier<ViewOrdersSummaryState> {
  final AdminRepository repository;

  ViewOrdersSummaryController({required this.repository})
      : super(ViewOrdersSummaryState.initial()) {
    fetchOrderSummary();
  }

  Future<void> fetchOrderSummary({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    state = state.copyWith(status: ViewOrdersSummaryStatus.loading);

    final result = await repository.fetchOrderSummaryByDateRange(
      startDate: startDate ?? DateTime.now().subtract(const Duration(days: 30)),
      endDate: endDate ?? DateTime.now(),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: ViewOrdersSummaryStatus.failure,
        error: failure.message,
      ),
      (orders) => state = state.copyWith(
        status: ViewOrdersSummaryStatus.success,
        orders: orders,
      ),
    );
  }
}
