import 'package:flutter/material.dart';

class CategoryListViewModel {
  final TextEditingController nameController;

  CategoryListViewModel() : nameController = TextEditingController();

  void dispose() {
    nameController.dispose();
  }
}
