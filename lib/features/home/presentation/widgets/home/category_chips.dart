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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 16.w, bottom: 12.h),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFF68B3B).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.category_outlined,
                  color: const Color(0xFFF68B3B),
                  size: 18.w,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                "Categories",
                style: TextStyles.Blinker18semiBoldBlack.copyWith(
                  color: const Color(0xFFF68B3B),
                ),
              ),
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              SizedBox(width: 16.w), // Initial padding
              ...categories
                  .map((category) => _buildChip(category.name, category)),
              SizedBox(width: 8.w), // End padding
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChip(String label, Categories? category) {
    final isSelected = category?.id == selectedCategory?.id;

    return Padding(
      padding: EdgeInsets.only(right: 8.w),
      child: GestureDetector(
        onTap: () => onCategorySelected(category),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFF68B3B) : Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFFF68B3B)
                  : const Color(0xFFF68B3B).withOpacity(0.2),
              width: 1.5,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: const Color(0xFFF68B3B).withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isSelected) ...[
                Icon(
                  Icons.check_circle_outline,
                  color: Colors.white,
                  size: 16.w,
                ),
                SizedBox(width: 4.w),
              ],
              Text(
                label,
                style: TextStyles.Blinker14regular.copyWith(
                  color: isSelected ? Colors.white : const Color(0xFF808080),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
