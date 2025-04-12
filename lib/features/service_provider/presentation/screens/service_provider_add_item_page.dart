import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/comman/entitys/categories.dart';
import '../../../../core/theme/app_pallete.dart';
import '../../../../core/theme/text_style.dart';
import '../../../../core/utils/show_snack_bar.dart';
import '../../../admin/data/model/item_model.dart';
import '../riverpods/service_provider_item_riverpod.dart';
import '../riverpods/service_provider_item_state.dart';
import '../widgets/service_provider_text_field.dart';

class ServiceProviderAddItemPage extends ConsumerStatefulWidget {
  const ServiceProviderAddItemPage({super.key});

  @override
  ConsumerState<ServiceProviderAddItemPage> createState() =>
      _ServiceProviderAddItemPageState();
}

class _ServiceProviderAddItemPageState
    extends ConsumerState<ServiceProviderAddItemPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _quantityController = TextEditingController();
  final _wholesalePriceController = TextEditingController();
  final _retailPriceController = TextEditingController();
  final _descriptionController = TextEditingController();

  File? _selectedImage;
  Categories? _selectedCategory;

  @override
  void dispose() {
    _titleController.dispose();
    _quantityController.dispose();
    _wholesalePriceController.dispose();
    _retailPriceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final image =
        await ref.read(serviceProviderItemProvider.notifier).pickImage();
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  void _uploadItem() {
    if (_formKey.currentState!.validate()) {
      if (_selectedCategory == null) {
        showSnackBar(context, 'Please select a category');
        return;
      }

      ref.read(serviceProviderItemProvider.notifier).uploadItem(
            ItemModel(
              id: const Uuid().v1(),
              name: _titleController.text.trim(),
              quantity: int.tryParse(_quantityController.text.trim()) ?? 1,
              wholesalePrice:
                  double.tryParse(_wholesalePriceController.text.trim()) ?? 0.0,
              retailPrice:
                  double.tryParse(_retailPriceController.text.trim()) ?? 0.0,
              imageUrl: '',
              categoryId: _selectedCategory!.id,
              createdAt: DateTime.now().toIso8601String(),
              description: _descriptionController.text.trim(),
            ),
            _selectedImage,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(serviceProviderItemProvider, (previous, next) {
      if (next.status == ServiceProviderItemStateStatus.success) {
        showSnackBar(context, 'Product added successfully');
        Navigator.pop(context);
      } else if (next.status == ServiceProviderItemStateStatus.failure) {
        showSnackBar(context, next.error ?? "An error occurred");
      }
    });

    final controller = ref.watch(serviceProviderItemProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Product'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _uploadItem,
            icon: const Icon(Icons.check_circle, color: AppPallete.binkForText),
          ),
        ],
      ),
      body: controller.status == ServiceProviderItemStateStatus.loading
          ? const Center(
              child: CircularProgressIndicator(color: AppPallete.binkForText))
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(20.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image Picker
                      Center(
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: _selectedImage != null
                              ? Container(
                                  width: double.infinity,
                                  height: 200.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16.r),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 10,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                    image: DecorationImage(
                                      image: FileImage(_selectedImage!),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              : DottedBorder(
                                  color:
                                      AppPallete.binkForText.withOpacity(0.5),
                                  strokeWidth: 2,
                                  borderType: BorderType.RRect,
                                  radius: Radius.circular(16.r),
                                  dashPattern: const [8, 4],
                                  child: Container(
                                    width: double.infinity,
                                    height: 200.h,
                                    decoration: BoxDecoration(
                                      color: AppPallete.binkForText
                                          .withOpacity(0.05),
                                      borderRadius: BorderRadius.circular(16.r),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add_photo_alternate,
                                          size: 50.sp,
                                          color: AppPallete.binkForText
                                              .withOpacity(0.7),
                                        ),
                                        SizedBox(height: 12.h),
                                        Text(
                                          'Add Product Image',
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            color: AppPallete.binkForText,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(height: 4.h),
                                        Text(
                                          'Tap to upload from gallery',
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(height: 24.h),

                      // Category Selection
                      Text(
                        'Select Category',
                        style: TextStyles.Blinker16regularlightBlack.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<Categories>(
                            isExpanded: true,
                            icon: const Icon(Icons.arrow_drop_down,
                                color: AppPallete.binkForText),
                            hint: Text(
                              'Select Product Category',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 14.sp,
                              ),
                            ),
                            value: _selectedCategory,
                            items: controller.categories.map((category) {
                              return DropdownMenuItem(
                                value: category,
                                child: Text(
                                  category.name,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.black87,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (category) {
                              if (category != null) {
                                setState(() {
                                  _selectedCategory = category;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),

                      // Form Fields
                      ServiceProviderTextField(
                        controller: _titleController,
                        labelText: 'Product Name',
                        hintText: 'Enter product name',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a product name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.h),
                      ServiceProviderTextField(
                        controller: _quantityController,
                        labelText: 'Quantity',
                        hintText: 'Enter available quantity',
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter quantity';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.h),
                      ServiceProviderTextField(
                        controller: _wholesalePriceController,
                        labelText: 'Wholesale Price (EGP)',
                        hintText: 'Enter wholesale price',
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter wholesale price';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid price';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.h),
                      ServiceProviderTextField(
                        controller: _retailPriceController,
                        labelText: 'Retail Price (EGP)',
                        hintText: 'Enter retail price',
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter retail price';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid price';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.h),
                      ServiceProviderTextField(
                        controller: _descriptionController,
                        labelText: 'Description',
                        hintText: 'Enter product description',
                        maxLines: 4,
                      ),
                      SizedBox(height: 32.h),

                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _uploadItem,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppPallete.binkForText,
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: Text(
                            'Add Product',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
