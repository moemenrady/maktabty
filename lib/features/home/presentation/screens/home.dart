import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mktabte/features/home/presentation/riverpods/home_river_pod/home_riverpod_state.dart';
import '../../../../core/theme/app_pallete.dart';
import '../../../../core/theme/text_style.dart';
import '../../../admin/data/model/item_model.dart';
import '../../../check_out/presentation/screen/cart_page.dart';
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
              ////////////////////
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
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CartPage(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomSearchBar(),
                    ),
                
                    SizedBox(height: 16.h),
                    // Offers Carousel
                    CustomeShowRecommendAndOffers(
                      items: homeState.recommendedItems,
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
                        // : ListView.builder(
                        //   shrinkWrap: true,
                        //   physics: const NeverScrollableScrollPhysics(),
                        //   itemCount: homeState.selectedCategory != null
                        //       ? homeState.categoryItems.length
                        //       : homeState.bestSellingItems.length,
                        //   itemBuilder: (context, index) {
                        //     final item = homeState.selectedCategory != null
                        //         ? homeState.categoryItems[index]
                        //         : homeState.bestSellingItems[index];
                        //     return _buildProductCard(item);
                        //   },),
                
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
                
                    // : GridView.builder(
                    //     shrinkWrap: true,
                    //     physics: const NeverScrollableScrollPhysics(),
                    //     gridDelegate:
                    //         SliverGridDelegateWithFixedCrossAxisCount(
                    //       crossAxisCount: 2,
                    //       childAspectRatio: 0.75,
                    //       crossAxisSpacing: 16.w,
                    //       mainAxisSpacing: 16.h,
                    //     ),
                    //     itemCount: homeState.selectedCategory != null
                    //         ? homeState.categoryItems.length
                    //         : homeState.bestSellingItems.length,
                    //     itemBuilder: (context, index) {
                    //       final item = homeState.selectedCategory != null
                    //           ? homeState.categoryItems[index]
                    //           : homeState.bestSellingItems[index];
                    //       return _buildProductCard(item);
                    //     },
                    //   ),
                  ],
                ),
              ),
      ),
    );
  }

//   Widget _buildProductCard(ItemModel item) {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12.r),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             child: ClipRRect(
//               borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
//               child: Image.network(
//                 item.imageUrl,
//                 fit: BoxFit.cover,
//                 width: double.infinity,
//               ),
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.all(8.w),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   item.name,
//                   style: TextStyle(
//                     fontFamily: 'Blinker',
//                     fontWeight: FontWeight.w600,
//                     fontSize: 16.sp,
//                   ),
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 SizedBox(height: 4.h),
//                 Row(
//                   children: [
  // Text(
  //   '${item.retailPrice} Sales',
  //   style: TextStyle(
  //     fontFamily: 'Blinker',
  //     color: Colors.grey,
  //     fontSize: 14.sp,
  //   ),
  // ),
//                     const Spacer(),
//                     Icon(Icons.star, color: Colors.amber, size: 16.w),
//                     Text(
//                       '4.5',
//                       style: TextStyle(
//                         fontFamily: 'Blinker',
//                         color: Colors.grey[600],
//                         fontSize: 14.sp,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

  Widget _buildProductCard(BuildContext context,ItemModel item) {
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
                  decoration: BoxDecoration(color: Color.fromARGB(103, 255, 255, 255),borderRadius: BorderRadius.circular(20.r)),
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
                        //Image.asset("assets/images/spacer.png"),
                        VerticalDivider(color: Colors.white,thickness: 1,),                                
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
