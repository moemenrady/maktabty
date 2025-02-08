import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../../../../core/comman/helpers/order_state_enum.dart';
import '../../../../core/erorr/failure.dart';
import '../../../../core/network/connction_checker.dart';
import '../../../orders/data/models/user_order_model.dart';
import '../data_source/admin_remote_data_source.dart';
import '../model/item_model.dart';
import '../../../../core/comman/entitys/categories.dart';
import '../../../../core/utils/try_and_catch.dart';
import '../../../../core/comman/entitys/oders_summary_model.dart';

final adminRepositoryProvider = Provider.autoDispose<AdminRepository>(
  (ref) => AdminRepository(
    adminRemoteDataSource: ref.watch(adminRemoteDataSourceProvider),
  ),
);

final connectionCheckerProvider = Provider.autoDispose<ConnectionChecker>(
    (ref) => ConnectionCheckerImpl(ref.watch(internetConnectionProvider)));

final internetConnectionProvider =
    Provider.autoDispose<InternetConnection>((ref) => InternetConnection());

class AdminRepository {
  final AdminRemoteDataSource adminRemoteDataSource;

  AdminRepository({
    required this.adminRemoteDataSource,
  });

  //TODO:Separate the uploadItemImage and  item upload
  Future<Either<Failure, ItemModel>> uploadItem(
      ItemModel itemModel, File? image) async {
    return executeTryAndCatchForRepository(() async {
      if (image != null) {
        final imageUrl = await adminRemoteDataSource.uploadItemImage(
          image: image,
          itemId: itemModel.id,
        );

        itemModel = itemModel.copyWith(imageUrl: imageUrl);
      }

      final itemData =
          await adminRemoteDataSource.uploadItem(itemModel.toMap());
      return ItemModel.fromMap(itemData);
    });
  }

  Future<Either<Failure, List<ItemModel>>> getAllItems() async {
    return executeTryAndCatchForRepository(() async {
      final items = await adminRemoteDataSource.getAllItems();
      return items.map((item) => ItemModel.fromMap(item)).toList();
    });
  }

  Future<Either<Failure, List<Categories>>> getAllCategories() async {
    return executeTryAndCatchForRepository(() async {
      final categories = await adminRemoteDataSource.getAllCategories();
      return categories
          .map((category) => Categories.fromMap(category))
          .toList();
    });
  }

  Future<Either<Failure, void>> deleteCategory(int categoryId) async {
    return executeTryAndCatchForRepository(() async {
      await adminRemoteDataSource.deleteCategory(categoryId);
    });
  }

  Future<Either<Failure, Categories>> updateCategory(
      Categories category) async {
    return executeTryAndCatchForRepository(() async {
      final updatedData = await adminRemoteDataSource.updateCategory(
        id: category.id,
        name: category.name,
      );
      return Categories.fromMap(updatedData);
    });
  }

  Future<Either<Failure, void>> deleteItem(
      String itemId, String imageUrl) async {
    return executeTryAndCatchForRepository(() async {
      await adminRemoteDataSource.deleteItem(itemId, imageUrl);
    });
  }

  Future<Either<Failure, ItemModel>> updateItem(ItemModel item) async {
    return executeTryAndCatchForRepository(() async {
      final updatedData = await adminRemoteDataSource.updateItem(item.toMap());
      return ItemModel.fromMap(updatedData);
    });
  }

  Future<Either<Failure, void>> deleteItemImage(String imageUrl) async {
    return executeTryAndCatchForRepository(() async {
      await adminRemoteDataSource.deleteItemImage(imageUrl);
    });
  }

  Future<Either<Failure, String>> uploadItemImage({
    required File image,
    required String itemId,
  }) async {
    return executeTryAndCatchForRepository(() async {
      final imageUrl = await adminRemoteDataSource.uploadItemImage(
        image: image,
        itemId: itemId,
      );
      return imageUrl;
    });
  }

  Future<Either<Failure, String>> uploadCategoryImage({
    required File image,
    required int categoryId,
  }) async {
    return executeTryAndCatchForRepository(() async {
      final imageUrl = await adminRemoteDataSource.uploadCategoryImage(
        image: image,
        categoryId: categoryId,
      );
      return imageUrl;
    });
  }

  Future<Either<Failure, Categories>> addCategoryWithImage({
    required String name,
    required File image,
  }) async {
    return executeTryAndCatchForRepository(() async {
      // First upload the image
      final imageUrl = await adminRemoteDataSource.uploadCategoryImage(
        image: image,
        categoryId: DateTime.now().millisecondsSinceEpoch, // temporary ID
      );

      // Then create the category with the image URL
      final categoryData =
          await adminRemoteDataSource.addCategory(name, imageUrl);
      return Categories.fromMap(categoryData);
    });
  }

  Future<Either<Failure, List<OrderSummaryModel>>>
      fetchOrderSummaryByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    return executeTryAndCatchForRepository(() async {
      final result = await adminRemoteDataSource.fetchOrderSummaryByDateRange(
          startDate: startDate, endDate: endDate);
      final data = result.map((e) => OrderSummaryModel.fromMap(e)).toList();
      return data;
    });
  }

  Future<Either<Failure, List<UserOrderModel>>>
      fetchOrderSummaryForUser() async {
    return executeTryAndCatchForRepository(() async {
      final result = await adminRemoteDataSource.fetchOrderSummaryForUser();
      final data = result.map((e) => UserOrderModel.fromMap(e)).toList();
      return data;
    });
  }

  Future<Either<Failure, void>> updateOrderState(
      String orderId, OrderState newState) async {
    return executeTryAndCatchForRepository(() async {
      await adminRemoteDataSource.updateOrderState(orderId, newState);
    });
  }

  Future<Either<Failure, void>> updateItemQuantities(
      List<Map<String, dynamic>> itemUpdates) async {
    return executeTryAndCatchForRepository(() async {
      await adminRemoteDataSource.updateItemQuantities(itemUpdates);
    });
  }
}
