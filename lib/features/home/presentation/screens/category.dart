import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../admin/data/model/item_model.dart';
import '../riverpods/items_river_pod/items_riverpod.dart';
import '../riverpods/items_river_pod/items_riverpod_state.dart';
import '../widgets/mainapppbar.dart';
import '../../../check_out/presentation/screen/product_details_creen.dart';

class CategoryScreen extends ConsumerStatefulWidget {
  const CategoryScreen({super.key});

  @override
  ConsumerState<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends ConsumerState<CategoryScreen> {
  List<bool> isFavoritedList = [];

  @override
  void initState() {
    super.initState();
    isFavoritedList =
        List<bool>.filled(12, false); // Initialize with a default size
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(itemsRiverpodProvider);

    final items = ref.watch(
      itemsRiverpodProvider.select((state) => state.items),
    );

    return Scaffold(
      appBar: MainAppBar(context, true, "category1"),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(itemsRiverpodProvider.notifier).getAllItems();
        },
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: SearchBar(
                  autoFocus: false,
                  hintText: 'Search',
                  leading: Icon(Icons.search_outlined),
                ),
              ),
              const SizedBox(height: 8),
              if (items != null) ...[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        "${items.length} Items",
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
              ],
              const SizedBox(height: 12),
              Expanded(
                child: _buildContent(state.isLoading(), state.isError(),
                    state.errorMessage, items),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(bool isLoading, bool isError, String? errorMessage,
      List<ItemModel>? items) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (isError) {
      return Center(child: Text(errorMessage ?? 'An error occurred'));
    }

    if (items == null || items.isEmpty) {
      return const Center(child: Text('No items found'));
    }

    // Create a combined list of items plus special case
    final displayItems = List<ItemModel>.from(items);
    if (displayItems.length >= 2) {
      // Insert special item at index 2
      displayItems.insert(
          2,
          ItemModel(
            name: "Nike Shose Fuck Mafed And all Mena",
            imageUrl: "assets/images/cool boy.png",
            quantity: 99,
            categoryId: 0,
            id: "special",
          ));
    }
    if (displayItems.length >= 3) {
      // Insert special item at index 2
      displayItems.insert(
          3,
          ItemModel(
            name: "Nike Shose Fuck Mafed And all Mena",
            imageUrl: "assets/images/cool boy.png",
            quantity: 99,
            categoryId: 0,
            id: "special",
          ));
    }
    if (displayItems.length >= 4) {
      // Insert special item at index 2
      displayItems.insert(
          4,
          ItemModel(
            name: "Nike Shose Fuck Mafed And all Mena",
            imageUrl: "assets/images/cool boy.png",
            quantity: 99,
            categoryId: 0,
            id: "special",
          ));
    }

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: 0.7,
        ),
        itemCount: displayItems.length,
        itemBuilder: (context, index) {
          final item = displayItems[index];

          if (item.id == "special") {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            image: const DecorationImage(
                              image: AssetImage("assets/images/cool boy.png"),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          item.name ?? '',
                          maxLines: 2,
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 11.h,
                              fontFamily: "Inter"),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          '\$99',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Inter",
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                  _buildFavoriteButton(index),
                ],
              ),
            );
          }
          return _buildItemCard(item, index);
        },
      ),
    );
  }

  Widget _buildItemCard(ItemModel item, int index) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ProductDetailsScreen(),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(item.imageUrl ?? ''),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    maxLines: 2,
                    item.name ?? '',
                    style: const TextStyle(fontSize: 18, fontFamily: "Inter"),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    '\$99',
                    // '\$${item.quantity}2',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Inter"),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
            _buildFavoriteButton(index),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoriteButton(int index) {
    return Positioned(
      top: 8,
      right: 8,
      child: InkWell(
          onTap: () {
            setState(() {
              isFavoritedList[index] = !isFavoritedList[index];
            });
          },
          child: Image.asset(
            "assets/images/Heart.png",
            width: 20.w,
            height: 19.75.h,
          )),
    );
  }

  Widget _buildSortButton() {
    return InkWell(
      onTap: () {
        print("Sort tapped");
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: const Row(
          children: [
            Text(
              "Sort",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(width: 5),
            Icon(Icons.sort, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton() {
    return InkWell(
      onTap: () {
        print("Filter tapped");
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
