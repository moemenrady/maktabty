import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/repository/admin_repository.dart';
import 'add_category_state.dart';
import 'add_category_view_model.dart';

final addCategoryRiverpodProvider =
    StateNotifierProvider.autoDispose<AddCategoryNotifier, AddCategoryState>(
  (ref) => AddCategoryNotifier(
    ref.watch(adminRepositoryProvider),
  ),
);

class AddCategoryNotifier extends StateNotifier<AddCategoryState> {
  final AdminRepository _adminRepository;

  AddCategoryNotifier(this._adminRepository)
      : super(AddCategoryState.initial());

  void selectImage() async {
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      state = state.copyWith(image: File(pickedImage.path));
    }
  }

  Future<void> addCategory(String name) async {
    if (state.image == null) return;

    state = state.copyWith(isLoading: true);
    final result = await _adminRepository.addCategoryWithImage(
      name: name,
      image: state.image!,
    );

    result.fold(
      (failure) => state = state.copyWith(
        error: failure.message,
        isLoading: false,
      ),
      (category) => state = state.copyWith(
        isSuccess: true,
        isLoading: false,
      ),
    );
  }
}
