import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mktabte/features/home/presentation/widgets/custom_app_bar.dart';
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
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image carousel
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 5),
                  child: SizedBox(
                      height: 384.h,
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Text(
                    "EGP ${item.retailPrice}",
                    style: TextStyles.Roboto20mediumBlack,
                  ),
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
                SizedBox(height: 3.h,),
                Text("Description", style: TextStyles.Blinker20semiBoldBlack),
                const SizedBox(
                  height: 5,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text("product desckription product desckription product desckription product desckription", style: TextStyles.Blinker16regularlightBlack),
                const SizedBox(
                  height: 7,
                ),
                Text("Reviews", style: TextStyles.Blinker20semiBoldBlack),
                const SizedBox(
                  height: 5,
                ),
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
          Positioned(
              left: 0,
              right: 0,
              top: 4,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: CustomAppBar(txt: "", hasArrow: true, hasIcons: true),
              )),
        ],
      ),
    );
  }
}
