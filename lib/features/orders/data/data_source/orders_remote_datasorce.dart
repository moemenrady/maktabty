import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/utils/try_and_catch.dart';

final ordersRemoteDataSourceProvider =
    Provider.autoDispose<OrdersRemoteDataSource>((ref) =>
        OrdersRemoteDataSourceImpl(
            supabaseClient: ref.watch(supabaseClientProvider)));

final supabaseClientProvider =
    Provider.autoDispose<SupabaseClient>((ref) => Supabase.instance.client);

abstract class OrdersRemoteDataSource {
  Future<List<Map<String, dynamic>>> fetchOrderSummaryForUser({
    required int userId,
  });
}

class OrdersRemoteDataSourceImpl implements OrdersRemoteDataSource {
  final SupabaseClient supabaseClient;

  OrdersRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<List<Map<String, dynamic>>> fetchOrderSummaryForUser({
    required int userId,
  }) async {
    return executeTryAndCatchForDataLayer(() async {
      final response = await supabaseClient
          .from('user_orders')
          .select()
          .eq('user_id', userId)
          .order('order_created_at', ascending: false);
      // Map the response to a list of OrderSummary objects
      return response;
    });
  }
}
