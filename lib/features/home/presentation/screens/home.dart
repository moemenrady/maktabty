import 'package:flutter/material.dart';

import '../../../../core/theme/text_style.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_home_products.dart';
import '../widgets/custom_offers_widget.dart';
import '../widgets/filtersbtns.dart';

List offers = [
  "assets/images/offer2.jpg",
  "assets/images/offer1.jpg",
  "assets/images/offer2.jpg",
  "assets/images/offer1.jpg",
];

class HomePpage extends StatelessWidget {
  const HomePpage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomAppBar(
              hasArrow: false,
              txt: "",
              hasIcons: true,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SearchBar(
                autoFocus: false,
                hintText: 'Search',
                leading: Image.asset("assets/images/Search-Magnifier.png"),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            CustomOffersWidget(),
            const SizedBox(
              height: 10,
            ),
            const FiltersBTNS(),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text("Best Seller",style: TextStyles.Blinker18semiBoldBlack,),
                ),
                const Spacer(),
                TextButton(onPressed: () {}, child: Text("see all",style: TextStyles.Blinker16regularlightOrange,))
              ],
            ),
            CustomHomeProducts(),
          ],
        ),
      ),
    );
  }
}
