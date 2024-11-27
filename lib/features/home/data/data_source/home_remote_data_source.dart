import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabaseClientProvider =
    Provider.autoDispose<SupabaseClient>((ref) => Supabase.instance.client);

final homeRemoteDataSourceProvider = Provider.autoDispose<HomeRemoteDataSource>(
    (ref) =>
        HomeRemoteDataSourceImpl(client: ref.watch(supabaseClientProvider)));

abstract interface class HomeRemoteDataSource {
  Future<List<Map>> getProducts();
}

class HomeRemoteDataSourceImpl extends HomeRemoteDataSource {
  final SupabaseClient client;
  HomeRemoteDataSourceImpl({required this.client});
  @override
  Future<List<Map>> getProducts() async {
    try {
      final response = await client.from('categories').select('*').order('id');

      print('Supabase Response: $response');

      return response;
    } catch (e) {
      print('Supabase Error: $e');
      throw Exception(e);
    }
  }
}
