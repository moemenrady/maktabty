import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mktabte/features/check_out/presentation/riverpods/check_out/check_out_riverpod.dart';
import 'package:mktabte/features/check_out/presentation/riverpods/check_out/check_out_state.dart';
import 'package:mktabte/features/check_out/presentation/widget/cart_page/custom_cart_button.dart';

import '../../../../core/theme/text_style.dart';
import '../../../../core/utils/show_snack_bar.dart';
import '../../model/adress_model.dart';
import '../widget/cart_page/custom_cart_app_bar.dart';
import '../widget/cart_page/custom_cart_card.dart';
import '../widget/cart_page/address_bottom_sheet.dart';

class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  void _showAddressBottomSheet(
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checkOutController = ref.watch(checkOutRiverpodProvider.notifier);
    final state = ref.watch(checkOutRiverpodProvider);
    ref.listen(checkOutRiverpodProvider, (previous, next) {
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
    });

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: state.isLoading()
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  const CustomCartAppBar(),
                  Row(
                    children: [
                      Text(
                        "Product Order",
                        style: TextStyles.blinker20SemiBoldBlack,
                      ),
                      Text(
                        "Edit",
                        style: TextStyles.blinker16RegularLightBlue,
                      ),
                    ],
                  ),
                  state.cartItems.isNotEmpty
                      ? SizedBox(
                          height: 248.h,
                          child: ListView.builder(
                            itemCount: 1,
                            itemBuilder: (context, index) {
                              return CustomCartCard(
                                cartItemsModel: state.cartItems[index],
                              );
                            },
                          ))
                      : const SizedBox.shrink(),
                  CustomCartButton(
                    onpressed: () => ref
                        .read(checkOutRiverpodProvider.notifier)
                        .getAddress(1),
                  ),
                  CustomCartButton(
                    onpressed: () =>
                        _showAddressBottomSheet(context, checkOutController),
                  ),
                ],
              ),
      ),
    );
  }
}
