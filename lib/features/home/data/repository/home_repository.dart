import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mktabte/features/home/data/data_source/home_remote_data_source.dart';

import '../../../../core/comman/entitys/categories.dart';
import '../../../../core/erorr/failure.dart';
import '../../../../core/utils/try_and_catch.dart';
import '../../../admin/data/model/item_model.dart';

final homeRepositoryProvider = Provider.autoDispose<HomeRepository>((ref) =>
    HomeRepository(remoteDataSource: ref.watch(homeRemoteDataSourceProvider)));

class HomeRepository {
  HomeRemoteDataSource remoteDataSource;
  HomeRepository({required this.remoteDataSource});
  Future<Either<Failure, List<ItemModel>>> getAllItems() async {
    return executeTryAndCatchForRepository(() async {
      final items = await remoteDataSource.getAllItems();
      return items.map((item) => ItemModel.fromMap(item)).toList();
    });
  }

  Future<Either<Failure, List<Categories>>> getAllCategories() async {
    return executeTryAndCatchForRepository(() async {
      final categories = await remoteDataSource.getAllCategories();
      return categories
          .map((category) => Categories.fromMap(category))
          .toList();
    });
  }
}
