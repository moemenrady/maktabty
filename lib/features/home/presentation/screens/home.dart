import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mktabte/features/home/presentation/riverpods/home_river_pod/home_riverpod_state.dart';
import '../../../../core/theme/text_style.dart';
import '../../../admin/data/model/item_model.dart';
import '../../../check_out/presentation/screen/product_details_creen.dart';
import '../riverpods/home_river_pod/home_riverpod.dart';
import '../widgets/home/custom_home_advertising.dart';
import '../widgets/home/custom_search_bar.dart';
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Updated App Bar with new logo and text
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 14.h),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12.r),
                            child: Image.asset(
                              'assets/images/app_logo.jpg',
                              height: 40.h,
                              width: 40.w,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "For the best",
                                style:
                                    TextStyles.Blinker18semiBoldBlack.copyWith(
                                  color:
                                      const Color.fromARGB(255, 255, 166, 97),
                                ),
                              ),
                              SizedBox(height: 1.h),
                              Text(
                                "We're here for you,for your best",
                                style: TextStyles.blinker5regularblack,
                              ),
                            ],
                          ),
                          const Spacer(),
                          IconButton(
                            icon: Image.asset(
                              "assets/images/btns/notification_icon.png",
                              width: 20.w,
                              height: 20.h,
                            ),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: Image.asset(
                              "assets/images/btns/cart_icon_black.png",
                              width: 20.w,
                              height: 20.h,
                            ),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: const CustomSearchBar(),
                    ),

                    SizedBox(height: 24.h),

                    const CustomHomeAdvertising(),

                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 5.w, vertical: 6.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.r),
                              boxShadow: [],
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 16.h, horizontal: 20.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(8.w),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Icon(
                                    Icons.auto_awesome,
                                    color: const Color(0xFFF68B3B),
                                    size: 15.h,
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Recommended Items",
                                      style: TextStyles.Blinker24boldBlack
                                          .copyWith(
                                        color: const Color(0xFFF68B3B),
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      "Handpicked just for you",
                                      style: TextStyles.blinker14regularwhite,
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    'See all',
                                    style:
                                        TextStyles.Blinker16regularorangeColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          CustomeShowRecommendAndOffers(
                            items: homeState.searchQuery.isEmpty
                                ? homeState.recommendedItems
                                : homeState.filteredItems,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 6.h),
                    // Category Chips
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CategoryChips(
                        categories: homeState.categories ?? [],
                        selectedCategory: homeState.selectedCategory,
                        onCategorySelected: (category) {
                          ref
                              .read(homeRiverpodProvider.notifier)
                              .selectCategory(category!);
                        },
                      ),
                    ),

                    homeState.isCategoryLoading
                        ? Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                            child: const Center(
                              child: Padding(
                                padding: EdgeInsets.all(32.0),
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: homeState.selectedCategory != null
                                  ? homeState.categoryItems.length
                                  : homeState.bestSellingItems.length,
                              itemBuilder: (context, index) {
                                final item = homeState.selectedCategory != null
                                    ? homeState.categoryItems[index]
                                    : homeState.bestSellingItems[index];
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 8.h, horizontal: 8.w),
                                  child: _buildProductCard(context, item),
                                );
                              },
                            ),
                          ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, ItemModel item) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductDetailsScreen(item: item),
        ),
      ),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.r),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(25.r), top: Radius.circular(25.r)),
              child: Image.network(
                item.imageUrl,
                fit: BoxFit.cover,
                width: double.infinity.w,
                height: 247.h,
              ),
            ),
            Positioned(
                bottom: 30,
                left: 27,
                child: Container(
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(103, 255, 255, 255),
                      borderRadius: BorderRadius.circular(20.r)),
                  width: 307.w,
                  height: 72.h,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          '${item.name} Sales',
                          style: TextStyles.blinker20SemiBoldwhite,
                        ),
                        const VerticalDivider(
                          color: Colors.white,
                          thickness: 1,
                        ),
                        Text(
                          'EGP${item.retailPrice}',
                          style: TextStyles.blinker20SemiBoldwhite,
                        ),
                        Image.asset(
                          "assets/images/btns/selected_cart_btn_img.png",
                          width: 20.w,
                          height: 20.h,
                        ),
                      ],
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
