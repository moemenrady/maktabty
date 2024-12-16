import 'package:flutter/material.dart';
import 'package:mktabte/features/home/presentation/widgets/customtxtbtn.dart';
import 'package:mktabte/features/home/presentation/widgets/mainapppbar.dart';
import 'package:mktabte/features/home/presentation/widgets/product_bar.dart';
import 'package:mktabte/features/home/presentation/widgets/review_card.dart';
import 'package:mktabte/features/home/presentation/widgets/roundedcontainer.dart';

import '../../../../core/theme/text_style.dart';

class Product extends StatefulWidget {
  const Product({super.key});

  @override
  State<Product> createState() => _ProductState();
}

class _ProductState extends State<Product> {
  late PageController _pageController;

  List<String> productsImgs = [
    "assets/images/blackcontroller.png",
    "assets/images/blackcontroller1.png",
    "assets/images/blackcontroller.png",
    "assets/images/blackcontroller1.png",
  ];
  String prod_desck =
      "A sleek black joystick with neon accents and a comfortable grip for precise gaming control...";

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

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
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: productsImgs.length,
                  itemBuilder: (context, index) {
                    return Image.asset(
                      productsImgs[index],
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.error,
                            size: 50, color: Colors.red);
                      },
                    );
                  },
                ),
              ),
            ),

            // Product title and price
            Text(
              "Nike Sportswear Club Fleece",
              style: TextStyles.Inter18SemiBoldlightBlack,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Text(
                "\$20",
                style: TextStyles.Roboto20mediumBlack,
              ),
            ),

            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                RoundedContainer(
                  "4.0",
                  const Icon(Icons.star_rounded,
                      size: 20, color: Colors.yellow),
                  null,
                  const Color.fromARGB(71, 255, 128, 55),
                ),
                RoundedContainer("3.9", null, "assets/images/like_icon.png",
                    const Color.fromARGB(255, 201, 117, 53)),
                const SizedBox(width: 5),
                const SizedBox(width: 5),
                Text(
                  "130 Review",
                  style: TextStyles.Roboto15regularlightBlack,
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),

            Text("Size", style: TextStyles.Inter18SemiBoldlightBlack),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomTxtBtn(str: 'L'),
                CustomTxtBtn(str: 'XL'),
                CustomTxtBtn(str: 'XXL'),
                CustomTxtBtn(str: 'XXXL'),
              ],
            ),
            const SizedBox(
              height: 7,
            ),
            // Product description
            Text("Description", style: TextStyles.Blinker20semiBoldBlack),
            const SizedBox(
              height: 5,
            ),
            Text(prod_desck, style: TextStyles.Blinker16regularlightBlack),
            const SizedBox(
              height: 7,
            ),
            Text("Reviews", style: TextStyles.Blinker20semiBoldBlack),
            const SizedBox(
              height: 5,
            ),
            // Review card
            Row(
              children: [
                Expanded(child: ReviewCard()),
              ],
            ),

            // ProductBar widget in the bottom
            const Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ProductBar(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
