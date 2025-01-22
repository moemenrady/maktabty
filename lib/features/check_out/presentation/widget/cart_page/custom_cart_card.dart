import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    return SizedBox(
      height: 72.h,
      width: 343.w,
      child: Row(
        children: [
          Container(
            height: 72.h,
            width: 72.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.r),
              image: DecorationImage(
                  image: NetworkImage(cartItemsModel.itemImage),
                  fit: BoxFit.fill),
            ),
          ),
          SizedBox(width: 16.w),
          Padding(
            padding: EdgeInsets.all(10.h),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 133.w, maxHeight: 42.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cartItemsModel.itemName,
                    style: TextStyles.blinker20SemiBoldBlack,
                    overflow: TextOverflow.fade,
                  ),
                  Text(
                    "Product Description",
                    style: TextStyles.blinker14RegularDarkGrey,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          _buildOutlinedButton("assets/images/arrow_down.png", () {
            checkOutRiverpod.removeOneItemFromCart(
                "8aad2a80-b210-11ef-a14c-af15a5030040", 1);
          }),
          _buildQtyColumn("${cartItemsModel.itemCount}"),
          _buildOutlinedButton("assets/images/arrow_up.png", () {
            checkOutRiverpod.addItemToCart(
                "8aad2a80-b210-11ef-a14c-af15a5030040", 1);
          }),
          _buildPriceColumn("\$${cartItemsModel.totalPricePerItem}"),
          Padding(
            padding: EdgeInsets.only(bottom: 40.h),
            child: _buildOutlinedButton("assets/images/delete.png", () {
              checkOutRiverpod.removeItemFromCart(
                  "8aad2a80-b210-11ef-a14c-af15a5030040", 1);
            }),
          ),
        ],
      ),
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
        Text(content, style: TextStyles.blinker20SemiBoldLightBlack),
        Text("Qty", style: TextStyles.blinker14RegularDarkGrey),
      ],
    );
  }

  Column _buildPriceColumn(String content) {
    return Column(
      children: [
        Text(content, style: TextStyles.blinker20SemiBoldLightBlack),
        Text("Price", style: TextStyles.blinker14RegularDarkGrey),
      ],
    );
  }
}
