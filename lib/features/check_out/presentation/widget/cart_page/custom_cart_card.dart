import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/comman/app_user/app_user_riverpod.dart';
import '../../../../../core/theme/text_style.dart';
import '../../../model/cart_items_model.dart';
import '../../riverpods/check_out/check_out_riverpod.dart';

class CustomCartCard extends ConsumerWidget {
  final CartItemsModel cartItemsModel;
  const CustomCartCard({
    super.key,
    required this.cartItemsModel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checkOutRiverpod = ref.read(checkOutRiverpodProvider.notifier);
    return Column(
      children: [
        SizedBox(
          height: 72.h,
          width: double.infinity.w,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Container(
                  height: 70.h,
                  width: 70.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24.r),
                    image: DecorationImage(
                        image: NetworkImage(cartItemsModel.itemImage),
                        fit: BoxFit.fill),
                  ),
                ),
                SizedBox(width: 5.w),
                Padding(
                  padding: EdgeInsets.all(5.h),
                  child: SizedBox(
                    width: 130.w,
                    //constraints: BoxConstraints(maxWidth: 120.w, maxHeight: 55.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cartItemsModel.itemName,
                          style: TextStyles.blinker20SemiBoldBlack,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                        ),
                        Text(
                          cartItemsModel.categoryName,
                          style: TextStyles.blinker14RegularDarkGrey,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                        ),
                      ],
                    ),
                  ),
                ),
                _buildOutlinedButton("assets/images/arrow_down.png", () {
                  checkOutRiverpod.removeOneItemFromCart(cartItemsModel.itemId,
                      ref.read(appUserRiverpodProvider).user!.id!);
                }),
                _buildQtyColumn("${cartItemsModel.itemCount}"),
                _buildOutlinedButton("assets/images/arrow_up.png", () {
                  checkOutRiverpod.addItemToCart(cartItemsModel.itemId,
                      ref.read(appUserRiverpodProvider).user!.id!);
                }),
                _buildPriceColumn("${cartItemsModel.totalPricePerItem}"),
                Padding(
                  padding: EdgeInsets.only(bottom: 40.h),
                  child: _buildOutlinedButton("assets/images/delete.png", () {
                    checkOutRiverpod.removeItemFromCart(cartItemsModel.itemId,
                        ref.read(appUserRiverpodProvider).user!.id!);
                  }),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 12.h,
        ),
      ],
    );
  }

  Widget _buildOutlinedButton(String icon, Function() onPressed) {
    return IconButton(
      onPressed: onPressed,
      icon: Image.asset(
        icon,
        width: 19.w,
        height: 19.h,
      ),
    );
  }

  Column _buildQtyColumn(String content) {
    return Column(
      children: [
        Text(
          content,
          style: TextStyles.blinker20SemiBoldLightBlack,
          softWrap: false,
        ),
        Text("Qty", style: TextStyles.blinker14RegularDarkGrey),
      ],
    );
  }

  Column _buildPriceColumn(String content) {
    return Column(
      children: [
        Text(
          content,
          style: TextStyles.blinker20SemiBoldLightBlack,
          softWrap: false,
        ),
        Text("Price", style: TextStyles.blinker14RegularDarkGrey),
      ],
    );
  }
}
