import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/erorr/failure.dart';
import '../../../../core/utils/try_and_catch.dart';
import '../../model/adress_model.dart';
import '../../model/cart_items_model.dart';
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

  Future<Either<Failure, void>> removeOneItemFromCart(
      String itemId, int userId) async {
    return executeTryAndCatchForRepository(() async {
      return await _checkOutRemoteDataSource.removeOneItemFromCart(
          itemId, userId);
    });
  }

  Future<Either<Failure, List<CartItemsModel>>> getCartItems(int userId) async {
    return executeTryAndCatchForRepository(() async {
      final result = await _checkOutRemoteDataSource.getCartItems(userId);
      final data = result.map((e) => CartItemsModel.fromMap(e)).toList();
      return data;
    });
  }

  Future<Either<Failure, void>> addAddress(AddressModel address) async {
    return executeTryAndCatchForRepository(() async {
      return await _checkOutRemoteDataSource.addAddress(address);
    });
  }

  Future<Either<Failure, List<AddressModel>>> getAddress(int userId) async {
    return executeTryAndCatchForRepository(() async {
      final result = await _checkOutRemoteDataSource.getAddress(userId);
      final data = result.map((e) => AddressModel.fromMap(e)).toList();
      return data;
    });
  }

  Future<Either<Failure, void>> checkOut(
      int userId,
      List<Map<String, dynamic>> orderItems,
      int addressId,
      String transactionType) async {
    return executeTryAndCatchForRepository(() async {
      return await _checkOutRemoteDataSource.checkOut(
          userId, orderItems, addressId, transactionType);
    });
  }
}
