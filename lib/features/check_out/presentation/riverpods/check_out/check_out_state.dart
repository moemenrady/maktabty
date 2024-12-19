// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../../../admin/data/model/item_model.dart';

enum CheckOutStateStatus {
  initial,
  loading,
  success,
  error,
}

extension CheckOutStateStatusX on CheckOutState {
  bool isInitial() => status == CheckOutStateStatus.initial;
  bool isLoading() => status == CheckOutStateStatus.loading;
  bool isSuccess() => status == CheckOutStateStatus.success;
  bool isError() => status == CheckOutStateStatus.error;
}

class CheckOutState {
  final CheckOutStateStatus status;
  final List<ItemModel> cartItems;
  final String errorMessage;
  CheckOutState({
    required this.status,
    required this.cartItems,
    required this.errorMessage,
  });

  CheckOutState copyWith({
    CheckOutStateStatus? status,
    List<ItemModel>? cartItems,
    String? errorMessage,
  }) {
    return CheckOutState(
      status: status ?? this.status,
      cartItems: cartItems ?? this.cartItems,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  String toString() =>
      'CheckOutState(status: $status, cartItems: $cartItems, errorMessage: $errorMessage)';

  @override
  bool operator ==(covariant CheckOutState other) {
    if (identical(this, other)) return true;

    return other.status == status &&
        listEquals(other.cartItems, cartItems) &&
        other.errorMessage == errorMessage;
  }

  @override
  int get hashCode =>
      status.hashCode ^ cartItems.hashCode ^ errorMessage.hashCode;
}
