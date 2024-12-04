import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mktabte/features/admin/presentation/riverpods/add_item_cubit/add_item_state.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/theme/app_pallete.dart';
import '../../../../core/utils/show_snack_bar.dart';
import '../../data/model/item_model.dart';
import '../riverpods/add_item_cubit/add_item_riverpod.dart';
import '../widgets/blog_editor.dart';

class AddNewBlogPage extends ConsumerStatefulWidget {
  const AddNewBlogPage({super.key});

  @override
  ConsumerState<AddNewBlogPage> createState() => _AddNewBlogPageState();
}

class _AddNewBlogPageState extends ConsumerState<AddNewBlogPage> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  List<String> selectedTopics = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    contentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(addItemRiverpodProvider);

    ref.listen(addItemRiverpodProvider, (previous, next) {
      if (next.isError()) {
        showSnackBar(context, next.error ?? "");
      } else if (next.isSuccess()) {
        // Handle success case here
      }
    });

    void uploadBlog() {
      if (formKey.currentState!.validate() &&
          selectedTopics.isNotEmpty &&
          controller.image != null) {
        ref.read(addItemRiverpodProvider.notifier).uploadItem(
              ItemModel(
                id: const Uuid().v1(),
                name: titleController.text.trim(),
                categoryId: 1,
                quantity: 1,
                imageUrl: '',
                createdAt: DateTime.now().toIso8601String(),
              ),
              controller.image!,
            );
      }
    }

    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                uploadBlog();
              },
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
                    key: formKey,
                    child: Column(
                      children: [
                        controller.image != null
                            ? GestureDetector(
                                onTap: () {
                                  ref
                                      .read(addItemRiverpodProvider.notifier)
                                      .selectImage();
                                },
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
                                onTap: () {
                                  ref
                                      .read(addItemRiverpodProvider.notifier)
                                      .selectImage();
                                },
                                child: DottedBorder(
                                  color: AppPallete.borderColor,
                                  dashPattern: const [10, 4],
                                  radius: const Radius.circular(10),
                                  borderType: BorderType.RRect,
                                  strokeCap: StrokeCap.round,
                                  child: const SizedBox(
                                    height: 150,
                                    width: double.infinity,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.folder_open,
                                          size: 40,
                                        ),
                                        SizedBox(height: 15),
                                        Text(
                                          'Select your image',
                                          style: TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                        const SizedBox(height: 20),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: Constants.topics
                                .map(
                                  (e) => Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        if (selectedTopics.contains(e)) {
                                          selectedTopics.remove(e);
                                        } else {
                                          selectedTopics.add(e);
                                        }
                                        setState(() {});
                                      },
                                      child: Chip(
                                        label: Text(e),
                                        color: selectedTopics.contains(e)
                                            ? const WidgetStatePropertyAll(
                                                AppPallete.gradient1,
                                              )
                                            : null,
                                        side: selectedTopics.contains(e)
                                            ? null
                                            : const BorderSide(
                                                color: AppPallete.borderColor,
                                              ),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        BlogEditor(
                          controller: titleController,
                          hintText: 'Blog title',
                        ),
                        const SizedBox(height: 10),
                        BlogEditor(
                          controller: contentController,
                          hintText: 'Blog content',
                        ),
                      ],
                    ),
                  ),
                ),
              ));
  }
}
