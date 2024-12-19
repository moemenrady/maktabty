import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mktabte/features/home/presentation/riverpods/categories_river_pod/categories_riverpod_state.dart';

import '../riverpods/categories_river_pod/categories_riverpod.dart';
import '../widgets/custom_categories_grid.dart';
import '../widgets/mainapppbar.dart';
import 'category.dart';

class CategryScreen extends ConsumerWidget {
  const CategryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(categoriesRiverpodProvider);
    return Scaffold(
      appBar: MainAppBar(context, false, "All categories"),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: SearchBar(
              autoFocus: false,
              hintText: 'Search',
              leading: Icon(Icons.search_outlined),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          if (state.isError()) Text("${state.errorMessage}"),
          if (state.isLoading() || state.categories == null)
            const CircularProgressIndicator(),
          if (state.categories != null) const CustomCategoriesGrid()
        ],
      ),
    );
  }
}
