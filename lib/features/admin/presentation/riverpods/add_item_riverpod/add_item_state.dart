// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

import 'package:mktabte/core/erorr/failure.dart';

import '../../../data/model/item_model.dart';

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
  final List<dynamic> items;
  final File? image;
  final List<String> selectedTopics;

  AddItemRiverpodState({
    required this.state,
    required this.items,
    this.error,
    this.image,
    List<String>? selectedTopics,
  }) : selectedTopics = selectedTopics ?? [];

  bool isLoading() => state == AddItemState.loading;
  bool isSuccess() => state == AddItemState.success;
  bool isError() => state == AddItemState.failure;

  AddItemRiverpodState copyWith({
    AddItemState? state,
    String? error,
    List<dynamic>? items,
    File? image,
    List<String>? selectedTopics,
  }) {
    return AddItemRiverpodState(
      state: state ?? this.state,
      error: error ?? this.error,
      items: items ?? this.items,
      image: image ?? this.image,
      selectedTopics: selectedTopics ?? this.selectedTopics,
    );
  }

  @override
  String toString() {
    return 'AddItemRiverpodState(state: $state, error: $error, items: $items, image: $image, selectedTopics: $selectedTopics)';
  }

  @override
  bool operator ==(covariant AddItemRiverpodState other) {
    if (identical(this, other)) return true;

    return other.state == state &&
        other.error == error &&
        listEquals(other.items, items) &&
        other.image == image &&
        listEquals(other.selectedTopics, selectedTopics);
  }

  @override
  int get hashCode {
    return state.hashCode ^
        error.hashCode ^
        items.hashCode ^
        image.hashCode ^
        selectedTopics.hashCode;
  }
}
