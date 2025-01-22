import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/model/item_model.dart';

class UpdateItemViewModel {
  final TextEditingController nameController;
  final TextEditingController quantityController;
  final TextEditingController categoryIdController;
  final TextEditingController wholesalePriceController;
  final TextEditingController retailPriceController;
  String imageUrl;

  UpdateItemViewModel(ItemModel item)
      : nameController = TextEditingController(text: item.name),
        quantityController =
            TextEditingController(text: item.quantity.toString()),
        categoryIdController =
            TextEditingController(text: item.categoryId.toString()),
        wholesalePriceController =
            TextEditingController(text: item.wholesalePrice.toString()),
        retailPriceController =
            TextEditingController(text: item.retailPrice.toString()),
        imageUrl = item.imageUrl;

  void updateImageUrl(String url) {
    imageUrl = url;
  }

  void dispose() {
    nameController.dispose();
    quantityController.dispose();
    categoryIdController.dispose();
    wholesalePriceController.dispose();
    retailPriceController.dispose();
  }
}

final updateItemViewModelProvider =
    Provider.autoDispose.family<UpdateItemViewModel, ItemModel>(
  (ref, item) {
    final viewModel = UpdateItemViewModel(item);
    ref.onDispose(() => viewModel.dispose());
    return viewModel;
  },
);
