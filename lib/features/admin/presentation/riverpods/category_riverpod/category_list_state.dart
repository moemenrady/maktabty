// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/foundation.dart';
import '../../../../../core/comman/entitys/categories.dart';

enum CategoryListStateStatus {
  initial,
  loading,
  success,
  failure,
}

class CategoryListState {
  final CategoryListStateStatus status;
  final List<Categories> categories;
  final String? error;
  final bool isDeleting;
  final bool isUpdating;

  CategoryListState({
    required this.status,
    required this.categories,
    this.error,
    this.isDeleting = false,
    this.isUpdating = false,
  });

  factory CategoryListState.initial() {
    return CategoryListState(
      status: CategoryListStateStatus.initial,
      categories: [],
    );
  }

  bool isLoading() => status == CategoryListStateStatus.loading;
  bool isSuccess() => status == CategoryListStateStatus.success;
  bool isError() => status == CategoryListStateStatus.failure;

  CategoryListState copyWith({
    CategoryListStateStatus? status,
    List<Categories>? categories,
    String? error,
    bool? isDeleting,
    bool? isUpdating,
  }) {
    return CategoryListState(
      status: status ?? this.status,
      categories: categories ?? this.categories,
      error: error ?? this.error,
      isDeleting: isDeleting ?? this.isDeleting,
      isUpdating: isUpdating ?? this.isUpdating,
    );
  }

  @override
  String toString() {
    return 'CategoryListState(status: $status, categories: $categories, error: $error, isDeleting: $isDeleting, isUpdating: $isUpdating)';
  }

  @override
  bool operator ==(covariant CategoryListState other) {
    if (identical(this, other)) return true;

    return other.status == status &&
        listEquals(other.categories, categories) &&
        other.error == error &&
        other.isDeleting == isDeleting &&
        other.isUpdating == isUpdating;
  }

  @override
  int get hashCode {
    return status.hashCode ^
        categories.hashCode ^
        error.hashCode ^
        isDeleting.hashCode ^
        isUpdating.hashCode;
  }

  get length => null;
}
