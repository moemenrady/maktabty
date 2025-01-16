import 'package:flutter/material.dart';

import '../../../../../core/utils/show_snack_bar.dart';
import '../../riverpods/check_out/check_out_riverpod.dart';
import '../../riverpods/check_out/check_out_state.dart';

void cartStateListner(BuildContext context, CheckOutRiverpod checkOutController,
    CheckOutState next) {
  if (next.isSuccess() && next.address.isNotEmpty) {
    print('Addresses loaded: ${next.address}');
  } else if (next.isSuccessAddItemToCart() ||
      next.isSuccessRemoveItemFromCart()) {
    checkOutController.getCartItems(1);
    showSnackBar(context,
        "Item ${next.isSuccessAddItemToCart() ? "added" : "removed"} to cart");
  } else if (next.isError()) {
    showSnackBar(context, next.errorMessage);
  }
}
