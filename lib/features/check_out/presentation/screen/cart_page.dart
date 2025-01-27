import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mktabte/features/check_out/presentation/riverpods/check_out/check_out_riverpod.dart';
import 'package:mktabte/features/check_out/presentation/riverpods/check_out/check_out_state.dart';
import 'package:mktabte/features/check_out/presentation/screen/check_out_screen.dart';
import 'package:mktabte/features/check_out/presentation/widget/cart_page/custom_cart_button.dart';
import 'package:mktabte/features/home/presentation/widgets/custom_app_bar.dart';
import '../../../../core/theme/text_style.dart';
import '../widget/cart_page/cart_address_button_sheet_dialog.dart';
import '../widget/cart_page/cart_state_listner.dart';
import '../widget/cart_page/custom_cart_card.dart';

class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checkOutController = ref.watch(checkOutRiverpodProvider.notifier);
    final state = ref.watch(checkOutRiverpodProvider);

    ref.listen(checkOutRiverpodProvider, (previous, next) {
      cartStateListner(context, checkOutController, next);
    });

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: state.isLoading()
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomAppBar(
                    txt: "Cart",
                    hasArrow: true,
                    hasIcons: false,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          "Product Order",
                          style: TextStyles.blinker20SemiBoldBlack,
                        ),
                        const Spacer(),
                        Text(
                          "Edit",
                          style: TextStyles.blinker16RegularLightBlue,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  state.cartItems.isNotEmpty
                      ? SizedBox(
                          height: 318.h,
                          width: 343.w,
                          child: ListView.builder(
                            itemCount: state.cartItems.length,
                            itemBuilder: (context, index) {
                              return CustomCartCard(
                                cartItemsModel: state.cartItems[index],
                              );
                            },
                          ))
                      : const SizedBox.shrink(),
                  SizedBox(
                    height: 10.h,
                  ),
                  Divider(color: Color(0xFFCACACA),thickness: 1,),
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    children: [
                      Text(
                        "Shipping adress",
                        style: TextStyles.Inter19semiBoldBlack,
                      ),
                      const Spacer(),
                      IconButton(
                          onPressed: () {
                            showAddressBottomSheet(context, checkOutController);
                          },
                          icon: Image.asset(
                            "assets/images/edit_address_btn_img.png",
                            width: 30.w,
                            height: 30.h,
                          ))
                    ],
                  ),
                  Row(
                    children: [
                      Image.asset("assets/images/location_img.png"),
                      SizedBox(
                        width: 8.w,
                      ),
                      Text(
                        "User location",
                        style: TextStyles.Inter12regularlightBlack,
                      ),
                      const Spacer(),
                      IconButton(
                          onPressed: () {},
                          icon: Image.asset(
                            "assets/images/arrow_right.png",
                            height: 22.h,
                          ))
                    ],
                  ),
                  SizedBox(
                    height: 14.h,
                  ),
                  Divider(color: Color(0xFFCACACA),thickness: 1,),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    "Order Payment Details",
                    style: TextStyles.Montserrat17mediumBlack,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    children: [
                      Text(
                        "Order Amounts",
                        style: TextStyles.Montserrat16regularBlack,
                      ),
                      const Spacer(),
                      Text(
                        "\$ ${state.totalPrice}",
                        style: TextStyles.Montserrat16semiBoldBlack,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    children: [
                      Text(
                        "Delivery Fee",
                        style: TextStyles.Montserrat16regularBlack,
                      ),
                      const Spacer(),
                      Text(
                        "Free",
                        style: TextStyles.Montserrat14semiBoldbinkForText,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 14.h,
                  ),
                  Divider(color: Color(0xFFCACACA),thickness: 1,),
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    children: [
                      Text(
                        "Order Total",
                        style: TextStyles.Montserrat17mediumBlack,
                      ),
                      const Spacer(),
                      Text(
                        "\$ ${state.totalPrice}",
                        style: TextStyles.Montserrat16semiBoldBlack,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 14.h,
                  ),

                  CustomCartButton(
                      onpressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CheckOutScreen(cartItems: state.cartItems)))),
                  // CustomCartButton(
                  //   onpressed: () =>
                  //       _showAddressBottomSheet(context, checkOutController),
                  // ),
                ],
              ),
      ),
    );
  }
}
