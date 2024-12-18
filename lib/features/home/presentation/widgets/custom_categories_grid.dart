import 'package:flutter/material.dart';

import '../../../../core/theme/text_style.dart';
import '../screens/allcategriesscreen.dart';
import '../screens/category.dart';

class CustomCategoriesGrid extends StatelessWidget {
  const CustomCategoriesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CategoryScreen()),
                        );
                        print("${categoriesnames[index]}");
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Material(
                          elevation: 8,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            width: 164,
                            height: 212,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  height: 180,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                    image: DecorationImage(
                                      image: AssetImage(categories[index]),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Text(categoriesnames[index],style: TextStyles.Roboto14mediumblack,),
                                const Spacer(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
  }
}