import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mktabte/features/home/presentation/riverpods/categories_river_pod/categories_riverpod_state.dart';
import 'package:mktabte/features/home/presentation/widgets/custom_app_bar.dart';
import '../riverpods/categories_river_pod/categories_riverpod.dart';
import '../widgets/custom_categories_grid.dart';
import '../widgets/home/custom_search_bar.dart';
import '../widgets/categories/categories_search_bar.dart';
import '../controllers/categories_search_controller.dart';

class CategryScreen extends ConsumerStatefulWidget {
  const CategryScreen({super.key});

  @override
  ConsumerState<CategryScreen> createState() => _CategryScreenState();
}

class _CategryScreenState extends ConsumerState<CategryScreen> {
  late final CategoriesSearchController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = CategoriesSearchController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(categoriesRiverpodProvider);

    ref.listen(categoriesRiverpodProvider, (previous, next) {
      if (next.categories != previous?.categories) {
        _searchController.setCategories(next.categories);
      }
    });

    if (state.isLoading()) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (state.isError()) {
      return Scaffold(
        body: Center(child: Text(state.errorMessage ?? 'An error occurred')),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 5.h),
          CustomAppBar(txt: "All categories", hasArrow: false, hasIcons: true),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: CategoriesSearchBar(
              onChanged: _searchController.updateSearchQuery,
            ),
          ),
          const SizedBox(height: 16),
          ListenableBuilder(
            listenable: _searchController,
            builder: (context, _) {
              final filteredCategories = _searchController.filteredCategories;
              return CustomCategoriesGrid(
                state: state,
                filteredCategories: filteredCategories,
              );
            },
          ),
        ],
      ),
    );
  }
}
