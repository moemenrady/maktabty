import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/comman/app_user/app_user_riverpod.dart';
import '../../../../../core/theme/text_style.dart';
import '../../../model/rating_model.dart';
import '../../riverpods/rating/rating_riverpod.dart';

class AddRatingDialog extends ConsumerStatefulWidget {
  final String itemId;
  final RatingModel? rating;

  const AddRatingDialog({
    super.key,
    required this.itemId,
    this.rating,
  });

  @override
  ConsumerState<AddRatingDialog> createState() => _AddRatingDialogState();
}

class _AddRatingDialogState extends ConsumerState<AddRatingDialog> {
  late final TextEditingController _commentController;
  late double _rating;

  @override
  void initState() {
    super.initState();
    _commentController =
        TextEditingController(text: widget.rating?.comment ?? '');
    _rating = widget.rating?.rate ?? 5.0;
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Add Review',
              style: TextStyles.Blinker18semiBoldBlack,
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                (index) => IconButton(
                  onPressed: () {
                    setState(() {
                      _rating = (index + 1).toDouble();
                    });
                  },
                  icon: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    color: Colors.yellow,
                    size: 32.w,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            TextField(
              controller: _commentController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Write your review...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(
                    color: const Color(0xFFF68B3B).withOpacity(0.2),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: const BorderSide(
                    color: Color(0xFFF68B3B),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final userId = ref.read(appUserRiverpodProvider).user!.id!;
                  final rating = widget.rating?.copyWith(
                        rate: _rating,
                        comment: _commentController.text,
                      ) ??
                      RatingModel(
                        id: DateTime.now().millisecondsSinceEpoch,
                        rate: _rating,
                        userId: userId,
                        itemId: widget.itemId,
                        comment: _commentController.text,
                        createdAt: DateTime.now().toUtc(),
                      );

                  if (widget.rating != null) {
                    ref
                        .read(ratingProvider(widget.itemId).notifier)
                        .updateRating(rating);
                  } else {
                    ref
                        .read(ratingProvider(widget.itemId).notifier)
                        .addRating(rating);
                  }
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF68B3B),
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  'Submit Review',
                  style: TextStyles.blinker14Boldwhite,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
