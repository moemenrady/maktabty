import 'package:flutter/material.dart';

import '../../../../core/theme/text_style.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_home_products.dart';
import '../widgets/custom_offers_widget.dart';
import '../widgets/filtersbtns.dart';
import '../widgets/mainapppbar.dart';
import '../../../check_out/presentation/screen/product_details_creen.dart';

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
      appBar: MainAppBar(context, false, "HOME"),
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
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Offers",
                style: TextStyle(
                  color: Color.fromARGB(255, 226, 133, 27),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 200,
              child: ListView.builder(
                  itemCount: offers.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 300,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.red,
                            image: DecorationImage(
                                image: AssetImage(offers[index]),
                                fit: BoxFit.cover)),
                      ),
                    );
                  }),
            ),
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
                  child: Text(
                    "Best Seller",
                    style: TextStyles.Blinker18semiBoldBlack,
                  ),
                ),
                const Spacer(),
                TextButton(onPressed: () {}, child: const Text("see all"))
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: offers.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProductDetailsScreen(),
                          ));
                    },
                    child: Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          offers[index],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
