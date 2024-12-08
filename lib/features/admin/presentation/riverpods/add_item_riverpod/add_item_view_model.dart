import 'package:flutter/material.dart';

class AddItemViewModel {
  final TextEditingController titleController;
  final TextEditingController contentController;
  final GlobalKey<FormState> formKey;

  AddItemViewModel()
      : titleController = TextEditingController(),
        contentController = TextEditingController(),
        formKey = GlobalKey<FormState>();

  void dispose() {
    titleController.dispose();
    contentController.dispose();
  }
}
