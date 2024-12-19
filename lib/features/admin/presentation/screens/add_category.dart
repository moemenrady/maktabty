import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/show_snack_bar.dart';
import '../riverpods/add_category_riverpod/add_category_riverpod.dart';
import '../riverpods/add_category_riverpod/add_category_view_model.dart';
import '../widgets/admin_text_field.dart';

class AddNewCategoryPage extends ConsumerWidget {
  const AddNewCategoryPage({super.key});

  void addCategory(WidgetRef ref) {
    final viewModel = ref.read(addCategoryViewModelProvider);
    final controller = ref.read(addCategoryRiverpodProvider);

    if (viewModel.formKey.currentState!.validate() &&
        controller.image != null) {
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
                    _buildImagePicker(ref, controller),
                    const SizedBox(height: 20),
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

  Widget _buildImagePicker(WidgetRef ref, dynamic controller) {
    return controller.image != null
        ? GestureDetector(
            onTap: () =>
                ref.read(addCategoryRiverpodProvider.notifier).selectImage(),
            child: SizedBox(
              width: double.infinity,
              height: 150,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  controller.image!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          )
        : GestureDetector(
            onTap: () =>
                ref.read(addCategoryRiverpodProvider.notifier).selectImage(),
            child: DottedBorder(
              color: Colors.grey,
              dashPattern: const [10, 4],
              radius: const Radius.circular(10),
              borderType: BorderType.RRect,
              strokeCap: StrokeCap.round,
              child: const SizedBox(
                height: 150,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.folder_open, size: 40),
                    SizedBox(height: 15),
                    Text(
                      'Select category image',
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
