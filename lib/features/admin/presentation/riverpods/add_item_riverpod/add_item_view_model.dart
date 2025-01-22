import 'package:flutter/material.dart';

class AddItemViewModel {
  final TextEditingController titleController;
  final TextEditingController contentController;
  final TextEditingController quantityController;
  final TextEditingController wholesalePriceController;
  final TextEditingController retailPriceController;
  final GlobalKey<FormState> formKey;

  AddItemViewModel()
      : titleController = TextEditingController(),
        contentController = TextEditingController(),
        quantityController = TextEditingController(),
        wholesalePriceController = TextEditingController(),
        retailPriceController = TextEditingController(),
        formKey = GlobalKey<FormState>();

  void dispose() {
    titleController.dispose();
    contentController.dispose();
    quantityController.dispose();
    wholesalePriceController.dispose();
    retailPriceController.dispose();
  }
}
