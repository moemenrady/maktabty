import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/comman/app_user/app_user_riverpod.dart';
import '../../../../../core/utils/show_snack_bar.dart';
import '../../riverpods/check_out/check_out_riverpod.dart';
import '../../riverpods/check_out/check_out_state.dart';

void cartStateListner(BuildContext context, CheckOutRiverpod controller,
    CheckOutState state, WidgetRef ref) {
  if (state.isError()) {
    showSnackBar(context, state.errorMessage);
  } else if (state.isSuccessAddItemToCart()) {
    showSnackBar(context, "Item Added To Cart Successfully");
  } else if (state.isSuccessRemoveItemFromCart()) {
    showSnackBar(context, "Item Removed From Cart Successfully");
  } else if (state.isSuccessAddAddress()) {
    showSnackBar(context, "Address Added Successfully");
  } else if (state.isSuccessUpdateAddress()) {
    Navigator.pop(context);
    Navigator.pop(context);
    showSnackBar(context, "Address Updated Successfully");
  }
}
