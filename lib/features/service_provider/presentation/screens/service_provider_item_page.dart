import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mktabte/core/comman/helpers/gap.dart';
import 'package:mktabte/core/theme/app_pallete.dart';
import 'package:mktabte/core/theme/text_style.dart';
import 'package:mktabte/features/admin/presentation/riverpods/item_riverpod/item_list_state.dart';
import 'package:mktabte/features/admin/presentation/riverpods/item_riverpod/item_riverpod.dart';
import 'package:mktabte/features/admin/presentation/screens/add_items.dart';
import 'package:mktabte/features/admin/presentation/screens/update_item_page.dart';

import '../../../../core/utils/show_dialog.dart';
import '../../../../core/theme/app_text_styles.dart';

class ServiceProviderItemPage extends ConsumerWidget {
  const ServiceProviderItemPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemState = ref.watch(itemListProvider);
    final categories = itemState.categories;

    return DefaultTabController(
      length: categories.length,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppPallete.binkForText,
          child: const Icon(Icons.add, color: Colors.white),
          onPressed: () {
            Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddNewItemPage()))
                .then((value) {
              ref.read(itemListProvider.notifier).fetchItems();
            });
          },
        ),
        appBar: AppBar(
          title: const Text('My Products'),
          backgroundColor: Colors.white,
          elevation: 0,
          bottom: TabBar(
            isScrollable: true,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: AppPallete.binkForText,
            ),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.black,
            tabs: categories
                .map((category) => Tab(
                      text: category.name,
                      icon: const Icon(Icons.category),
                    ))
                .toList(),
          ),
        ),
        body: itemState.isLoading()
            ? const Center(
                child: CircularProgressIndicator(
                color: AppPallete.binkForText,
              ))
            : TabBarView(
                children: categories
                    .map((category) =>
                        _ServiceProviderItemGrid(categoryId: category.id))
                    .toList(),
              ),
      ),
    );
  }
}

class _ServiceProviderItemGrid extends ConsumerStatefulWidget {
  final int categoryId;
  const _ServiceProviderItemGrid({required this.categoryId});

  @override
  ConsumerState<_ServiceProviderItemGrid> createState() =>
      _ServiceProviderItemGridState();
}

class _ServiceProviderItemGridState
    extends ConsumerState<_ServiceProviderItemGrid> {
  @override
  Widget build(BuildContext context) {
    final itemsState = ref.watch(itemListProvider);
    final viewModel = ref.watch(itemListViewModelProvider);

    final filteredItems =
        viewModel.filterItems(itemsState.items, widget.categoryId);

    ref.listen(itemListProvider, (previous, next) {
      if (next.status == ItemListStateStatus.failure) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(next.error ?? 'Error'),
          ),
        );
      }
    });

    return Column(
      children: [
        // Summary Card with stylish design
        Container(
          width: double.infinity,
          margin: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppPallete.binkForText, Color(0xFFFF96AD)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Retail',
                          style: TextStyles.blinker16SemiBoldWhite,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'EGP ${viewModel.calculateTotalRetailPrice(filteredItems).toStringAsFixed(2)}',
                          style: TextStyles.blinker20SemiBoldwhite,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Total Wholesale',
                          style: TextStyles.blinker16SemiBoldWhite,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'EGP ${viewModel.calculateTotalWholesalePrice(filteredItems).toStringAsFixed(2)}',
                          style: TextStyles.blinker20SemiBoldwhite,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.account_balance_wallet,
                        color: Colors.white),
                    SizedBox(width: 8.w),
                    Text(
                      'Profit: EGP ${viewModel.calculateTotalProfit(filteredItems).toStringAsFixed(2)}',
                      style: TextStyles.blinker20SemiBoldwhite.copyWith(
                        fontSize: 22.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Search Bar with modern design
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: TextField(
            controller: viewModel.searchController,
            decoration: InputDecoration(
              hintText: 'Search products...',
              hintStyle: TextStyle(color: Colors.grey.shade400),
              prefixIcon:
                  const Icon(Icons.search, color: AppPallete.binkForText),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear, color: Colors.grey),
                onPressed: () {
                  viewModel.searchController.clear();
                  setState(() {
                    viewModel.updateSearchQuery('');
                  });
                },
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.r),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.r),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.r),
                borderSide: const BorderSide(color: AppPallete.binkForText),
              ),
            ),
            onChanged: (value) {
              setState(() {
                viewModel.updateSearchQuery(value);
              });
            },
          ),
        ),

        SizedBox(height: 16.h),

        // Grid with improved item cards
        Expanded(
          child: itemsState.isLoading()
              ? const Center(
                  child: CircularProgressIndicator(
                  color: AppPallete.binkForText,
                ))
              : filteredItems.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.inventory_2_outlined,
                              size: 80.sp, color: Colors.grey.shade300),
                          SizedBox(height: 16.h),
                          Text(
                            'No products found',
                            style: TextStyles.Blinker16regularlightBlack,
                          ),
                          SizedBox(height: 8.h),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AddNewItemPage(),
                                ),
                              ).then((value) {
                                ref
                                    .read(itemListProvider.notifier)
                                    .fetchItems();
                              });
                            },
                            icon: const Icon(Icons.add),
                            label: const Text('Add Product'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppPallete.binkForText,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.r),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : GridView.builder(
                      padding: EdgeInsets.all(16.w),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.62,
                        crossAxisSpacing: 16.w,
                        mainAxisSpacing: 16.h,
                      ),
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = filteredItems[index];
                        return Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: InkWell(
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      UpdateItemPage(item: item),
                                ),
                              ).then((value) {
                                ref
                                    .read(itemListProvider.notifier)
                                    .fetchItems();
                              });
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(16.r),
                                      ),
                                      child: AspectRatio(
                                        aspectRatio: 1,
                                        child: Image.network(
                                          item.imageUrl,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Container(
                                              color: Colors.grey[200],
                                              child: const Icon(
                                                Icons.image_not_supported,
                                                size: 50,
                                                color: Colors.grey,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),

                                    // Stock indicator
                                    if (item.quantity < 5)
                                      Positioned(
                                        top: 8.w,
                                        right: 8.w,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8.w, vertical: 4.h),
                                          decoration: BoxDecoration(
                                            color: Colors.red.withOpacity(0.8),
                                            borderRadius:
                                                BorderRadius.circular(12.r),
                                          ),
                                          child: Text(
                                            'Low Stock: ${item.quantity}',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.all(12.w),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.name,
                                        style: TextStyles
                                            .Blinker16regularlightBlack,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 4.h),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'EGP ${item.retailPrice.toStringAsFixed(2)}',
                                            style: TextStyles
                                                .Blinker16regularlightOrange,
                                          ),
                                          Text(
                                            'Qty: ${item.quantity}',
                                            style: TextStyle(
                                              color: item.quantity < 5
                                                  ? Colors.red
                                                  : Colors.grey,
                                              fontWeight: item.quantity < 5
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                              fontSize: 12.sp,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8.h),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: OutlinedButton(
                                              onPressed: () async {
                                                await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        UpdateItemPage(
                                                            item: item),
                                                  ),
                                                ).then((value) {
                                                  ref
                                                      .read(itemListProvider
                                                          .notifier)
                                                      .fetchItems();
                                                });
                                              },
                                              style: OutlinedButton.styleFrom(
                                                side: const BorderSide(
                                                    color:
                                                        AppPallete.binkForText),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.r),
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 0),
                                              ),
                                              child: const Text(
                                                'Edit',
                                                style: TextStyle(
                                                    color:
                                                        AppPallete.binkForText),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 8.w),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.red[50],
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                              border: Border.all(
                                                  color: Colors.red[100]!),
                                            ),
                                            child: IconButton(
                                              icon: const Icon(
                                                  Icons.delete_outline,
                                                  color: Colors.red,
                                                  size: 20),
                                              padding: EdgeInsets.zero,
                                              constraints:
                                                  const BoxConstraints(),
                                              onPressed: () =>
                                                  showDeleteConfirmationDialog(
                                                context,
                                                ref,
                                                () => ref
                                                    .read(itemListProvider
                                                        .notifier)
                                                    .deleteItem(
                                                        item.id, item.imageUrl),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
        ),
      ],
    );
  }
}
