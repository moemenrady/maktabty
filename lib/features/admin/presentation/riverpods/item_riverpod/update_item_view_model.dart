import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/model/item_model.dart';

class UpdateItemViewModel {
  final TextEditingController nameController;
  final TextEditingController quantityController;
  final TextEditingController categoryIdController;
  String imageUrl;

  UpdateItemViewModel({required ItemModel item})
      : nameController = TextEditingController(text: item.name),
        quantityController =
            TextEditingController(text: item.quantity.toString()),
        categoryIdController =
            TextEditingController(text: item.categoryId.toString()),
        imageUrl = item.imageUrl ?? '';

  void dispose() {
    nameController.dispose();
    quantityController.dispose();
    categoryIdController.dispose();
  }

  void updateImageUrl(String url) {
    imageUrl = url;
  }
}

final updateItemViewModelProvider =
    Provider.autoDispose.family<UpdateItemViewModel, ItemModel>(
  (ref, item) {
    final viewModel = UpdateItemViewModel(item: item);
    ref.onDispose(() => viewModel.dispose());
    return viewModel;
  },
);
