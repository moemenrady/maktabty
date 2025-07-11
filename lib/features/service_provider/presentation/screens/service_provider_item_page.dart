import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_pallete.dart';
import '../../../../core/theme/text_style.dart';
import '../../../../core/utils/show_snack_bar.dart';
import '../../../admin/data/model/item_model.dart';
import '../riverpods/service_provider_item_riverpod.dart';
import '../riverpods/service_provider_item_state.dart';
import '../riverpods/service_provider_item_view_model.dart';
import '../widgets/service_provider_item_card.dart';
import 'service_provider_add_item_page.dart';
import 'service_provider_edit_item_page.dart';

class ServiceProviderItemPage extends ConsumerStatefulWidget {
  const ServiceProviderItemPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ServiceProviderItemPage> createState() =>
      _ServiceProviderItemPageState();
}

class _ServiceProviderItemPageState
    extends ConsumerState<ServiceProviderItemPage> {
  int? _selectedCategoryId;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _fetchData() {
    ref.read(serviceProviderItemProvider.notifier).fetchCategories();
    ref.read(serviceProviderItemProvider.notifier).fetchItems();
  }

  void _onCategorySelected(int? categoryId) {
    setState(() {
      _selectedCategoryId = categoryId;
    });
  }

  void _onItemCardTapped(ItemModel item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Item Options',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit, color: AppPallete.binkForText),
              title: const Text('Edit Item'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ServiceProviderEditItemPage(item: item),
                  ),
                ).then((_) => _fetchData());
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete Item'),
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmation(item);
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline, color: Colors.blue),
              title: const Text('View Details'),
              onTap: () {
                Navigator.pop(context);
                _showItemDetails(
                  context: context,
                  title: item.name,
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Description: ${item.description}'),
                      const SizedBox(height: 10),
                      Text('Quantity: ${item.quantity}'),
                      const SizedBox(height: 10),
                      Text('Retail Price: ${item.retailPrice} EGP'),
                      const SizedBox(height: 10),
                      Text('Wholesale Price: ${item.wholesalePrice} EGP'),
                      const SizedBox(height: 10),
                      Text(
                          'Profit per item: ${item.retailPrice - item.wholesalePrice} EGP'),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(ItemModel item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text('Are you sure you want to delete ${item.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref
                  .read(serviceProviderItemProvider.notifier)
                  .deleteItem(item.id, item.imageUrl);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _showItemDetails({
    required BuildContext context,
    required String title,
    required Widget content,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: content,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(serviceProviderItemProvider, (prev, next) {
      if (next.status == ServiceProviderItemStateStatus.successDeleteItem) {
        showSnackBar(context, 'Item deleted successfully');
      } else if (next.status ==
          ServiceProviderItemStateStatus.successUpdateItem) {
        showSnackBar(context, 'Item updated successfully');
      } else if (next.status == ServiceProviderItemStateStatus.failure) {
        showSnackBar(context, next.error ?? 'An error occurred');
      }
    });

    final serviceProviderItemState = ref.watch(serviceProviderItemProvider);
    final viewModel = ref.watch(serviceProviderItemViewModelProvider);

    // Filter items based on selected category and search query
    List<ItemModel> filteredItems = serviceProviderItemState.items;
    if (_selectedCategoryId != null) {
      filteredItems = filteredItems
          .where((item) => item.categoryId == _selectedCategoryId)
          .toList();
    }

    if (viewModel.searchQuery.isNotEmpty) {
      filteredItems = filteredItems
          .where((item) => item.name
              .toLowerCase()
              .contains(viewModel.searchQuery.toLowerCase()))
          .toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Products'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _fetchData,
            icon: const Icon(Icons.refresh, color: AppPallete.binkForText),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ServiceProviderAddItemPage(),
            ),
          ).then((_) => _fetchData());
        },
        backgroundColor: AppPallete.binkForText,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: TextField(
                controller: _searchController,
                onChanged: (value) => viewModel.updateSearchQuery(value),
                decoration: InputDecoration(
                  hintText: 'Search products...',
                  prefixIcon:
                      const Icon(Icons.search, color: AppPallete.binkForText),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            // Categories Chips
            SizedBox(
              height: 50.h,
              child: serviceProviderItemState.categories.isEmpty
                  ? const Center(
                      child: Text('No categories available'),
                    )
                  : ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 8.w),
                          child: ChoiceChip(
                            label: const Text('All'),
                            selected: _selectedCategoryId == null,
                            onSelected: (selected) {
                              if (selected) {
                                _onCategorySelected(null);
                              }
                            },
                            backgroundColor: Colors.grey.shade200,
                            selectedColor:
                                AppPallete.binkForText.withOpacity(0.2),
                            labelStyle: TextStyle(
                              color: _selectedCategoryId == null
                                  ? AppPallete.binkForText
                                  : Colors.black87,
                              fontWeight: _selectedCategoryId == null
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                        ...serviceProviderItemState.categories.map((category) {
                          return Padding(
                            padding: EdgeInsets.only(right: 8.w),
                            child: ChoiceChip(
                              label: Text(category.name),
                              selected: _selectedCategoryId == category.id,
                              onSelected: (selected) {
                                if (selected) {
                                  _onCategorySelected(category.id);
                                }
                              },
                              backgroundColor: Colors.grey.shade200,
                              selectedColor:
                                  AppPallete.binkForText.withOpacity(0.2),
                              labelStyle: TextStyle(
                                color: _selectedCategoryId == category.id
                                    ? AppPallete.binkForText
                                    : Colors.black87,
                                fontWeight: _selectedCategoryId == category.id
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
            ),
            SizedBox(height: 16.h),

            // Statistics Row
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    'Total Items',
                    filteredItems.length.toString(),
                    Icons.inventory_2_outlined,
                  ),
                  _buildStatItem(
                    'Total Retail',
                    '${viewModel.calculateTotalRetailPrice(filteredItems).toStringAsFixed(2)} EGP',
                    Icons.shopping_cart_outlined,
                  ),
                  _buildStatItem(
                    'Total Profit',
                    '${viewModel.calculateTotalProfit(filteredItems).toStringAsFixed(2)} EGP',
                    Icons.monetization_on_outlined,
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),

            // Items Grid
            Expanded(
              child: serviceProviderItemState.status ==
                      ServiceProviderItemStateStatus.loading
                  ? const Center(
                      child: CircularProgressIndicator(
                          color: AppPallete.binkForText),
                    )
                  : filteredItems.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.inventory_2_outlined,
                                size: 64.sp,
                                color: Colors.grey.shade400,
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                'No products found',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                'Add some products to get started',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                              SizedBox(height: 16.h),
                              ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const ServiceProviderAddItemPage(),
                                    ),
                                  ).then((_) => _fetchData());
                                },
                                icon: const Icon(Icons.add),
                                label: const Text('Add Product'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppPallete.binkForText,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20.w,
                                    vertical: 12.h,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16.h,
                            crossAxisSpacing: 16.w,
                            childAspectRatio: 0.75,
                          ),
                          itemCount: filteredItems.length,
                          itemBuilder: (context, index) {
                            final item = filteredItems[index];
                            return ServiceProviderItemCard(
                              item: item,
                              onTap: () => _onItemCardTapped(item),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppPallete.binkForText, size: 24.sp),
        SizedBox(height: 8.h),
        Text(
          title,
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey.shade600,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
