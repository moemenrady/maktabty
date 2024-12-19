import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mktabte/core/utils/try_and_catch.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabaseClientProvider =
    Provider<SupabaseClient>((ref) => Supabase.instance.client);

final checkOutRemoteDataSourceProvider =
    Provider<CheckOutRemoteDataSource>((ref) {
  return CheckOutRemoteDataSourceImpl(ref.read(supabaseClientProvider));
});

abstract interface class CheckOutRemoteDataSource {
  Future<void> addItemToCart(String itemId, int userId);
  Future<void> removeItemFromCart(String itemId, int userId);
  Future<List<Map<String, dynamic>>> getCartItems(int userId);
  Future<void> clearCart(int userId);
}

class CheckOutRemoteDataSourceImpl implements CheckOutRemoteDataSource {
  final SupabaseClient supabaseClient;

  CheckOutRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<void> addItemToCart(String itemId, int userId) async {
    return executeTryAndCatchForDataLayer(() async {
      return await supabaseClient
          .from("cart")
          .insert({"item_id": itemId, "user_id": userId});
    });
  }

  @override
  Future<void> removeItemFromCart(String itemId, int userId) async {
    return executeTryAndCatchForDataLayer(() async {
      return await supabaseClient
          .from("cart")
          .delete()
          .eq("item_id", itemId)
          .eq("user_id", userId);
    });
  }

  @override
  Future<void> clearCart(int userId) {
    // TODO: implement clearCart
    throw UnimplementedError();
  }

  @override
  Future<List<Map<String, dynamic>>> getCartItems(int userId) {
    // TODO: implement getCartItems
    throw UnimplementedError();
  }
}
