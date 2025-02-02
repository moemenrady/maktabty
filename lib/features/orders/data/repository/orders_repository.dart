import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/erorr/failure.dart';
import '../../../../core/utils/try_and_catch.dart';
import '../data_source/orders_remote_datasorce.dart';
import '../models/user_order_model.dart';

final ordersRepositoryProvider = Provider.autoDispose<OrdersRepository>((ref) {
  return OrdersRepository(
    ordersRemoteDataSource: ref.watch(ordersRemoteDataSourceProvider),
  );
});

class OrdersRepository {
  final OrdersRemoteDataSource ordersRemoteDataSource;

  OrdersRepository({required this.ordersRemoteDataSource});

  Future<Either<Failure, List<UserOrderModel>>> fetchOrderSummaryForUser({
    required int userId,
  }) async {
    return executeTryAndCatchForRepository(() async {
      final result =
          await ordersRemoteDataSource.fetchOrderSummaryForUser(userId: userId);
      final data = result.map((e) => UserOrderModel.fromMap(e)).toList();
      return data;
    });
  }
}
