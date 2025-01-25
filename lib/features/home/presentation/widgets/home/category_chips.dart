import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/comman/entitys/categories.dart';
import '../../../../../core/theme/text_style.dart';

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
            style: TextStyles.Blinker14regular.copyWith(
              color: isSelected
                  ? Colors.white
                  : Color(0xFF808080),
            ),
          ),
          backgroundColor: isSelected ? Color(0xFFF68B3B) : Color(0xFFDADADA),
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
        ),
      ),
    );
  }
}
