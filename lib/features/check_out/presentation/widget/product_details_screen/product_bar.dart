import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mktabte/features/check_out/presentation/riverpods/check_out/check_out_state.dart';
import 'package:tuple/tuple.dart';

import '../../../../../core/comman/app_user/app_user_riverpod.dart';
import '../../../../../core/theme/text_style.dart';
import '../../../../../core/utils/show_snack_bar.dart';
import '../../../../admin/data/model/item_model.dart';
import '../../../../home/presentation/riverpods/items_river_pod/items_riverpod.dart';
import '../../riverpods/check_out/check_out_riverpod.dart';
import '../../screen/cart_page.dart';

class ProductBar extends ConsumerWidget {
  final ItemModel item;
  const ProductBar({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void checkGuest() {
      if (ref.read(appUserRiverpodProvider).user?.name == "Guest") {
        showSnackBar(context, "Please login to add to cart");
      } else {
        ref.read(checkOutRiverpodProvider.notifier).addItemToCart(
            item.id, ref.read(appUserRiverpodProvider).user!.id!);
      }
    }

    return Container(
      height: 90.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Consumer(builder: (context, ref, child) {
            final checkOutState = ref.watch(checkOutRiverpodProvider);
            return checkOutState.isLoading()
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
                    child: ElevatedButton(
                    onPressed: () => checkGuest(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF68B3B),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                    child: Text(
                      "Add to cart",
                      style: TextStyles.blinker14Boldwhite,
                    ),
                  ));
          }),
          SizedBox(width: 12.w),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const CartPage()));
              },
              icon: Image.asset(
                "assets/images/Add_Item_Cart.png",
                width: 18.w,
                height: 18.h,
                color: Colors.white,
              ),
              label: Text(
                "Go To Cart",
                style: TextStyles.blinker14Boldwhite,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF68B3B),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 12.h),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: item.isFavourite
                  ? const Color(0xFFF68B3B).withOpacity(0.1)
                  : Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              item.isFavourite ? Icons.favorite : Icons.favorite_border,
              color: item.isFavourite ? const Color(0xFFF68B3B) : Colors.grey,
              size: 24.w,
            ),
          ),
        ],
      ),
    );
  }
}
