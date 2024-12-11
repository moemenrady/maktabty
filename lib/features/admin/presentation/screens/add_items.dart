import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/theme/app_pallete.dart';
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

    if (viewModel.formKey.currentState!.validate() &&
        controller.selectedTopics.isNotEmpty &&
        controller.image != null) {
      ref.read(addItemRiverpodProvider.notifier).uploadItem(
            ItemModel(
              id: const Uuid().v1(),
              name: viewModel.titleController.text.trim(),
              categoryId: 1,
              quantity: 1,
              imageUrl: '',
              createdAt: DateTime.now().toIso8601String(),
            ),
            controller.image!,
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
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: viewModel.formKey,
                  child: Column(
                    children: [
                      _buildImagePicker(ref, controller),
                      const SizedBox(height: 20),
                      _buildTopicSelector(ref, controller),
                      const SizedBox(height: 10),
                      AdminTextField(
                        controller: viewModel.titleController,
                        hintText: 'Item title',
                      ),
                      const SizedBox(height: 10),
                      AdminTextField(
                        controller: viewModel.contentController,
                        hintText: 'Item description',
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

  Widget _buildTopicSelector(WidgetRef ref, AddItemRiverpodState controller) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: Constants.topics
            .map(
              (e) => Padding(
                padding: const EdgeInsets.all(5.0),
                child: GestureDetector(
                  onTap: () => ref
                      .read(addItemRiverpodProvider.notifier)
                      .updateSelectedTopics(e),
                  child: Chip(
                    label: Text(e),
                    color: controller.selectedTopics.contains(e)
                        ? const WidgetStatePropertyAll(Colors.amber)
                        : null,
                    side: controller.selectedTopics.contains(e)
                        ? null
                        : const BorderSide(color: Colors.grey),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
