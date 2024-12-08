import 'package:flutter/material.dart';

class AddCategoryViewModel {
  final TextEditingController nameController;
  final GlobalKey<FormState> formKey;

  AddCategoryViewModel()
      : nameController = TextEditingController(),
        formKey = GlobalKey<FormState>();

  void dispose() {
    nameController.dispose();
  }
}
