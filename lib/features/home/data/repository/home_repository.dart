import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mktabte/features/home/data/data_source/home_remote_data_source.dart';
import 'package:mktabte/features/home/data/model/categories.dart';

final homeRepositoryProvider = Provider.autoDispose<HomeRepository>((ref) =>
    HomeRepository(remoteDataSource: ref.watch(homeRemoteDataSourceProvider)));

class HomeRepository {
  HomeRemoteDataSource remoteDataSource;
  HomeRepository({required this.remoteDataSource});
  Future<List<Categories>> getProducts() async {
    try {
      final response = await remoteDataSource.getProducts();
      return response
          .map((e) => Categories.fromMap(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }
}
