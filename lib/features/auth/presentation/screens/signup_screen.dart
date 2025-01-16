import 'package:flutter/material.dart';
import 'package:mktabte/features/auth/presentation/screens/login.dart';
import 'package:mktabte/features/home/presentation/widgets/mainbar.dart';

import '../../../../core/theme/text_style.dart';
import '../../../home/presentation/widgets/custom_txt_btn.dart';
import '../../../home/presentation/widgets/custom_txt_field.dart';
import '../../../home/presentation/widgets/custompass_txt_fiels.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController Name = TextEditingController();
  TextEditingController Email = TextEditingController();
  TextEditingController Pass = TextEditingController();
  TextEditingController ConfirmPass = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 70,
            ),
            Center(
              child: Text(
                "Signup",
                style: TextStyles.Lato16extraBoldBlack,
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Image.asset(
                "assets/images/login_img.png",
                height: 150,
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                "Name:",
                style: TextStyles.Lato14extraBoldBlack,
              ),
            ),
            Center(
              child: CustomTextField(
                hinttxt: 'Enter Your Full Name',
                mycontroller: Name,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                "Email:",
                style: TextStyles.Lato14extraBoldBlack,
              ),
            ),
            Center(
              child: CustomTextField(
                hinttxt: 'Enter your email',
                mycontroller: Email,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                "Password:",
                style: TextStyles.Lato14extraBoldBlack,
              ),
            ),
            Center(
              child: CustompassTxtFiels(
                hinttxt: "Enter your password",
                mycontroller: Pass,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                "Confirm Password:",
                style: TextStyles.Lato14extraBoldBlack,
              ),
            ),
            Center(
              child: CustompassTxtFiels(
                hinttxt: "Confirm password",
                mycontroller: ConfirmPass,
              ),
            ),
            Spacer(),
            Center(
              child: CustomTxtBtn(
                  txtstyle: TextStyles.Lato16extraBoldBlack,
                  bgclr: Color(0xFFF68B3B),
                  btnWidth: 327,
                  btnHeight: 48,
                  btnradious: 10,
                  onPress: () {
                    if (Name.text == "") {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Name can't be empty.")));
                      return;
                    } else if (Email.text == "") {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Email can't be empty.")));
                      return;
                    } else if (Pass.text == "") {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Password can't be empty.")));
                      return;
                    } else if (ConfirmPass.text == "") {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Confirm Password can't be empty.")));
                      return;
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MainBar(),
                        ),
                      );
                    }
                    ;
                  },
                  btnName: "Sign up"),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "already have an account?",
                  style: TextStyle(fontSize: 18, fontFamily: "Inter"),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ),
                      );
                    },
                    child: Text(
                      " Log in",
                      style: TextStyles.Lato16extraBoldBlack,
                    ))
              ],
            ),
            SizedBox(
              height: 40,
            )
          ],
        ),
      ),
    );
  }
}
