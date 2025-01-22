import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/show_snack_bar.dart';
import '../../data/model/item_model.dart';
import '../riverpods/item_riverpod/item_riverpod.dart';
import '../riverpods/item_riverpod/update_item_view_model.dart';
import '../../../../core/utils/pick_image.dart';
import '../riverpods/add_item_riverpod/add_item_riverpod.dart';

class UpdateItemPage extends ConsumerWidget {
  final ItemModel item;

  const UpdateItemPage({super.key, required this.item});

  void updateImage(BuildContext context, WidgetRef ref) async {
    final viewModel = ref.read(updateItemViewModelProvider(item));
    final image = await pickImage();

    if (image != null) {
      await ref
          .read(itemListProvider.notifier)
          .deleteItemImage(viewModel.imageUrl);

      final result = await ref.read(itemListProvider.notifier).uploadItemImage(
            image: image,
            itemId: item.id ?? '',
          );

      result.fold(
        (failure) => showSnackBar(context, failure.message),
        (newImageUrl) => viewModel.updateImageUrl(newImageUrl),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(updateItemViewModelProvider(item));
    final categories = ref.watch(addItemRiverpodProvider).categories;

    return Scaffold(
      appBar: AppBar(title: const Text('Update Item')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => updateImage(context, ref),
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage(viewModel.imageUrl),
                    fit: BoxFit.cover,
                    onError: (_, __) => const Icon(Icons.error),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: viewModel.nameController,
              decoration: const InputDecoration(labelText: 'Item Name'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: viewModel.quantityController,
              decoration: const InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              value: item.categoryId,
              decoration: const InputDecoration(labelText: 'Category'),
              items: categories.map((category) {
                return DropdownMenuItem(
                  value: category.id,
                  child: Text(category.name),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  viewModel.categoryIdController.text = value.toString();
                }
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: viewModel.wholesalePriceController,
              decoration: const InputDecoration(labelText: 'Wholesale Price'),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: viewModel.retailPriceController,
              decoration: const InputDecoration(labelText: 'Retail Price'),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                final updatedItem = item.copyWith(
                  name: viewModel.nameController.text,
                  quantity: int.tryParse(viewModel.quantityController.text) ??
                      item.quantity,
                  categoryId:
                      int.tryParse(viewModel.categoryIdController.text) ??
                          item.categoryId,
                  imageUrl: viewModel.imageUrl,
                  wholesalePrice: double.tryParse(
                          viewModel.wholesalePriceController.text) ??
                      item.wholesalePrice,
                  retailPrice:
                      double.tryParse(viewModel.retailPriceController.text) ??
                          item.retailPrice,
                );

                final oldImageUrl =
                    viewModel.imageUrl != item.imageUrl ? item.imageUrl : null;

                ref.read(itemListProvider.notifier).updateItem(
                      updatedItem,
                      oldImageUrl: oldImageUrl,
                    );
                Navigator.pop(context);
              },
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}
