import 'package:flutter/material.dart';
import 'package:mktabte/features/check_out/presentation/widget/cart_page/address_bottom_sheet.dart';

import '../../../model/adress_model.dart';
import '../../riverpods/check_out/check_out_riverpod.dart';

void showAddressBottomSheet(
    BuildContext context, CheckOutRiverpod addressController) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: AddressBottomSheet(
        onAddAddress: (region, address) async {
          final addressModel = AddressModel(
            id: null,
            userId: 1,
            region: region,
            address: address,
          );
          await addressController.addAddress(addressModel);
        },
      ),
    ),
  );
}
