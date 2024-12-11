import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/comman/entitys/categories.dart';
import '../riverpods/category_riverpod/category_riverpod.dart';
import '../riverpods/category_riverpod/update_category_view_model.dart';

class UpdateCategoryPage extends ConsumerWidget {
  final Categories category;

  const UpdateCategoryPage({super.key, required this.category});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(updateCategoryViewModelProvider(category));

    return Scaffold(
      appBar: AppBar(title: const Text('Update Category')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: viewModel.nameController,
              decoration: const InputDecoration(labelText: 'Category Name'),
            ),
            ElevatedButton(
              onPressed: () {
                final updatedCategory =
                    category.copyWith(name: viewModel.nameController.text);
                ref
                    .read(categoryListProvider.notifier)
                    .updateCategory(updatedCategory);
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
