import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mktabte/features/home/presentation/widgets/custom_app_bar.dart';
import '../riverpods/categories_river_pod/categories_riverpod.dart';
import '../widgets/custom_categories_grid.dart';
import '../widgets/home/custom_search_bar.dart';

class CategryScreen extends ConsumerWidget {
  const CategryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 5.h,),
          CustomAppBar(txt: "All categories",hasArrow:  false,hasIcons:  true),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: CustomSearchBar(),
          ),
          const SizedBox(
            height: 16,
          ),
          Consumer(builder: (context, ref, child) {
            final state = ref.watch(categoriesRiverpodProvider);
            return CustomCategoriesGrid(state: state);
          })
        ],
      ),
    );
  }
}
