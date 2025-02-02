import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/text_style.dart';
import '../../../auth/presentation/screens/login.dart';
import 'custom_txt_btn.dart';

class CustomGuestWishlistCard extends StatelessWidget {
  const CustomGuestWishlistCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 20,
      child: Padding(
        padding: const EdgeInsets.all(22.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/guest_wish_img.png",
              width: 82.w,
              height: 64.h,
            ),
            SizedBox(
              height: 5.h,
            ),
            Text(
              "You will not be able to save products.",
              style: TextStyles.Lato20boldBlack,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 7.h,
            ),
            Text(
              "You will not be able to save products. until you login. Resgister now to be able to save you favorits.",
              maxLines: 3,
              textAlign: TextAlign.center,
              style: TextStyles.Lato16mediumlightBlack,
            ),
            const Spacer(),
            CustomTxtBtn(
              txtstyle: TextStyles.Lato16boldBlack,
              bgclr: const Color(0xFFFF9E56),
              btnHeight: 48,
              btnWidth: 327,
              btnName: "Login now",
              btnradious: 20,
              onPress: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
