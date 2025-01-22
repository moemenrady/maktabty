import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/show_dialog.dart';
import '../../../../core/theme/app_text_styles.dart';

import '../riverpods/item_riverpod/item_riverpod.dart';
import 'update_item_page.dart';

class ItemPage extends ConsumerWidget {
  const ItemPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemState = ref.watch(itemListProvider);
    final categories = itemState.categories;

    return DefaultTabController(
      length: categories.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Items'),
          bottom: TabBar(
            isScrollable: true,
            tabs:
                categories.map((category) => Tab(text: category.name)).toList(),
          ),
        ),
        body: TabBarView(
          children: categories
              .map((category) => _ItemGrid(categoryId: category.id))
              .toList(),
        ),
      ),
    );
  }
}

class _ItemGrid extends ConsumerStatefulWidget {
  final int categoryId;
  const _ItemGrid({required this.categoryId});

  @override
  ConsumerState<_ItemGrid> createState() => _ItemGridState();
}

class _ItemGridState extends ConsumerState<_ItemGrid> {
  @override
  Widget build(BuildContext context) {
    final itemsState = ref.watch(itemListProvider);
    final viewModel = ref.watch(itemListViewModelProvider);

    final filteredItems =
        viewModel.filterItems(itemsState.items, widget.categoryId);

    return Column(
      children: [
        // Summary Card
        Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Retail: EGP ${viewModel.calculateTotalRetailPrice(filteredItems).toStringAsFixed(2)}',
                      style: AppTextStyles.summaryText,
                    ),
                    Text(
                      'Total Wholesale: EGP ${viewModel.calculateTotalWholesalePrice(filteredItems).toStringAsFixed(2)}',
                      style: AppTextStyles.summaryText,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Total Profit: EGP ${viewModel.calculateTotalProfit(filteredItems).toStringAsFixed(2)}',
                  style: AppTextStyles.summaryProfit,
                ),
              ],
            ),
          ),
        ),
        // Search Bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            controller: viewModel.searchController,
            decoration: InputDecoration(
              hintText: 'Search items...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onChanged: (value) {
              setState(() {
                viewModel.updateSearchQuery(value);
              });
            },
          ),
        ),
        // Grid Items
        Expanded(
          child: itemsState.isLoading()
              ? const Center(child: CircularProgressIndicator())
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.50,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: filteredItems.length,
                  itemBuilder: (context, index) {
                    final item = filteredItems[index];
                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: InkWell(
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdateItemPage(item: item),
                            ),
                          );
                          ref.read(itemListProvider.notifier).fetchItems();
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12),
                              ),
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: Image.network(
                                  item.imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey[300],
                                      child: const Icon(
                                        Icons.image_not_supported,
                                        size: 50,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name,
                                    style: AppTextStyles.itemTitle,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Quantity: ${item.quantity}',
                                    style: AppTextStyles.itemQuantity,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Unit Price: EGP ${item.retailPrice.toStringAsFixed(2)}',
                                    style: AppTextStyles.itemUnitPrice,
                                  ),
                                  Text(
                                    'Total Retail: EGP ${viewModel.calculateItemTotalRetail(item).toStringAsFixed(2)}',
                                    style: AppTextStyles.itemTotalPrice,
                                  ),
                                  Text(
                                    'Unit Wholesale: EGP ${item.wholesalePrice.toStringAsFixed(2)}',
                                    style: AppTextStyles.itemUnitWholesale,
                                  ),
                                  Text(
                                    'Total Wholesale: EGP ${viewModel.calculateItemTotalWholesale(item).toStringAsFixed(2)}',
                                    style: AppTextStyles.itemTotalWholesale,
                                  ),
                                  Text(
                                    'Profit: EGP ${viewModel.calculateItemProfit(item).toStringAsFixed(2)}',
                                    style: AppTextStyles.itemProfit,
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            Container(
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                border: Border(
                                  top: BorderSide(color: Colors.grey),
                                ),
                              ),
                              child: IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => showDeleteConfirmationDialog(
                                  context,
                                  ref,
                                  () => ref
                                      .read(itemListProvider.notifier)
                                      .deleteItem(item.id),
                                ),
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
