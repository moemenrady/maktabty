import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/comman/app_user/app_user_riverpod.dart';
import '../../../../../core/theme/text_style.dart';
import '../../../../../core/utils/show_snack_bar.dart';
import '../../../../admin/data/model/item_model.dart';
import '../../../model/rating_model.dart';
import '../../riverpods/rating/rating_riverpod.dart';
import 'add_rating_dialog.dart';

class CustomRatingSection extends ConsumerWidget {
  final ItemModel item;

  const CustomRatingSection({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ratingState = ref.watch(ratingProvider(item.id));
    if (ratingState.isLoading()) {
      return const Center(child: CircularProgressIndicator());
    }

    if (ratingState.ratings.isEmpty) {
      return InkWell(
        onTap: () {
          if (ref.read(appUserRiverpodProvider).user?.name == "Guest") {
            showSnackBar(context, "Please login to add a review");
            return;
          }
          showDialog(
            context: context,
            builder: (context) => AddRatingDialog(itemId: item.id),
          );
        },
        child: Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(15.r),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (index) => Icon(
                    Icons.star,
                    color: Colors.yellow,
                    size: 24.w,
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'No Reviews Yet',
                style: TextStyles.Blinker18semiBoldBlack,
              ),
              SizedBox(height: 8.h),
              Text(
                'Be the first to review this product',
                style: TextStyles.Blinker14regular.copyWith(
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  ratingState.averageRating.toStringAsFixed(1),
                  style: TextStyles.Blinker24semiBoldBlack,
                ),
                SizedBox(width: 8.w),
                Row(
                  children: List.generate(
                    5,
                    (index) => Icon(
                      index < ratingState.averageRating.floor()
                          ? Icons.star
                          : Icons.star_border,
                      color: Colors.yellow,
                      size: 20.w,
                    ),
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                if (ref.read(appUserRiverpodProvider).user?.name == "Guest") {
                  showSnackBar(context, "Please login to add a review");
                  return;
                }
                showDialog(
                  context: context,
                  builder: (context) => AddRatingDialog(itemId: item.id),
                );
              },
              child: Text(
                'Add Review',
                style: TextStyles.Blinker14regular.copyWith(
                  color: const Color(0xFFF68B3B),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: ratingState.ratings.length,
          itemBuilder: (context, index) {
            final rating = ratingState.ratings[index];
            final currentUserId = ref.read(appUserRiverpodProvider).user!.id!;
            final isUserRating = rating.userId == currentUserId;

            return Container(
              margin: EdgeInsets.only(bottom: 16.h),
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: List.generate(
                          5,
                          (i) => Icon(
                            i < rating.rate ? Icons.star : Icons.star_border,
                            color: Colors.yellow,
                            size: 16.w,
                          ),
                        ),
                      ),
                      if (isUserRating)
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit,
                                  color: Color(0xFFF68B3B)),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AddRatingDialog(
                                    itemId: item.id,
                                    rating: rating,
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Delete Review'),
                                    content: const Text(
                                      'Are you sure you want to delete this review?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          ref
                                              .read(ratingProvider(item.id)
                                                  .notifier)
                                              .deleteRating(rating.id);
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          'Delete',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    rating.comment,
                    style: TextStyles.Blinker14regular,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    rating.createdAt.toLocal().toString().split(' ')[0],
                    style: TextStyles.Blinker12regularBlack.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
