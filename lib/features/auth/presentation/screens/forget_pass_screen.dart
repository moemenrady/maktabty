import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mktabte/features/auth/presentation/screens/otp_verification_page.dart';
import 'package:mktabte/features/home/presentation/widgets/custom_app_bar.dart';
import 'package:mktabte/main.dart';

import '../../../../core/theme/text_style.dart';
import '../../../home/presentation/widgets/custom_txt_btn.dart';
import '../../../home/presentation/widgets/custom_txt_field.dart';

class ForgetPassScreen extends StatelessWidget {
  const ForgetPassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController phNum = TextEditingController();

    return Scaffold(
      //appBar: 
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomAppBar(txt: '', hasArrow: true, hasIcons: false),
            SizedBox(
              height: 70.h,
            ),
            Text(
              "Forgot Password",
              style: TextStyles.Inter28SemiBoldBlack,
            ),
            const SizedBox(height: 40),
            Image.asset(
              "assets/images/forget_pass_img.png",
              height: 166.h,
              width: 225.w,
            ),
            const SizedBox(height: 70),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                    "Phone Number:",
                    style: TextStyles.Lato14extraBoldBlack,
                  ),
              ),
            ),
            CustomTextField(
                hinttxt: "Enter your Phone Number", mycontroller: phNum),
            const SizedBox(height: 70),
            CustomTxtBtn(txtstyle: TextStyles.Lato16extraBoldBlack,
              bgclr: const Color(0xFFF39754),btnHeight: 60,btnWidth: 345,btnradious: 14,
              btnName: "Continue",
              onPress: () {
                if (phNum.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Phone Number can't be empty."),
                    ),
                  );
                } 
                else if(phNum.text.length!=11){
                   ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Phone Number should be 11 number."),
                    ),
                  );
                }
                else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OTPVerificationPage(
                        phone: phNum.text,
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
