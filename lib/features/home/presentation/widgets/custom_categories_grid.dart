import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mktabte/features/home/presentation/riverpods/categories_river_pod/categories_riverpod_state.dart';

import '../../../../core/comman/entitys/categories.dart';
import '../../../../core/comman/widgets/custom_cached_network_image_provider.dart';
import '../../../../core/theme/text_style.dart';
import '../screens/category.dart';

class CustomCategoriesGrid extends ConsumerWidget {
  final CategoriesRiverpodState state;
  final List<Categories>? filteredCategories;

  const CustomCategoriesGrid({
    super.key,
    required this.state,
    this.filteredCategories,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (state.isLoading()) {
      return const CircularProgressIndicator();
    }

    final categories = filteredCategories ?? state.categories;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.68,
            crossAxisSpacing: 16.w,
            mainAxisSpacing: 16.h,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoryScreen(
                      categoryId: category.id,
                      categoryName: category.name,
                    ),
                  ),
                );
              },
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.r),
                            topRight: Radius.circular(20.r),
                            bottomLeft: Radius.circular(0.r),
                            bottomRight: Radius.circular(0.r)),
                        child: CustomCachedNetworkImageProvider(
                          imageUrl: category.imageUrl,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(12.0.w),
                      child: Center(
                          child: Text(
                        category.name,
                        style: TextStyles.Roboto14mediumblackForText,
                      )),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
