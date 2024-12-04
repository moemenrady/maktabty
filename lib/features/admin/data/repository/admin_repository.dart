import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/erorr/exception.dart';
import '../../../../core/erorr/failure.dart';
import '../../../../core/network/connction_checker.dart';
import '../data_source/admin_remote_data_source.dart';
import '../model/item_model.dart';

final adminRepositoryProvider = Provider.autoDispose<AdminRepository>(
  (ref) => AdminRepository(
    adminRemoteDataSource: ref.watch(adminRemoteDataSourceProvider),
    connectionChecker: ref.watch(connectionCheckerProvider),
  ),
);

final connectionCheckerProvider = Provider.autoDispose<ConnectionChecker>(
    (ref) => ConnectionCheckerImpl(ref.watch(internetConnectionProvider)));

final internetConnectionProvider =
    Provider.autoDispose<InternetConnection>((ref) => InternetConnection());

class AdminRepository {
  final AdminRemoteDataSource adminRemoteDataSource;
  final ConnectionChecker connectionChecker;
  AdminRepository({
    required this.adminRemoteDataSource,
    required this.connectionChecker,
  });

  Future<Either<Failure, ItemModel>> uploadItem(
      ItemModel itemModel, File image) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(Failure(Constants.noConnectionErrorMessage));
      }
      final imageUrl = await adminRemoteDataSource.uploadItemImage(
        image: image,
        item: itemModel,
      );
      print('Image URL: $imageUrl');

      itemModel = itemModel.copyWith(
        imageUrl: imageUrl,
      );

      final uploadedItem = await adminRemoteDataSource.uploadItem(itemModel);
      print('Uploaded item: $uploadedItem');
      return right(uploadedItem);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  Future<Either<Failure, List<ItemModel>>> getAllItems() async {
    try {
      if (!await (connectionChecker.isConnected)) {
        final items = await adminRemoteDataSource.getAllItems();
        return right(items);
      }
      final items = await adminRemoteDataSource.getAllItems();
      return right(items);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
