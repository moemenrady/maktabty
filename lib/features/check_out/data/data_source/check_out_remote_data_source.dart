import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mktabte/core/utils/try_and_catch.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../model/adress_model.dart';

final supabaseClientProvider =
    Provider<SupabaseClient>((ref) => Supabase.instance.client);

final checkOutRemoteDataSourceProvider =
    Provider<CheckOutRemoteDataSource>((ref) {
  return CheckOutRemoteDataSourceImpl(ref.read(supabaseClientProvider));
});

abstract interface class CheckOutRemoteDataSource {
  Future<void> addItemToCart(String itemId, int userId);
  Future<void> removeItemFromCart(String itemId, int userId);
  Future<void> removeOneItemFromCart(String itemId, int userId);
  Future<List<Map<String, dynamic>>> getCartItems(int userId);
  Future<void> clearCart(int userId);
  Future<Map<String, dynamic>> addAddress(AddressModel address);
  Future<List<Map<String, dynamic>>> getAddress(int userId);
  Future<void> checkOut(int userId, List<Map<String, dynamic>> orderItems,
      int addressId, String transactionType);
  Future<void> updateAddress(AddressModel address);
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
  Future<void> removeOneItemFromCart(String itemId, int userId) async {
    return executeTryAndCatchForDataLayer(() async {
      // Get the first occurrence of the item in cart
      final itemToDelete = await supabaseClient
          .from("cart")
          .select()
          .eq("item_id", itemId)
          .eq("user_id", userId)
          .limit(1)
          .single();

      // Delete that specific item using its primary key
      await supabaseClient.from("cart").delete().eq("id", itemToDelete['id']);

      return;
    });
  }

  @override
  Future<void> clearCart(int userId) {
    // TODO: implement clearCart
    throw UnimplementedError();
  }

  @override
  Future<List<Map<String, dynamic>>> getCartItems(int userId) async {
    return executeTryAndCatchForDataLayer(() async {
      return await supabaseClient
          .from("user_cart")
          .select()
          .eq("user_id", userId);
    });
  }

  @override
  Future<Map<String, dynamic>> addAddress(AddressModel address) async {
    return executeTryAndCatchForDataLayer(() async {
      final now = DateTime.now().toIso8601String();
      final addressData = {
        ...address.toMap(),
        'created_at': now,
        'updated_at': now,
      };

      final response = await supabaseClient
          .from("address")
          .insert(addressData)
          .select()
          .single();
      return response;
    });
  }

  @override
  Future<List<Map<String, dynamic>>> getAddress(int userId) async {
    return executeTryAndCatchForDataLayer(() async {
      return await supabaseClient
          .from("address")
          .select()
          .eq("user_id", userId);
    });
  }

  @override
  Future<void> checkOut(
    int userId,
    List<Map<String, dynamic>> orderItems,
    int addressId,
    String transactionType,
  ) async {
    return executeTryAndCatchForDataLayer(() async {
      print(orderItems);
      return await supabaseClient.rpc('place_orderss', params: {
        'user_id_input': userId,
        'order_items': orderItems,
        'address_id': addressId,
        'transaction_type': transactionType,
      });
    });
  }

  @override
  Future<void> updateAddress(AddressModel address) async {
    return executeTryAndCatchForDataLayer(() async {
      await supabaseClient.from('address').update({
        'address': address.address,
        'region': address.region,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', address.id!);
    });
  }
}
