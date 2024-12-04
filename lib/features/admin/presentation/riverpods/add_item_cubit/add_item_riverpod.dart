import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mktabte/features/admin/presentation/riverpods/add_item_cubit/add_item_state.dart';

import '../../../../../core/utils/pick_image.dart';
import '../../../data/model/item_model.dart';
import '../../../data/repository/admin_repository.dart';

final addItemRiverpodProvider =
    StateNotifierProvider.autoDispose<AddItemRiverpod, AddItemRiverpodState>(
        (ref) {
  final riverpod =
      AddItemRiverpod(repository: ref.watch(adminRepositoryProvider));
  return riverpod;
});

class AddItemRiverpod extends StateNotifier<AddItemRiverpodState> {
  AdminRepository repository;
  AddItemRiverpod({required this.repository})
      : super(AddItemRiverpodState(state: AddItemState.initial, items: []));

  Future<void> uploadItem(ItemModel itemModel, File image) async {
    state = state.copyWith(state: AddItemState.loading);
    final response = await repository.uploadItem(itemModel, image);
    response.fold(
      (l) {
        state = state.copyWith(state: AddItemState.failure, error: l.message);
        print('Item upload failed: ${l.message}');
      },
      (r) {
        state = state.copyWith(state: AddItemState.success, items: [r]);
        print('Item uploaded successfully');
      },
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
