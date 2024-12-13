import 'package:flutter/material.dart';

import '../widgets/mainapppbar.dart';
import 'category.dart';

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
      appBar: MainAppBar(context,false, "All categories"),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: SearchBar(
              autoFocus: false,
              hintText: 'Search',
              leading: Icon(Icons.search_outlined),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of columns
                  crossAxisSpacing: 8.0, // Horizontal space between items
                  mainAxisSpacing: 8.0, // Vertical space between items
                  childAspectRatio: 1.0, // Aspect ratio of each grid item
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const CategoryScreen(),
                        ),
                      );
                      print("${categoriesnames[index]}");
                    },
                    child: Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Column(
                            children: [
                              Image.asset(
                                categories[index],
                                fit: BoxFit.cover,
                              ),
                              const Spacer(),
                              Text(categoriesnames[index]),
                              const Spacer(),
                            ],
                          )),
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
