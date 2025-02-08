import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/comman/entitys/categories.dart';
import '../../../../core/utils/show_snack_bar.dart';
import '../../data/model/item_model.dart';
import '../riverpods/add_item_riverpod/add_item_riverpod.dart';
import '../riverpods/add_item_riverpod/add_item_state.dart';
import '../widgets/admin_text_field.dart';

class AddNewItemPage extends ConsumerWidget {
  const AddNewItemPage({super.key});

  void uploadItem(WidgetRef ref) {
    final viewModel = ref.read(addItemViewModelProvider);
    final controller = ref.read(addItemRiverpodProvider);

    if (viewModel.formKey.currentState!.validate()) {
      ref.read(addItemRiverpodProvider.notifier).uploadItem(
            ItemModel(
              id: const Uuid().v1(),
              name: viewModel.titleController.text.trim(),
              quantity:
                  int.tryParse(viewModel.quantityController.text.trim()) ?? 1,
              wholesalePrice: double.tryParse(
                      viewModel.wholesalePriceController.text.trim()) ??
                  0.0,
              retailPrice: double.tryParse(
                      viewModel.retailPriceController.text.trim()) ??
                  0.0,
              imageUrl:
                  'https://gwzvpnetxlpqpjsemttw.supabase.co/storage/v1/object/public/item_images//slider3.jpg',
              createdAt: DateTime.now().toIso8601String(),
              description: viewModel.contentController.text.trim(),
            ),
            controller.image,
          );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(addItemRiverpodProvider, (previous, next) {
      if (next.isError()) {
        showSnackBar(context, next.error ?? "");
      } else if (next.isSuccess()) {
        showSnackBar(context, 'Item added successfully');
        Navigator.pop(context);
      }
    });

    final controller = ref.watch(addItemRiverpodProvider);
    final viewModel = ref.watch(addItemViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => uploadItem(ref),
            icon: const Icon(Icons.done_rounded),
          ),
        ],
      ),
      body: controller.isLoading()
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Form(
                  key: viewModel.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildImagePicker(ref, controller),
                      SizedBox(height: 20.h),
                      _buildCategoryDropdown(ref, controller),
                      SizedBox(height: 16.h),
                      AdminTextField(
                        controller: viewModel.titleController,
                        hintText: 'Item title',
                      ),
                      SizedBox(height: 16.h),
                      AdminTextField(
                        controller: viewModel.quantityController,
                        hintText: 'Quantity',
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 16.h),
                      AdminTextField(
                        controller: viewModel.wholesalePriceController,
                        hintText: 'Wholesale Price',
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 16.h),
                      AdminTextField(
                        controller: viewModel.retailPriceController,
                        hintText: 'Retail Price',
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 16.h),
                      AdminTextField(
                        controller: viewModel.contentController,
                        hintText: 'Item description',
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildImagePicker(WidgetRef ref, dynamic controller) {
    return controller.image != null
        ? GestureDetector(
            onTap: () =>
                ref.read(addItemRiverpodProvider.notifier).selectImage(),
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
                ref.read(addItemRiverpodProvider.notifier).selectImage(),
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
                      'Select your image',
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  Widget _buildCategoryDropdown(
      WidgetRef ref, AddItemRiverpodState controller) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Categories>(
          isExpanded: true,
          hint: const Text('Select Category'),
          value: controller.selectedCategory,
          items: controller.categories.map((category) {
            return DropdownMenuItem(
              value: category,
              child: Text(category.name),
            );
          }).toList(),
          onChanged: (category) {
            if (category != null) {
              ref
                  .read(addItemRiverpodProvider.notifier)
                  .setSelectedCategory(category);
            }
          },
        ),
      ),
    );
  }
}
