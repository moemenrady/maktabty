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
  Future<void> updateOrderState(String orderId, String newState);
  Future<void> updateItemQuantities(List<Map<String, dynamic>> itemUpdates);
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

  @override
  Future<void> updateOrderState(String orderId, String newState) async {
    return executeTryAndCatchForDataLayer(() async {
      await supabaseClient
          .from('orders')
          .update({'state': newState}).eq('id', orderId);
    });
  }

  @override
  Future<void> updateItemQuantities(
      List<Map<String, dynamic>> itemUpdates) async {
    return executeTryAndCatchForDataLayer(() async {
      for (var update in itemUpdates) {
        await supabaseClient.from('items').update(
            {'quantity': update['new_quantity']}).eq('id', update['item_id']);
      }
    });
  }
}
