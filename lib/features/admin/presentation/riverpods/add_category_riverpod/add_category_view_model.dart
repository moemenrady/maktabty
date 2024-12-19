import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final addCategoryViewModelProvider =
    Provider.autoDispose<AddCategoryViewModel>((ref) {
  final viewModel = AddCategoryViewModel();
  ref.onDispose(() => viewModel.dispose());
  return viewModel;
});

class AddCategoryViewModel {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();

  void dispose() {
    nameController.dispose();
  }
}
