import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/erorr/failure.dart';
import '../../../../core/utils/try_and_catch.dart';
import '../data_source/check_out_remote_data_source.dart';

final checkOutRepositoryProvider = Provider<CheckOutRepository>((ref) {
  return CheckOutRepository(ref.read(checkOutRemoteDataSourceProvider));
});

class CheckOutRepository {
  final CheckOutRemoteDataSource _checkOutRemoteDataSource;

  CheckOutRepository(this._checkOutRemoteDataSource);

  Future<Either<Failure, void>> addItemToCart(String itemId, int userId) async {
    return executeTryAndCatchForRepository(() async {
      return await _checkOutRemoteDataSource.addItemToCart(itemId, userId);
    });
  }

  Future<Either<Failure, void>> removeItemFromCart(
      String itemId, int userId) async {
    return executeTryAndCatchForRepository(() async {
      return await _checkOutRemoteDataSource.removeItemFromCart(itemId, userId);
    });
  }

  Future<Either<Failure, List<Map<String, dynamic>>>> getCartItems(
      int userId) async {
    return executeTryAndCatchForRepository(() async {
      return await _checkOutRemoteDataSource.getCartItems(userId);
    });
  }
}
