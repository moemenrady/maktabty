import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/comman/entitys/categories.dart';

class CategoryChips extends StatelessWidget {
  final List<Categories> categories;
  final Categories? selectedCategory;
  final Function(Categories?) onCategorySelected;

  const CategoryChips({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ...categories.map((category) => _buildChip(category.name, category)),
        ],
      ),
    );
  }

  Widget _buildChip(String label, Categories? category) {
    final isSelected = category?.id == selectedCategory?.id;

    return Padding(
      padding: EdgeInsets.only(right: 8.w),
      child: GestureDetector(
        onTap: () => onCategorySelected(category),
        child: Chip(
          label: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontFamily: 'Blinker',
              fontSize: 14.sp,
            ),
          ),
          backgroundColor: isSelected ? Colors.orange : Colors.grey[200],
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        ),
      ),
    );
  }
}
