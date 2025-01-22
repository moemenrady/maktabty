import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mktabte/features/check_out/presentation/screen/product_details_creen.dart';
import 'package:mktabte/features/home/presentation/widgets/category/custome_favourite_button.dart';

import '../../../../admin/data/model/item_model.dart';

class CustomCategoryCard extends StatelessWidget {
  final ItemModel item;
  final int index;
  final void Function() onAddToFavourite;
  final void Function() onRemoveFromFavourite;

  const CustomCategoryCard({
    super.key,
    required this.item,
    required this.index,
    required this.onAddToFavourite,
    required this.onRemoveFromFavourite,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(item: item),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(item.imageUrl ?? ''),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    item.name ?? '',
                    maxLines: 2,
                    style: const TextStyle(fontSize: 18, fontFamily: "Inter"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    'EGP ${item.retailPrice}',
                    // '\$${item.quantity}2',
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Inter"),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
            CustomeFavouriteButton(
              image: item.isFavourite
                  ? "assets/images/heart.png"
                  : "assets/images/btns/favorite_btn_img.png",
              onTap: () {
                if (item.isFavourite) {
                  onRemoveFromFavourite();
                } else {
                  onAddToFavourite();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
