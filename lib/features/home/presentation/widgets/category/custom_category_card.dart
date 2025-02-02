import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:mktabte/features/check_out/presentation/screen/product_details_creen.dart';
import 'package:mktabte/features/home/presentation/widgets/category/custome_favourite_button.dart';
import '../../../../../core/comman/widgets/animated_price_widget.dart';

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
    return OpenContainer(
      transitionDuration: const Duration(milliseconds: 1200),
      openBuilder: (context, _) => ProductDetailsScreen(item: item),
      closedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      closedColor: Colors.white,
      closedBuilder: (context, openContainer) {
        return Container(
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
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          item.imageUrl ?? '',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                        ),
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
                    child: AnimatedPriceWidget(
                      price: item.retailPrice,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Inter",
                      ),
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
        );
      },
    );
  }
}
