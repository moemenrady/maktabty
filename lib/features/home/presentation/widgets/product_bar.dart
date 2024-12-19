import 'package:flutter/material.dart';

class ProductBar extends StatelessWidget {
  const ProductBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 296,
      height: 60,
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {},
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Color(0xFFF68B3B)),
                minimumSize: WidgetStateProperty.all(Size(97, 38)),
                padding: WidgetStateProperty.all(EdgeInsets.zero),
              ),
              child: const Text(
                "Add to cart",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            TextButton(
              onPressed: () {},
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Color(0xFFF68B3B)),
                minimumSize: WidgetStateProperty.all(Size(97, 38)),
                padding: WidgetStateProperty.all(EdgeInsets.zero),
              ),
              child: const Text(
                "Buy Now",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              height: 38,
              width: 38,
              decoration: BoxDecoration(
                color: Color.fromARGB(131, 246, 140, 59),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: InkWell(
                onTap: () {},
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Color.fromARGB(71, 246, 140, 59),
                  child: Icon(
                    Icons.favorite_border_outlined,
                    color: Colors.white,
                    size: 20,
                    
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
