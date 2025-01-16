import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mktabte/features/auth/presentation/screens/login.dart';

import '../../../../core/theme/text_style.dart';
import '../widgets/custom_guest_profile_buttons.dart';
import '../widgets/custom_signup_btn.dart';
import '../widgets/custom_txt_btn.dart';

class GuestProfileScreen extends StatelessWidget {
  const GuestProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Profile",
              style: TextStyles.Lato20boldBlack,
            ),
            SizedBox(
              height: 15.h,
            ),
            Text(
              "Log in to start and explore your personalized shopping experience.",
              style: TextStyles.Lato16regularlightBlack,
            ),
            SizedBox(
              height: 20.h,
            ),
            Center(
              child: CustomTxtBtn(
                txtstyle: TextStyles.Lato16boldBlack,
                bgclr: Color(0xFFFF9E56),
                btnHeight: 48,
                btnWidth: 327,
                btnName: "Login",
                btnradious: 20,
                onPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 30.h,
            ),
            CustomSignupBtn(),
            SizedBox(
              height: 30.h,
            ),
            CustomGuestProfileButtons()
          ],
        ),
      ),
    );
  }
}
