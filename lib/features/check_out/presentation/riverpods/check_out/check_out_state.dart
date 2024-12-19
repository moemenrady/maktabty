// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../../../admin/data/model/item_model.dart';
import '../../../model/adress_model.dart';
import '../../../model/cart_items_model.dart';

enum CheckOutStateStatus {
  initial,
  loading,
  success,
  error,
  successAddItemToCart,
  successRemoveItemFromCart,
}

extension CheckOutStateStatusX on CheckOutState {
  bool isInitial() => status == CheckOutStateStatus.initial;
  bool isLoading() => status == CheckOutStateStatus.loading;
  bool isSuccess() => status == CheckOutStateStatus.success;
  bool isError() => status == CheckOutStateStatus.error;
  bool isSuccessAddItemToCart() =>
      status == CheckOutStateStatus.successAddItemToCart;
  bool isSuccessRemoveItemFromCart() =>
      status == CheckOutStateStatus.successRemoveItemFromCart;
}

class CheckOutState {
  final CheckOutStateStatus status;
  final List<CartItemsModel> cartItems;
  final List<AddressModel> address;
  final String errorMessage;
  CheckOutState({
    required this.status,
    required this.cartItems,
    required this.address,
    required this.errorMessage,
  });

  CheckOutState copyWith({
    CheckOutStateStatus? status,
    List<CartItemsModel>? cartItems,
    List<AddressModel>? address,
    String? errorMessage,
  }) {
    return CheckOutState(
      status: status ?? this.status,
      cartItems: cartItems ?? this.cartItems,
      address: address ?? this.address,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  String toString() {
    return 'CheckOutState(status: $status, cartItems: $cartItems, address: $address, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(covariant CheckOutState other) {
    if (identical(this, other)) return true;

    return other.status == status &&
        listEquals(other.cartItems, cartItems) &&
        listEquals(other.address, address) &&
        other.errorMessage == errorMessage;
  }

  @override
  int get hashCode {
    return status.hashCode ^
        cartItems.hashCode ^
        address.hashCode ^
        errorMessage.hashCode;
  }
}
