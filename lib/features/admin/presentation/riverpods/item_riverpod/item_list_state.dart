// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:io';

import 'package:flutter/foundation.dart';

import '../../../../../core/comman/entitys/categories.dart';
import '../../../data/model/item_model.dart';

enum ItemListStateStatus {
  initial,
  loading,
  success,
  failure,
}

class ItemListState {
  final ItemListStateStatus status;
  final String? error;
  final List<ItemModel> items;
  final List<Categories> categories;
  final bool isDeleting;
  final File? image;

  ItemListState({
    required this.status,
    this.error,
    this.items = const [],
    this.categories = const [],
    this.isDeleting = false,
    this.image,
  });

  factory ItemListState.initial() {
    return ItemListState(status: ItemListStateStatus.initial);
  }

  bool isLoading() => status == ItemListStateStatus.loading;
  bool isSuccess() => status == ItemListStateStatus.success;
  bool isError() => status == ItemListStateStatus.failure;

  ItemListState copyWith({
    ItemListStateStatus? status,
    String? error,
    List<ItemModel>? items,
    List<Categories>? categories,
    bool? isDeleting,
    File? image,
  }) {
    return ItemListState(
      status: status ?? this.status,
      error: error ?? this.error,
      items: items ?? this.items,
      categories: categories ?? this.categories,
      isDeleting: isDeleting ?? this.isDeleting,
      image: image ?? this.image,
    );
  }

  @override
  String toString() {
    return 'ItemListState(status: $status, items: $items, error: $error, image: $image, isDeleting: $isDeleting)';
  }

  @override
  bool operator ==(covariant ItemListState other) {
    if (identical(this, other)) return true;

    return other.status == status &&
        listEquals(other.items, items) &&
        other.error == error &&
        other.image == image &&
        other.isDeleting == isDeleting;
  }

  @override
  int get hashCode {
    return status.hashCode ^
        items.hashCode ^
        error.hashCode ^
        image.hashCode ^
        isDeleting.hashCode;
  }
}
