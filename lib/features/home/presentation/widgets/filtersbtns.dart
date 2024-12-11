import 'package:flutter/material.dart';

class FiltersBTNS extends StatefulWidget {
  const FiltersBTNS({super.key});

  @override
  State<FiltersBTNS> createState() => _FiltersBTNSState();
}

class _FiltersBTNSState extends State<FiltersBTNS> {
  List filtersnames = ["Best seller","Books","Pens","Colors","Rollers","Note book"];
  String? selectedFilter;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filtersnames.map((filtername) {
          final isSelected = filtername == selectedFilter;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: TextButton(
              onPressed: () {
                setState(() {
                  selectedFilter = filtername;
                });
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                foregroundColor: isSelected ? const Color.fromARGB(255, 255, 255, 255) : const Color.fromARGB(255, 0, 0, 0),
                backgroundColor: isSelected ? const Color.fromARGB(255, 226, 133, 27) : const Color.fromARGB(188, 211, 211, 211),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
              child: Text(filtername),
            ),
          );
        }).toList(),
      ),
    );
  }
}