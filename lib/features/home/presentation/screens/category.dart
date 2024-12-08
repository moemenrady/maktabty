import 'package:flutter/material.dart';

import '../widgets/mainapppbar.dart';

List productsimgs = [
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
List productsnames = [
  "product1",
  "product2",
  "product3",
  "product4",
  "product5",
  "product6",
  "product7",
  "product8",
  "product9",
  "product10",
  "product11",
  "product12"
];
List productsprices = [
  "\$150",
  "\$100",
  "\$200",
  "\$170",
  "\$100",
  "\$130",
  "\$150",
  "\$150",
  "\$150",
  "\$150",
  "\$150",
  "\$150",
];

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
  
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<bool> isFavoritedList = []; 

  @override
  void initState() {
    super.initState();
    isFavoritedList = List<bool>.filled(productsimgs.length, false);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(true, "category1"),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: SearchBar(
                autoFocus: false,
                hintText: 'Search',
                leading: Icon(Icons.search_outlined),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    "${productsimgs.length.toString()}+ Items",
                    style: const TextStyle(
                        fontSize: 20,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  ////////// btns
                  InkWell(
                    onTap: () {
                      print("Sort tapped");
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: const Row(
                          children: [
                            Text(
                              "Sort",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(width: 5),
                            Icon(Icons.sort, size: 20),
                          ],
                        ),
                      ),
                    ),
                  ),

                  InkWell(
                    onTap: () {
                      print("filter tapped");
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: const Row(
                          children: [
                            Text(
                              "Filter",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(width: 5),
                            Icon(Icons.filter_alt_outlined, size: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Number of columns
                    crossAxisSpacing: 8.0, // Horizontal space between items
                    mainAxisSpacing: 8.0, // Vertical space between items
                    childAspectRatio:0.7, // Aspect ratio of each grid item
                  ),
                  itemCount: productsimgs.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        print("${productsimgs[index]}");
                      },
                      child: AspectRatio(
                        aspectRatio: 3 / 4,
                        child: Card(
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Stack(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Image.asset(
                                        productsimgs[index],
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Text(
                                        productsnames[index],
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Text(
                                        productsprices[index],
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                  ],
                                ),
                                // Positioned favorite icon
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: InkWell(
                                    onTap: () {
                                      
                                      setState(() {
                                        isFavoritedList[index] =
                                            !isFavoritedList[index]; 
                                            print("Favorite icon tapped");
                                      });
                                    },
                                    child: CircleAvatar(
                                      radius: 16,
                                      backgroundColor:
                                          Colors.white.withOpacity(0.8),
                                      child: Icon(
                                        !isFavoritedList[index]
                                            ? Icons
                                                .favorite
                                            : Icons
                                                .favorite_border, 
                                        color: !isFavoritedList[index]
                                            ? const Color.fromARGB(255, 244, 67, 54)
                                            : Colors.grey, 
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
