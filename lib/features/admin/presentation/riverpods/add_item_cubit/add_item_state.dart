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
  imageSelected,
  failure,
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
  final File? image;
  final List<ItemModel>? items;
  final String? error;
  AddItemRiverpodState({
    required this.state,
    this.image,
    this.items,
    this.error,
  });

  AddItemRiverpodState copyWith({
    AddItemState? state,
    File? image,
    List<ItemModel>? items,
    String? error,
  }) {
    return AddItemRiverpodState(
      state: state ?? this.state,
      image: image ?? this.image,
      items: items ?? this.items,
      error: error ?? this.error,
    );
  }

  @override
  String toString() {
    return 'AddItemRiverpodState(state: $state, image: $image, items: $items, error: $error)';
  }

  @override
  bool operator ==(covariant AddItemRiverpodState other) {
    if (identical(this, other)) return true;

    return other.state == state &&
        other.image == image &&
        listEquals(other.items, items) &&
        other.error == error;
  }

  @override
  int get hashCode {
    return state.hashCode ^ image.hashCode ^ items.hashCode ^ error.hashCode;
  }
}
