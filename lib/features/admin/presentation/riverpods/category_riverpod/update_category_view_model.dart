import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/comman/entitys/categories.dart';

class UpdateCategoryViewModel {
  final TextEditingController nameController;

  UpdateCategoryViewModel({required Categories category})
      : nameController = TextEditingController(text: category.name);

  void dispose() {
    nameController.dispose();
  }
}

final updateCategoryViewModelProvider =
    Provider.autoDispose.family<UpdateCategoryViewModel, Categories>(
  (ref, category) {
    final viewModel = UpdateCategoryViewModel(category: category);
    ref.onDispose(() => viewModel.dispose());
    return viewModel;
  },
);
