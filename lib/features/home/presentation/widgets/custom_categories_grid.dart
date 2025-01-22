import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mktabte/features/home/presentation/riverpods/categories_river_pod/categories_riverpod_state.dart';

import '../../../../core/theme/text_style.dart';
import '../riverpods/categories_river_pod/categories_riverpod.dart';
import '../screens/allcategriesscreen.dart';
import '../screens/category.dart';

class CustomCategoriesGrid extends ConsumerWidget {
  final CategoriesRiverpodState state;
  const CustomCategoriesGrid({super.key, required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (state.isLoading()) {
      return const CircularProgressIndicator();
    }

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Number of columns
            crossAxisSpacing: 8.0, // Horizontal space between items
            mainAxisSpacing: 8.0, // Vertical space between items
            childAspectRatio: 1.0, // Aspect ratio of each grid item
          ),
          itemCount: state.categories.length,
          itemBuilder: (context, index) {
            final categories = state.categories[index];
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CategoryScreen(categoryId: categories.id),
                  ),
                );
              },
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Column(
                      children: [
                        Image.network(
                          categories.imageUrl,
                          fit: BoxFit.cover,
                        ),
                        const Spacer(),
                        Text(categories.name),
                        const Spacer(),
                      ],
                    )),
              ),
            );
          },
        ),
      ),
    );
  }
}
