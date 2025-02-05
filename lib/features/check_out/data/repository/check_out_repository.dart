import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/erorr/failure.dart';
import '../../../../core/utils/try_and_catch.dart';
import '../../model/adress_model.dart';
import '../../model/cart_items_model.dart';
import '../data_source/check_out_remote_data_source.dart';
import '../../model/rating_model.dart';

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

  Future<Either<Failure, AddressModel>> addAddress(AddressModel address) async {
    return executeTryAndCatchForRepository(() async {
      final newAddress = await _checkOutRemoteDataSource.addAddress(address);
      return AddressModel.fromMap(newAddress);
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

  Future<Either<Failure, void>> updateAddress(AddressModel address) async {
    return executeTryAndCatchForRepository(() async {
      return await _checkOutRemoteDataSource.updateAddress(address);
    });
  }

  Future<Either<Failure, void>> addRating(RatingModel rating) async {
    return executeTryAndCatchForRepository(() async {
      return await _checkOutRemoteDataSource.addRating(rating);
    });
  }

  Future<Either<Failure, List<RatingModel>>> getRatings(String itemId) async {
    return executeTryAndCatchForRepository(() async {
      final result = await _checkOutRemoteDataSource.getRatings(itemId);
      return result.map((e) => RatingModel.fromMap(e)).toList();
    });
  }

  Future<Either<Failure, void>> updateRating(RatingModel rating) async {
    return executeTryAndCatchForRepository(() async {
      return await _checkOutRemoteDataSource.updateRating(rating);
    });
  }

  Future<Either<Failure, void>> deleteRating(int ratingId) async {
    return executeTryAndCatchForRepository(() async {
      return await _checkOutRemoteDataSource.deleteRating(ratingId);
    });
  }
}
