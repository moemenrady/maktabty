// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:io';

import 'package:flutter/foundation.dart';

import '../../../../../core/comman/entitys/categories.dart';

enum AddItemState {
  initial,
  loading,
  success,
  failure,
  imageSelected,
}

extension AddItemStateX on AddItemRiverpodState {
  bool isInitial() => state == AddItemState.initial;
  bool isLoading() => state == AddItemState.loading;
  bool isSuccess() => state == AddItemState.success;
  bool isImageSelected() => state == AddItemState.imageSelected;
  bool isError() => state == AddItemState.failure;
}

class AddItemRiverpodState {
  final AddItemState state;
  final String? error;
  final List<Categories> categories;
  final Categories? selectedCategory;
  final File? image;
  final List<dynamic> items;

  AddItemRiverpodState({
    required this.state,
    this.error,
    this.categories = const [],
    this.selectedCategory,
    this.image,
    required this.items,
  });

  bool isLoading() => state == AddItemState.loading;
  bool isSuccess() => state == AddItemState.success;
  bool isError() => state == AddItemState.failure;

  AddItemRiverpodState copyWith({
    AddItemState? state,
    String? error,
    List<Categories>? categories,
    Categories? selectedCategory,
    File? image,
    List<dynamic>? items,
  }) {
    return AddItemRiverpodState(
      state: state ?? this.state,
      error: error ?? this.error,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      image: image ?? this.image,
      items: items ?? this.items,
    );
  }

  @override
  String toString() {
    return 'AddItemRiverpodState(state: $state, error: $error, categories: $categories, selectedCategory: $selectedCategory, image: $image, items: $items)';
  }

  @override
  bool operator ==(covariant AddItemRiverpodState other) {
    if (identical(this, other)) return true;

    return other.state == state &&
        other.error == error &&
        listEquals(other.categories, categories) &&
        other.selectedCategory == selectedCategory &&
        other.image == image &&
        listEquals(other.items, items);
  }

  @override
  int get hashCode {
    return state.hashCode ^
        error.hashCode ^
        categories.hashCode ^
        selectedCategory.hashCode ^
        image.hashCode ^
        items.hashCode;
  }
}
