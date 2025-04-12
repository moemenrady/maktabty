import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/erorr/failure.dart';
import '../../../../core/utils/try_and_catch.dart';
import '../../../../core/comman/entitys/categories.dart';
import '../../../admin/data/model/item_model.dart';

final serviceProviderItemRepositoryProvider =
    Provider<ServiceProviderItemRepository>(
  (ref) => ServiceProviderItemRepositoryImpl(),
);

abstract class ServiceProviderItemRepository {
  Future<Either<Failure, List<ItemModel>>> getServiceProviderItems(int userId);
  Future<Either<Failure, List<Categories>>> getAllCategories();
  Future<Either<Failure, ItemModel>> uploadItem(
      ItemModel itemModel, File? image);
  Future<Either<Failure, void>> deleteItem(String itemId, String imageUrl);
  Future<Either<Failure, ItemModel>> updateItem(ItemModel item);
  Future<Either<Failure, String>> uploadItemImage(
      {required File image, required String itemId});
}

class ServiceProviderItemRepositoryImpl
    implements ServiceProviderItemRepository {
  final supabase = Supabase.instance.client;

  @override
  Future<Either<Failure, List<ItemModel>>> getServiceProviderItems(int userId) {
    return executeTryAndCatchForRepository(() async {
      final items =
          await supabase.from('items').select('*').eq('user_id', userId);
      return List<Map<String, dynamic>>.from(items)
          .map((item) => ItemModel.fromMap(item))
          .toList();
    });
  }

  @override
  Future<Either<Failure, List<Categories>>> getAllCategories() {
    return executeTryAndCatchForRepository(() async {
      final categories = await supabase.from('categories').select('*');
      return List<Map<String, dynamic>>.from(categories)
          .map((category) => Categories.fromMap(category))
          .toList();
    });
  }

  @override
  Future<Either<Failure, ItemModel>> uploadItem(
      ItemModel itemModel, File? image) {
    return executeTryAndCatchForRepository(() async {
      ItemModel updatedItem = itemModel;

      if (image != null) {
        final extension = image.path.split('.').last;
        final imagePath =
            'item_images/${itemModel.id}_${DateTime.now().millisecondsSinceEpoch}.$extension';

        await supabase.storage.from('item_images').upload(imagePath, image);

        final imageUrl =
            supabase.storage.from('item_images').getPublicUrl(imagePath);

        updatedItem = itemModel.copyWith(imageUrl: imageUrl);
      }

      final itemData = await supabase
          .from('items')
          .insert(updatedItem.toMap())
          .select()
          .single();

      return ItemModel.fromMap(itemData);
    });
  }

  @override
  Future<Either<Failure, void>> deleteItem(String itemId, String imageUrl) {
    return executeTryAndCatchForRepository(() async {
      // First try to delete the image if it exists
      if (imageUrl.isNotEmpty) {
        try {
          final uri = Uri.parse(imageUrl);
          final segments = uri.pathSegments;
          final imagePath =
              segments.length > 1 ? segments.sublist(1).join('/') : '';

          if (imagePath.isNotEmpty) {
            await supabase.storage.from('item_images').remove([imagePath]);
          }
        } catch (e) {
          // Continue even if image deletion fails
          print('Failed to delete image: $e');
        }
      }

      // Then delete the item from the database
      await supabase.from('items').delete().eq('id', itemId);
    });
  }

  @override
  Future<Either<Failure, ItemModel>> updateItem(ItemModel item) {
    return executeTryAndCatchForRepository(() async {
      final updatedData = await supabase
          .from('items')
          .update(item.toMap())
          .eq('id', item.id)
          .select()
          .single();

      return ItemModel.fromMap(updatedData);
    });
  }

  @override
  Future<Either<Failure, String>> uploadItemImage({
    required File image,
    required String itemId,
  }) {
    return executeTryAndCatchForRepository(() async {
      final extension = image.path.split('.').last;
      final imagePath =
          'item_images/${itemId}_${DateTime.now().millisecondsSinceEpoch}.$extension';

      await supabase.storage.from('item_images').upload(imagePath, image);

      final imageUrl =
          supabase.storage.from('item_images').getPublicUrl(imagePath);

      return imageUrl;
    });
  }
}
