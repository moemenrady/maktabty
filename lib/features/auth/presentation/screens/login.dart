import 'package:flutter/material.dart';
import 'package:mktabte/features/auth/data/_auth_service.dart';
import 'package:mktabte/features/auth/presentation/screens/forget_pass_screen.dart';
import 'package:mktabte/features/auth/presentation/screens/signup_screen.dart';
import 'package:mktabte/features/home/presentation/widgets/custom_txt_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/text_style.dart';
import '../../../../core/utils/show_snack_bar.dart';
import '../../../home/presentation/widgets/custom_signup_btn.dart';
import '../../../home/presentation/widgets/custom_txt_btn.dart';
import '../../../home/presentation/widgets/custompass_txt_fiels.dart';
import '../../../home/presentation/widgets/mainbar.dart';
import '../riverpod/login_riverpod.dart';
import '../riverpod/login_state.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginState();
}

class _LoginState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final authservice = AuthService();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _focusNode = FocusNode();

  void _login() {
    FocusScope.of(context).unfocus();

    if (_validateFields()) {
      ref.read(loginControllerProvider.notifier).loginWithEmail(
            email: _emailController.text,
            password: _passController.text,
          );
    }
  }

  bool _validateFields() {
    if (_emailController.text.isEmpty) {
      showSnackBar(context, 'Please enter your email');
      return false;
    }
    if (_passController.text.isEmpty) {
      showSnackBar(context, 'Please enter your password');
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(loginControllerProvider, (previous, next) {
      if (next.isError()) {
        showSnackBar(context, next.error!);
      } else if (next.isSuccess()) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainBar()),
        );
      }
    });

    final state = ref.watch(loginControllerProvider);

    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
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
                    mycontroller: _emailController,
                    onFieldSubmitted: (_) => _focusNode.requestFocus(),
                    textInputAction: TextInputAction.next,
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    "Password:",
                    style: TextStyles.Lato14extraBoldBlack,
                  ),
                ),
                Center(
                  child: CustompassTxtField(
                    hinttxt: "Enter your password",
                    mycontroller: _passController,
                    focusNode: _focusNode,
                    onFieldSubmitted: (_) => _login(),
                    textInputAction: TextInputAction.done,
                    obscureText: !state.isPasswordVisible,
                    onToggleVisibility: () {
                      ref
                          .read(loginControllerProvider.notifier)
                          .togglePasswordVisibility();
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ForgetPassScreen(),
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
                    bgclr: const Color(0xFFF68B3B),
                    btnName: state.isLoading() ? "Loading..." : "Log in",
                    onPress: () {
                      if (state.isLoading()) {
                        return;
                      }
                      _login();
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const CustomSignupBtn(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}
