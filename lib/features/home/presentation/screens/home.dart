import 'package:flutter/material.dart';

import '../widgets/filtersbtns.dart';
import '../widgets/mainapppbar.dart';
import 'productscreen.dart';

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
      appBar: MainAppBar(context,false, "HOME"),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.red,image: DecorationImage(image:AssetImage(offers[index]),fit: BoxFit.cover) ),
                       
                       
                        
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
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text("Best Seller"),
                ),
                const Spacer(),
                TextButton(onPressed: () {}, child: const Text("see all"))
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: offers.length,
                itemBuilder: (context, index) {
                  return InkWell(onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                          builder: (context) =>
                              const Product(),
                        )
                      );
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
