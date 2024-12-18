import 'package:flutter/material.dart';
import 'package:mktabte/features/home/presentation/widgets/custom_app_bar.dart';
import 'package:mktabte/features/home/presentation/widgets/custom_categories_grid.dart';


List categories = [
  "assets/images/offer2.jpg",
  "assets/images/offer1.jpg",
  "assets/images/offer2.jpg",
  "assets/images/offer1.jpg",
  "assets/images/offer2.jpg",
  "assets/images/offer1.jpg",
  "assets/images/offer2.jpg",
  "assets/images/offer1.jpg",
  "assets/images/offer2.jpg",
  "assets/images/offer1.jpg",
  "assets/images/offer2.jpg",
  "assets/images/offer1.jpg",
];
List categoriesnames = [
  "category1",
  "category2",
  "category3",
  "category4",
  "category5",
  "category6",
  "category7",
  "category8",
  "category9",
  "category10",
  "category11",
  "category12"
];

class CategryScreen extends StatelessWidget {
  const CategryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CustomAppBar(
                txt: "All Categories", hasArrow: false, hasIcons: true),
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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: CustomCategoriesGrid(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
