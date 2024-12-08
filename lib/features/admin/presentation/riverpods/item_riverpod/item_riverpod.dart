import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'dart:io';

import '../../../../../core/erorr/failure.dart';
import '../../../../../core/utils/pick_image.dart';
import '../../../data/model/item_model.dart';
import '../../../data/repository/admin_repository.dart';
import 'item_list_state.dart';

final itemListProvider =
    StateNotifierProvider<ItemListController, ItemListState>((ref) {
  final repository = ref.watch(adminRepositoryProvider);
  return ItemListController(repository: repository);
});

class ItemListController extends StateNotifier<ItemListState> {
  final AdminRepository repository;

  ItemListController({required this.repository})
      : super(ItemListState.initial()) {
    fetchItems();
  }

  Future<void> fetchItems() async {
    state = state.copyWith(status: ItemListStateStatus.loading);
    final result = await repository.getAllItems();
    result.fold(
      (failure) => state = state.copyWith(
        status: ItemListStateStatus.failure,
        error: failure.message,
      ),
      (items) => state = state.copyWith(
        status: ItemListStateStatus.success,
        items: items,
      ),
    );
  }

  Future<void> deleteItem(String itemId) async {
    state = state.copyWith(isDeleting: true);
    final result = await repository.deleteItem(itemId);
    result.fold(
      (failure) => state = state.copyWith(
        status: ItemListStateStatus.failure,
        error: failure.message,
      ),
      (_) => fetchItems(),
    );
  }

  Future<void> updateItem(ItemModel updatedItem, {String? oldImageUrl}) async {
    state = state.copyWith(status: ItemListStateStatus.loading);

    // If there's a new image and an old image exists, delete the old one
    if (oldImageUrl != null && oldImageUrl != updatedItem.imageUrl) {
      await repository.deleteItemImage(oldImageUrl);
    }

    final result = await repository.updateItem(updatedItem);
    result.fold(
      (failure) => state = state.copyWith(
        status: ItemListStateStatus.failure,
        error: failure.message,
      ),
      (_) => fetchItems(),
    );
  }

  void catchImage() async {
    final image = await pickImage();
    state = state.copyWith(image: image);
  }

  Future<Either<Failure, String>> uploadItemImage({
    required File image,
    required String itemId,
  }) async {
    return await repository.uploadItemImage(image: image, itemId: itemId);
  }

  Future<void> deleteItemImage(String imageUrl) async {
    final result = await repository.deleteItemImage(imageUrl);
    result.fold(
      (failure) => state = state.copyWith(
        status: ItemListStateStatus.failure,
        error: failure.message,
      ),
      (_) => null,
    );
  }
}
