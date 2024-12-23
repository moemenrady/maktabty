import 'package:flutter/material.dart';
import 'package:mktabte/features/auth/presentation/screens/forget_pass_screen.dart';
import 'package:mktabte/features/auth/presentation/screens/signup_screen.dart';
import 'package:mktabte/features/home/presentation/widgets/custom_txt_field.dart';

import '../../../../core/theme/text_style.dart';
import '../../../home/presentation/widgets/custom_signup_btn.dart';
import '../../../home/presentation/widgets/custom_txt_btn.dart';
import '../../../home/presentation/widgets/custompass_txt_fiels.dart';
import '../../../home/presentation/widgets/mainbar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  TextEditingController Pass = TextEditingController();
  TextEditingController email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 70,),
            Center(
              child: Text(
                "Log in",
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
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                "Email:",
                style: TextStyles.Lato14extraBoldBlack,
              ),
            ),

            Center(child: CustomTextField(hinttxt: "Enter your email", mycontroller: email)),
            const SizedBox(height: 30),
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
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ForgetPassScreen(),
                      ),
                    );},
                child: Text(
                  "Forgot password?",
                  style: TextStyles.Lato12extraBoldBlack,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: CustomTxtBtn(txtstyle: TextStyles.Lato16extraBoldBlack,btnWidth: 327,btnHeight: 48,
              btnradious: 15,
              bgclr: Color(0xFFF68B3B),
                btnName: "Log in",
                onPress: () {
                  if (email.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Email can't be empty."),
                      ),
                    );
                  } else if (Pass.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Password can't be empty."),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MainBar(),
                      ),
                    );
                  }
                },
              ),
            ),
            SizedBox(height: 20,),
            CustomSignupBtn(),
          ],
        ),
      ),
    );
  }
}
