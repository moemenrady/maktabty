import 'package:flutter/material.dart';

class ItemListViewModel {
  final TextEditingController nameController;

  ItemListViewModel() : nameController = TextEditingController();

  void dispose() {
    nameController.dispose();
  }
}
