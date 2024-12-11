import 'package:flutter/material.dart';

import '../../../../core/functions/navigate.dart';
import '../../../home/presentation/widgets/mainbar.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return TextButton(onPressed: (){NavigateFN(context, () => const MainBar());}, child: const Text("Login"));
  }
}