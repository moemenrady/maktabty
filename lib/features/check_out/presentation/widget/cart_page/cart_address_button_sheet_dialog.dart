import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/comman/app_user/app_user_riverpod.dart';
import '../../../model/adress_model.dart';
import '../../riverpods/check_out/check_out_riverpod.dart';
import 'address_bottom_sheet.dart';

void showAddressBottomSheet(
    BuildContext context, CheckOutRiverpod addressController, WidgetRef ref) {
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
            userId: ref
                .read(appUserRiverpodProvider)
                .user!
                .id!, // TODO: get user id from riverpod
            region: region,
            address: address,
          );
          await addressController.addAddress(addressModel);
        },
      ),
    ),
  );
}
