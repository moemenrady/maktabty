import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/text_style.dart';

List<String> region = [
  'Nasr City',
  'Maadi',
  'Heliopolis',
  'Downtown',
  'Zamalek',
  '6th of October',
  'New Cairo',
  'Dokki',
  'Mohandessin',
  'Giza',
];
List<String> detailedAddress = [
  'Address 1',
  'Address 2',
  'Address 3',
  'Address 4',
  'Address 5',
  'Address 6',
  'Address 7',
  'Address 8',
  'Address 9',
  'Address 10',
];

class UserAllAddresses extends StatefulWidget {
  const UserAllAddresses({super.key});

  @override
  State<UserAllAddresses> createState() => _UserAllAddressesState();
}

class _UserAllAddressesState extends State<UserAllAddresses> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        height: 500.h,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "All Addresses",
                  style: TextStyles.blinker20SemiBoldBlack,
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const Divider(thickness: 1, color: Colors.grey),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: region.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.pop(
                        context,
                        {
                          'region': region[index],
                          'address': detailedAddress[index],
                        },
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          region[index],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          detailedAddress[index],
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const Divider(color: Color(0xFFCACACA), thickness: 1),
                      ],
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
