import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mktabte/features/home/presentation/riverpods/home_river_pod/home_riverpod_state.dart';
import '../../../../core/theme/app_pallete.dart';
import '../../../../core/theme/text_style.dart';
import '../../../admin/data/model/item_model.dart';
import '../riverpods/home_river_pod/home_riverpod.dart';
import '../widgets/home/custome_show_recommend_and_offers.dart';
import '../widgets/home/category_chips.dart';

class HomePpage extends ConsumerWidget {
  const HomePpage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeRiverpodProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: homeState.isLoading()
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // App Bar with Logo and Icons
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/images/home_logo.svg',
                            height: 40.h,
                          ),
                          const Spacer(),
                          IconButton(
                            icon:
                                Icon(Icons.notifications_outlined, size: 24.w),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon:
                                Icon(Icons.shopping_cart_outlined, size: 24.w),
                            onPressed: () {},
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      // Search Bar
                      SearchBar(
                        hintText: 'Search',
                        hintStyle: WidgetStateProperty.all(
                          TextStyle(
                            color: Colors.grey,
                            fontFamily: 'Blinker',
                            fontSize: 14.sp,
                          ),
                        ),
                        leading: Icon(Icons.search, size: 20.w),
                        padding: WidgetStateProperty.all(
                          EdgeInsets.symmetric(horizontal: 16.w),
                        ),
                        elevation: WidgetStateProperty.all(0),
                        backgroundColor: WidgetStateProperty.all(
                          Colors.grey[100],
                        ),
                      ),
                      SizedBox(height: 16.h),
                      // Offers Carousel
                      CustomeShowRecommendAndOffers(
                        items: homeState.recommendedItems,
                      ),
                      SizedBox(height: 16.h),
                      // Category Chips
                      CategoryChips(
                        categories: homeState.categories ?? [],
                        selectedCategory: homeState.selectedCategory,
                        onCategorySelected: (category) {
                          ref
                              .read(homeRiverpodProvider.notifier)
                              .selectCategory(category!);
                        },
                      ),
                      SizedBox(height: 16.h),
                      // Best Seller Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            homeState.selectedCategory?.name ?? 'Best Seller',
                            style: TextStyles.Blinker18semiBoldBlack,
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'See all',
                              style: TextStyle(
                                color: AppPallete.primaryColor,
                                fontFamily: 'Blinker',
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      // Items Grid
                      homeState.isCategoryLoading
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.all(32.0),
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.75,
                                crossAxisSpacing: 16.w,
                                mainAxisSpacing: 16.h,
                              ),
                              itemCount: homeState.selectedCategory != null
                                  ? homeState.categoryItems.length
                                  : homeState.bestSellingItems.length,
                              itemBuilder: (context, index) {
                                final item = homeState.selectedCategory != null
                                    ? homeState.categoryItems[index]
                                    : homeState.bestSellingItems[index];
                                return _buildProductCard(item);
                              },
                            ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildProductCard(ItemModel item) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
              child: Image.network(
                item.imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: TextStyle(
                    fontFamily: 'Blinker',
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Text(
                      '${item.retailPrice} Sales',
                      style: TextStyle(
                        fontFamily: 'Blinker',
                        color: Colors.grey,
                        fontSize: 14.sp,
                      ),
                    ),
                    const Spacer(),
                    Icon(Icons.star, color: Colors.amber, size: 16.w),
                    Text(
                      '4.5',
                      style: TextStyle(
                        fontFamily: 'Blinker',
                        color: Colors.grey[600],
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
