import 'package:flutter/material.dart';
import 'package:mktabte/features/home/presentation/widgets/mainapppbar.dart';
import 'package:mktabte/features/check_out/presentation/widget/product_details_screen/product_bar.dart';
import 'package:mktabte/features/check_out/presentation/widget/product_details_screen/review_card.dart';

import '../../../../core/theme/text_style.dart';
import '../../../admin/data/model/item_model.dart';

class ProductDetailsScreen extends StatelessWidget {
  final ItemModel item;
  const ProductDetailsScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(context, true, ""),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image carousel
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 5),
              child: SizedBox(
                  height: 384,
                  width: double.infinity,
                  child: Image.network(
                    item.imageUrl,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.error,
                          size: 50, color: Colors.red);
                    },
                  )),
            ),

            // Product title and price
            Text(
              item.name,
              style: TextStyles.Inter18SemiBoldlightBlack,
            ),
            // Padding(
            //   padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            //   child: Text(
            //     "\$20",
            //     style: TextStyles.Roboto20mediumBlack,
            //   ),
            // ),

            // const SizedBox(
            //   height: 5,
            // ),
            // Row(
            //   children: [
            //     RoundedContainer(
            //       "4.0",
            //       const Icon(Icons.star_rounded,
            //           size: 20, color: Colors.yellow),
            //       null,
            //       const Color.fromARGB(71, 255, 128, 55),
            //     ),
            //     RoundedContainer("3.9", null, "assets/images/like_icon.png",
            //         const Color.fromARGB(255, 201, 117, 53)),
            //     const SizedBox(width: 5),
            //     const SizedBox(width: 5),
            //     Text(
            //       "130 Review",
            //       style: TextStyles.Roboto15regularlightBlack,
            //     ),
            //   ],
            // ),
            // const SizedBox(
            //   height: 5,
            // ),

            // Text("Size", style: TextStyles.Inter18SemiBoldlightBlack),
            // const Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     CustomTxtBtn(str: 'L'),
            //     CustomTxtBtn(str: 'XL'),
            //     CustomTxtBtn(str: 'XXL'),
            //     CustomTxtBtn(str: 'XXXL'),
            //   ],
            // ),
            // const SizedBox(
            //   height: 7,
            // ),
            // // Product description
            // Text("Description", style: TextStyles.Blinker20semiBoldBlack),
            // const SizedBox(
            //   height: 5,
            // ),
            // Text(prod_desck, style: TextStyles.Blinker16regularlightBlack),
            // const SizedBox(
            //   height: 7,
            // ),
            // Text("Reviews", style: TextStyles.Blinker20semiBoldBlack),
            // const SizedBox(
            //   height: 5,
            // ),
            // // Review card
            const Row(
              children: [
                Expanded(child: ReviewCard()),
              ],
            ),

            // ProductBar widget in the bottom
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ProductBar(item: item),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
