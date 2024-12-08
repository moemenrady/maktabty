import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/show_snack_bar.dart';
import '../riverpods/add_category_riverpod/add_category_riverpod.dart';
import '../widgets/admin_text_field.dart';

class AddNewCategoryPage extends ConsumerWidget {
  const AddNewCategoryPage({super.key});

  void addCategory(WidgetRef ref) {
    final viewModel = ref.read(addCategoryViewModelProvider);
    if (viewModel.formKey.currentState!.validate()) {
      ref
          .read(addCategoryRiverpodProvider.notifier)
          .addCategory(viewModel.nameController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      addCategoryRiverpodProvider,
      (previous, next) {
        if (next.error.isNotEmpty) {
          showSnackBar(context, next.error);
        } else if (next.isSuccess) {
          showSnackBar(context, 'Category added successfully');
        }
      },
    );

    final controller = ref.watch(addCategoryRiverpodProvider);
    final viewModel = ref.watch(addCategoryViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Category'),
        actions: [
          IconButton(
            onPressed: () => addCategory(ref),
            icon: const Icon(Icons.done_rounded),
          ),
        ],
      ),
      body: controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: viewModel.formKey,
                child: Column(
                  children: [
                    AdminTextField(
                      controller: viewModel.nameController,
                      hintText: 'Category Name',
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
