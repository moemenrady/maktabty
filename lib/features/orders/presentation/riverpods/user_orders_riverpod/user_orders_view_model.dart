import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userOrdersViewModelProvider =
    Provider.autoDispose<UserOrdersViewModel>((ref) {
  final viewModel = UserOrdersViewModel();
  ref.onDispose(() => viewModel.dispose());
  return viewModel;
});

class UserOrdersViewModel {
  final searchController = TextEditingController();

  void dispose() {
    searchController.dispose();
  }
}
