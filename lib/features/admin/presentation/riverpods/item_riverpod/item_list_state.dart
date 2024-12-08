// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

import '../../../data/model/item_model.dart';

enum ItemListStateStatus {
  initial,
  loading,
  success,
  failure,
}

class ItemListState {
  final ItemListStateStatus status;
  final List<ItemModel> items;
  final String? error;
  final File? image;
  final bool isDeleting;
  final bool isUpdating;

  ItemListState({
    required this.status,
    required this.items,
    this.error,
    this.image,
    this.isDeleting = false,
    this.isUpdating = false,
  });

  factory ItemListState.initial() {
    return ItemListState(
      status: ItemListStateStatus.initial,
      items: [],
    );
  }

  bool isLoading() => status == ItemListStateStatus.loading;
  bool isSuccess() => status == ItemListStateStatus.success;
  bool isError() => status == ItemListStateStatus.failure;

  ItemListState copyWith({
    ItemListStateStatus? status,
    List<ItemModel>? items,
    String? error,
    File? image,
    bool? isDeleting,
    bool? isUpdating,
  }) {
    return ItemListState(
      status: status ?? this.status,
      items: items ?? this.items,
      error: error ?? this.error,
      image: image ?? this.image,
      isDeleting: isDeleting ?? this.isDeleting,
      isUpdating: isUpdating ?? this.isUpdating,
    );
  }

  @override
  String toString() {
    return 'ItemListState(status: $status, items: $items, error: $error, image: $image, isDeleting: $isDeleting, isUpdating: $isUpdating)';
  }

  @override
  bool operator ==(covariant ItemListState other) {
    if (identical(this, other)) return true;

    return other.status == status &&
        listEquals(other.items, items) &&
        other.error == error &&
        other.image == image &&
        other.isDeleting == isDeleting &&
        other.isUpdating == isUpdating;
  }

  @override
  int get hashCode {
    return status.hashCode ^
        items.hashCode ^
        error.hashCode ^
        image.hashCode ^
        isDeleting.hashCode ^
        isUpdating.hashCode;
  }
}
