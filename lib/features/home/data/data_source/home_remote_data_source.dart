import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mktabte/core/utils/try_and_catch.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabaseClientProvider =
    Provider.autoDispose<SupabaseClient>((ref) => Supabase.instance.client);

final homeRemoteDataSourceProvider = Provider.autoDispose<HomeRemoteDataSource>(
    (ref) =>
        HomeRemoteDataSourceImpl(client: ref.watch(supabaseClientProvider)));

abstract interface class HomeRemoteDataSource {
  Future<List<Map<String, dynamic>>> getAllItems();
  Future<List<Map<String, dynamic>>> getAllCategories();
}

class HomeRemoteDataSourceImpl extends HomeRemoteDataSource {
  final SupabaseClient client;
  HomeRemoteDataSourceImpl({required this.client});

  @override
  Future<List<Map<String, dynamic>>> getAllCategories() async {
    return executeTryAndCatchForDataLayer(() async {
      final categories = await client.from('categories').select('*');
      return List<Map<String, dynamic>>.from(categories);
    });
  }

  @override
  Future<List<Map<String, dynamic>>> getAllItems() async {
    return executeTryAndCatchForDataLayer(() async {
      final items = await client.from('items').select('*');
      return List<Map<String, dynamic>>.from(items);
    });
  }
}
