import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/comman/entitys/categories.dart';
import '../../../../../core/utils/pick_image.dart';
import '../../../data/model/item_model.dart';
import '../../../data/repository/admin_repository.dart';
import 'add_item_state.dart';
import 'add_item_view_model.dart';

final addItemViewModelProvider = Provider.autoDispose<AddItemViewModel>((ref) {
  final viewModel = AddItemViewModel();
  ref.onDispose(() => viewModel.dispose());
  return viewModel;
});

final addItemRiverpodProvider =
    StateNotifierProvider.autoDispose<AddItemRiverpod, AddItemRiverpodState>(
  (ref) => AddItemRiverpod(
    repository: ref.watch(adminRepositoryProvider),
  ),
);

class AddItemRiverpod extends StateNotifier<AddItemRiverpodState> {
  final AdminRepository repository;

  AddItemRiverpod({required this.repository})
      : super(AddItemRiverpodState(state: AddItemState.initial, items: [])) {
    getAllCategories();
  }

  Future<void> getAllCategories() async {
    state = state.copyWith(state: AddItemState.loading);
    final result = await repository.getAllCategories();
    result.fold(
      (l) => state = state.copyWith(
        state: AddItemState.failure,
        error: l.message,
      ),
      (categories) => state = state.copyWith(
        state: AddItemState.initial,
        categories: categories,
      ),
    );
  }

  void setSelectedCategory(Categories category) {
    state = state.copyWith(selectedCategory: category);
  }

  Future<void> uploadItem(ItemModel itemModel, File? image) async {
    if (state.selectedCategory == null) {
      state = state.copyWith(
        state: AddItemState.failure,
        error: 'Please select a category',
      );
      return;
    }

    state = state.copyWith(state: AddItemState.loading);

    final updatedItemModel = itemModel.copyWith(
      categoryId: state.selectedCategory!.id,
    );

    final response = await repository.uploadItem(updatedItemModel, image);
    response.fold(
      (l) => state = state.copyWith(
        state: AddItemState.failure,
        error: l.message,
      ),
      (r) => state = state.copyWith(
        state: AddItemState.success,
        items: [r],
      ),
    );
  }

  void selectImage() async {
    state = state.copyWith(state: AddItemState.loading);
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      state = state.copyWith(image: pickedImage);
    }
    state = state.copyWith(state: AddItemState.imageSelected);
  }
}
