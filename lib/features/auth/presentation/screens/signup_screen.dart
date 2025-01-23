import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:mktabte/features/auth/presentation/screens/login.dart';
import 'package:mktabte/features/home/presentation/widgets/mainbar.dart';
import 'package:riverpod/src/framework.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/theme/text_style.dart';
import '../../../home/presentation/widgets/custom_txt_btn.dart';
import '../../../home/presentation/widgets/custom_txt_field.dart';
import '../../../home/presentation/widgets/custompass_txt_fiels.dart';
import '../../data/_auth_service.dart';
import '../riverpod/login_state.dart';

final supabase = Supabase.instance.client;

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
    final authservice = AuthService();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _confirmpassController = TextEditingController();

  void signupFUN() async {
    final email = _emailController.text;
    final pass = _passController.text;
    final name = _nameController.text;
    try {
      await authservice.signupWithEmailPass(email, pass, name);
      // After successful signup, log in the user
      context.read(loginStateProvider.notifier).logIn();

      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MainBar(),
                        ),
                      );
    }
    catch (e) {
      if (e is AuthException) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Authentication Error: ${e.message}')));
} else {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
}

    }
  }

  String? _validateField(String value, String fieldName) {
    if (value.isEmpty) {
      return "$fieldName can't be empty.";
    }
    return null;
  }

  String? _validatePasswordMatch() {
    if (_passController.text != _confirmpassController.text) {
      return "Passwords do not match.";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // Use context.watch() to listen to changes in the login state
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
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
            const Spacer(),
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
                mycontroller: _nameController,
              ),
            ),
            const SizedBox(
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
                hinttxt: 'Enter your Email',
                mycontroller: _emailController,
              ),
            ),
            const SizedBox(
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
                mycontroller: _passController,
              ),
            ),
            const SizedBox(
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
                mycontroller: _confirmpassController,
              ),
            ),
            const Spacer(),
            Center(
              child: CustomTxtBtn(
                  txtstyle: TextStyles.Lato16extraBoldBlack,
                  bgclr: const Color(0xFFF68B3B),
                  btnWidth: 327,
                  btnHeight: 48,
                  btnradious: 10,
                  onPress: () {
                    final name = _nameController.text;
                    final email = _emailController.text;
                    final password = _passController.text;

                    // Validation checks
                    final nameError = _validateField(name, "Name");
                    final emailError = _validateField(email, "Email");
                    final passwordError = _validateField(password, "Password");
                    final confirmPasswordError = _validatePasswordMatch();

                    if (nameError != null) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(nameError)));
                    } else if (emailError != null) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(emailError)));
                    } else if (passwordError != null) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(passwordError)));
                    } else if (confirmPasswordError != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(confirmPasswordError)));
                    } else {
                      signupFUN();
                    }
                  },
                  btnName: "Sign up"),
            ),
            const SizedBox(
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
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    },
                    child: Text(
                      " Log in",
                      style: TextStyles.Lato16extraBoldBlack,
                    ))
              ],
            ),
            const SizedBox(
              height: 40,
            )
          ],
        ),
      ),
    );
  }
}

extension on BuildContext {
  read(AlwaysAliveRefreshable<LoginStateNotifier> notifier) {}
}
