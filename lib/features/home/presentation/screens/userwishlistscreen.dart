import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/comman/app_user/app_user_riverpod.dart';
import '../../../../core/theme/text_style.dart';
import '../../../../core/utils/show_snack_bar.dart';
import '../riverpods/wishlist_riverpod/wishlist_riverpod.dart';
import '../widgets/custom_WL_header.dart';
import '../widgets/custom_wishlist_card.dart';

class UserWishlistScreen extends ConsumerWidget {
  const UserWishlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlistState = ref.watch(wishlistProvider);
    final wishlistRiverpod = ref.read(wishlistProvider.notifier);
    ref.listen(wishlistProvider, (previous, next) {
      if (next.isSuccessAddItemToCart()) {
        showSnackBar(context, 'Item added to cart');
      } else if (next.isSuccessRemoveItemFromFavourate()) {
        wishlistRiverpod
            .getUserFavorites(ref.read(appUserRiverpodProvider).user!.id!);
        showSnackBar(context, 'Item removed from wishlist');
      }
    });

    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            const CustomWlHeader(),
            Positioned(
              top: 188.h,
              left: (MediaQuery.of(context).size.width - 327.w) / 2,
              width: 327.w,
              height: 400.h,
              child: wishlistState.isLoading()
                  ? const Center(child: CircularProgressIndicator())
                  : wishlistState.isError()
                      ? Center(
                          child: Text(
                            wishlistState.errorMessage ?? 'An error occurred',
                            style: TextStyles.Blinker16regularlightBlack,
                          ),
                        )
                      : wishlistState.items.isEmpty
                          ? Center(
                              child: Text(
                                'No items in wishlist',
                                style: TextStyles.Blinker16regularlightBlack,
                              ),
                            )
                          : CustomWishlistCard(
                              wishListItems: wishlistState.items),
            ),
          ],
        ),
      ),
    );
  }
}
