import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/erorr/exception.dart';
import '../model/item_model.dart';

final supabaseClientProvider =
    Provider.autoDispose<SupabaseClient>((ref) => Supabase.instance.client);

final adminRemoteDataSourceProvider =
    Provider.autoDispose<AdminRemoteDataSource>(
        (ref) => AdminRemoteDataSourceImpl(ref.watch(supabaseClientProvider)));

abstract interface class AdminRemoteDataSource {
  Future<ItemModel> uploadItem(ItemModel item);
  Future<String> uploadItemImage({
    required File image,
    required ItemModel item,
  });
  Future<List<ItemModel>> getAllItems();
}

class AdminRemoteDataSourceImpl implements AdminRemoteDataSource {
  final SupabaseClient supabaseClient;
  AdminRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<ItemModel> uploadItem(ItemModel item) async {
    try {
      final itemData =
          await supabaseClient.from('items').insert(item.toMap()).select();

      return ItemModel.fromMap(itemData.first);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> uploadItemImage({
    required File image,
    required ItemModel item,
  }) async {
    try {
      await supabaseClient.storage.from('item_images').upload(
            item.id.toString(),
            image,
          );

      return supabaseClient.storage.from('item_images').getPublicUrl(
            item.id.toString(),
          );
    } on StorageException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<ItemModel>> getAllItems() async {
    try {
      final items = await supabaseClient.from('items').select('*');
      return items
          .map(
            (item) => ItemModel.fromMap(item),
          )
          .toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
