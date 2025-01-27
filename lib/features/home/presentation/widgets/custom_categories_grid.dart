import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mktabte/features/home/presentation/riverpods/categories_river_pod/categories_riverpod_state.dart';

import '../../../../core/theme/text_style.dart';
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
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.68,
            crossAxisSpacing: 16.w,
            mainAxisSpacing: 16.h,
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
                        CategoryScreen(categoryId: categories.id,categoryName: categories.name,),
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
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(20.r),topRight: Radius.circular(20.r),bottomLeft: Radius.circular(0.r),bottomRight: Radius.circular(0.r)),
                        child: Image.network(
                          categories.imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(12.0.w),
                      child: Center(
                          child: Text(
                        categories.name,
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
