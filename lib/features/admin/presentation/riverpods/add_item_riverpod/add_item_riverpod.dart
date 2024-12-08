import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      : super(AddItemRiverpodState(state: AddItemState.initial, items: []));

  Future<void> uploadItem(ItemModel itemModel, File image) async {
    state = state.copyWith(state: AddItemState.loading);
    final response = await repository.uploadItem(itemModel, image);
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

  void updateSelectedTopics(String topic) {
    final currentTopics = List<String>.from(state.selectedTopics);
    if (currentTopics.contains(topic)) {
      currentTopics.remove(topic);
    } else {
      currentTopics.add(topic);
    }
    state = state.copyWith(selectedTopics: currentTopics);
  }
}
