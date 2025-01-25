import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mktabte/features/home/presentation/widgets/custom_app_bar.dart';
import 'package:tuple/tuple.dart';
import '../../../admin/data/model/item_model.dart';
import '../riverpods/items_river_pod/items_riverpod.dart';
import '../riverpods/items_river_pod/items_riverpod_state.dart';
import '../widgets/category/custom_category_card.dart';
import '../widgets/home/custom_search_bar.dart';

class CategoryScreen extends ConsumerStatefulWidget {
  final int categoryId;
  const CategoryScreen({super.key, required this.categoryId});

  @override
  ConsumerState<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends ConsumerState<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await ref
              .read(
                  itemsRiverpodProvider(Tuple2(widget.categoryId, 1)).notifier)
              .getItemsWithFavoritesForCategory(widget.categoryId, 1);
        },
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              CustomAppBar(txt: "Categoty1", hasArrow: true, hasIcons: true),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomSearchBar(),
              ),
              const SizedBox(height: 8),
              Consumer(
                builder: (context, ref, child) {
                  final state = ref.watch(
                      itemsRiverpodProvider(Tuple2(widget.categoryId, 1)));
                  final items = ref.watch(
                    itemsRiverpodProvider(Tuple2(widget.categoryId, 1))
                        .select((state) => state.items),
                  );
                  final controller = ref.read(
                      itemsRiverpodProvider(Tuple2(widget.categoryId, 1))
                          .notifier);
                  return Expanded(
                    child: Column(
                      children: [
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
                              child!
                            ],
                          ),
                        ),
                        Expanded(
                          child: _buildContent(
                            state.isLoading(),
                            state.isError(),
                            state.errorMessage,
                            items,
                            (index) {
                              controller.addToFavorites(
                                  1, items[index].id, widget.categoryId);
                            },
                            (index) {
                              controller.removeFromFavorites(
                                  1, items[index].id, widget.categoryId);
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
                child: Row(
                  children: [
                    _buildSortButton(),
                    _buildFilterButton(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
      bool isLoading,
      bool isError,
      String? errorMessage,
      List<ItemModel>? items,
      void Function(int index) onAddToFavourite,
      void Function(int index) onRemoveFromFavourite) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (isError) {
      return Center(child: Text(errorMessage ?? 'An error occurred'));
    }

    if (items == null || items.isEmpty) {
      return const Center(child: Text('No items found'));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        childAspectRatio: 0.6,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return CustomCategoryCard(
            item: item,
            index: index,
            onAddToFavourite: () => onAddToFavourite(index),
            onRemoveFromFavourite: () => onRemoveFromFavourite(index));
      },
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
