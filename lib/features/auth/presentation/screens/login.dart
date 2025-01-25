import 'package:flutter/material.dart';
import 'package:mktabte/features/auth/data/_auth_service.dart';
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
  final authservice = AuthService();
  TextEditingController _passController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  String? _validateField(String value, String fieldName) {
    if (value.isEmpty) {
      return "$fieldName can't be empty.";
    }
    return null;
  }

  void loginFUN() async {
    final email = _emailController.text;
    final pass = _passController.text;
    try {
      await authservice.signinWithEmailPass(email, pass);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const MainBar(),
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

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
            Center(
                child: CustomTextField(
                    hinttxt: "Enter your Email",
                    mycontroller: _emailController)),
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
                mycontroller: _passController,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ForgetPassScreen(),
                    ),
                  );
                },
                child: Text(
                  "Forgot password?",
                  style: TextStyles.Lato12extraBoldBlack,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: CustomTxtBtn(
                txtstyle: TextStyles.Lato16extraBoldBlack,
                btnWidth: 327,
                btnHeight: 48,
                btnradious: 15,
                bgclr: Color(0xFFF68B3B),
                btnName: "Log in",
                onPress: () {
                  final email = _emailController.text;
                  final password = _passController.text;

                  // Validation checks
                  final emailError = _validateField(email, "Email");
                  final passwordError = _validateField(password, "Password");

                  if (emailError != null) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(emailError)));
                  } else if (passwordError != null) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(passwordError)));
                  } else {
                    loginFUN();
                  }
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            CustomSignupBtn(),
          ],
        ),
      ),
    );
  }
}
