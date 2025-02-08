import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mktabte/features/home/presentation/widgets/custom_app_bar.dart';
import 'package:tuple/tuple.dart';
import '../../../../core/comman/app_user/app_user_riverpod.dart';
import '../../../../core/comman/helpers/gap.dart';
import '../../../../core/theme/app_pallete.dart';
import '../../../../core/theme/text_style.dart';
import '../controllers/items_search_controller.dart';
import '../riverpods/items_river_pod/items_riverpod.dart';
import '../widgets/category/custom_category_card.dart';
import '../widgets/category/items_search_bar.dart';

class CategoryScreen extends ConsumerStatefulWidget {
  final int categoryId;
  final String categoryName;
  const CategoryScreen(
      {super.key, required this.categoryId, required this.categoryName});

  @override
  ConsumerState<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends ConsumerState<CategoryScreen> {
  late final ItemsSearchController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = ItemsSearchController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildEmptyState(ItemsSearchController searchController) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (searchController.searchQuery.isEmpty) ...[
            if (searchController.relatedItems?.isNotEmpty == true) ...[
              Text(
                'Popular Items',
                style: TextStyles.Blinker20semiBoldBlack,
              ),
              Gap.h16,
              _buildItemChips(searchController.relatedItems!, searchController),
            ],
          ] else ...[
            if (searchController.aiSuggestion != null) ...[
              Text(
                'Did you mean:',
                style: TextStyles.Blinker20semiBoldBlack,
              ),
              Gap.h8,
              GestureDetector(
                onTap: () {
                  searchController
                      .updateSearchQuery(searchController.aiSuggestion!);
                },
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: AppPallete.lightOrange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    searchController.aiSuggestion!,
                    style: TextStyles.Blinker16regularlightBlack.copyWith(
                      color: AppPallete.lightOrange,
                    ),
                  ),
                ),
              ),
            ],
            if (searchController.relatedItems?.isNotEmpty == true) ...[
              Gap.h20,
              Text(
                'Related items in our store:',
                style: TextStyles.Blinker14regular.copyWith(
                  color: AppPallete.lightGrey,
                ),
              ),
              Gap.h8,
              _buildItemChips(searchController.relatedItems!, searchController),
            ],
            if (searchController.aiSuggestion == null &&
                searchController.relatedItems?.isEmpty == true) ...[
              Image.asset(
                'assets/images/no_orders.png',
                height: 200.h,
              ),
              Gap.h20,
              Text(
                'No items found',
                style: TextStyles.Blinker20semiBoldBlack,
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildItemChips(List<String> items, ItemsSearchController controller) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.psychology_outlined,
                    color: AppPallete.lightOrange,
                    size: 20.w,
                  ),
                  Gap.w8,
                  Text(
                    'Did you mean?',
                    style: TextStyles.Blinker16regularlightBlack.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Gap.h12,
              GestureDetector(
                onTap: () {
                  // Don't search immediately, just show the message
                  controller.showSuggestionMessage();
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppPallete.lightOrange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: AppPallete.lightOrange.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          controller.aiSuggestion!,
                          style: TextStyles.Blinker16regularlightBlack.copyWith(
                            color: AppPallete.lightOrange,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: AppPallete.lightOrange,
                        size: 16.w,
                      ),
                    ],
                  ),
                ),
              ),
              if (controller.showingSuggestionMessage) ...[
                Gap.h16,
                Text(
                  'We don\'t have "${controller.aiSuggestion}" yet, but you may like:',
                  style: TextStyles.Blinker14regular.copyWith(
                    color: AppPallete.lightGrey,
                  ),
                ),
                Gap.h12,
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: items
                      .map((item) => GestureDetector(
                            onTap: () {
                              controller.updateSearchQuery(item);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 8.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppPallete.lightOrange.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20.r),
                                border: Border.all(
                                  color:
                                      AppPallete.lightOrange.withOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.search,
                                    color: AppPallete.lightOrange,
                                    size: 16.w,
                                  ),
                                  Gap.w4,
                                  Text(
                                    item,
                                    style: TextStyles.Blinker14regular.copyWith(
                                      color: AppPallete.lightOrange,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final userId = ref.watch(appUserRiverpodProvider).user!.id!;
    final itemsProvider =
        itemsRiverpodProvider(Tuple2(widget.categoryId, userId));
    final state = ref.watch(itemsProvider);

    // Update search controller when items change
    ref.listen(itemsProvider, (previous, next) {
      if (next.items != previous?.items) {
        _searchController.setItems(next.items);
      }
    });

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await ref
              .read(itemsProvider.notifier)
              .getItemsWithFavoritesForCategory(widget.categoryId, userId);
        },
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              CustomAppBar(
                txt: widget.categoryName,
                hasArrow: true,
                hasIcons: true,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ItemsSearchBar(
                  onChanged: _searchController.updateSearchQuery,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListenableBuilder(
                  listenable: _searchController,
                  builder: (context, _) {
                    if (state.isLoading()) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state.isError()) {
                      return Center(
                          child:
                              Text(state.errorMessage ?? 'An error occurred'));
                    }

                    final filteredItems = _searchController.filteredItems;

                    if (filteredItems.isEmpty) {
                      return _buildEmptyState(_searchController);
                    }

                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                "${filteredItems.length} Items",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Spacer(),
                              _buildSortButton(),
                              _buildFilterButton(),
                            ],
                          ),
                        ),
                        Expanded(
                          child: filteredItems.isEmpty
                              ? const Center(child: Text('No items found'))
                              : GridView.builder(
                                  padding: const EdgeInsets.all(10.0),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 8.0,
                                    mainAxisSpacing: 8.0,
                                    childAspectRatio: 0.6,
                                  ),
                                  itemCount: filteredItems.length,
                                  itemBuilder: (context, index) {
                                    final item = filteredItems[index];
                                    return index % 2 == 0
                                        ? FadeInLeft(
                                            child: CustomCategoryCard(
                                            item: item,
                                            index: index,
                                            onAddToFavourite: () {
                                              ref
                                                  .read(itemsProvider.notifier)
                                                  .addToFavorites(
                                                      userId,
                                                      item.id,
                                                      widget.categoryId);
                                            },
                                            onRemoveFromFavourite: () {
                                              ref
                                                  .read(itemsProvider.notifier)
                                                  .removeFromFavorites(
                                                      userId,
                                                      item.id,
                                                      widget.categoryId);
                                            },
                                          ))
                                        : FadeInRight(
                                            child: CustomCategoryCard(
                                            item: item,
                                            index: index,
                                            onAddToFavourite: () {
                                              ref
                                                  .read(itemsProvider.notifier)
                                                  .addToFavorites(
                                                      userId,
                                                      item.id,
                                                      widget.categoryId);
                                            },
                                            onRemoveFromFavourite: () {
                                              ref
                                                  .read(itemsProvider.notifier)
                                                  .removeFromFavorites(
                                                      userId,
                                                      item.id,
                                                      widget.categoryId);
                                            },
                                          ));
                                  },
                                ),
                        ),
                      ],
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

  Widget _buildSortButton() {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Sort By'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text('Name (A-Z)'),
                  onTap: () {
                    _searchController.updateSortOrder('name_asc');
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text('Name (Z-A)'),
                  onTap: () {
                    _searchController.updateSortOrder('name_desc');
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text('Price (Low-High)'),
                  onTap: () {
                    _searchController.updateSortOrder('price_asc');
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text('Price (High-Low)'),
                  onTap: () {
                    _searchController.updateSortOrder('price_desc');
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            const Text(
              "Sort",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(width: 5),
            Image.asset(
              "assets/images/btns/sort_btn_img.png",
              height: 20,
              width: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton() {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            double? tempMinPrice = _searchController.minPrice;
            double? tempMaxPrice = _searchController.maxPrice;
            return AlertDialog(
              title: const Text('Filter by Price'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration:
                        const InputDecoration(labelText: 'Minimum Price'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => tempMinPrice = double.tryParse(value),
                    controller: TextEditingController(
                        text: _searchController.minPrice?.toString() ?? ''),
                  ),
                  TextField(
                    decoration:
                        const InputDecoration(labelText: 'Maximum Price'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => tempMaxPrice = double.tryParse(value),
                    controller: TextEditingController(
                        text: _searchController.maxPrice?.toString() ?? ''),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    _searchController.updatePriceRange(
                        tempMinPrice, tempMaxPrice);
                    Navigator.pop(context);
                  },
                  child: const Text('Apply'),
                ),
              ],
            );
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        margin: const EdgeInsets.only(left: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: const Row(
          children: [
            Text(
              "Filter",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Inter"),
            ),
            SizedBox(width: 5),
            Icon(Icons.filter_alt_outlined, size: 20),
          ],
        ),
      ),
    );
  }
}
