import 'package:flutter/material.dart';
import 'package:mktabte/core/comman/app_user/app_user_state.dart';
import 'package:mktabte/features/auth/data/_auth_service.dart';
import 'package:mktabte/features/auth/presentation/screens/forget_pass_screen.dart';
import 'package:mktabte/features/home/presentation/widgets/custom_txt_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/security_service.dart';
import '../../../../core/utils/banned_screen.dart';

import '../../../../core/comman/app_user/app_user_riverpod.dart';
import '../../../../core/comman/entitys/user_model.dart';
import '../../../../core/theme/text_style.dart';
import '../../../../core/utils/show_snack_bar.dart';
import '../../../home/presentation/widgets/custom_signup_btn.dart';
import '../../../home/presentation/widgets/custom_txt_btn.dart';
import '../../../home/presentation/widgets/custompass_txt_fiels.dart';
import '../../../home/presentation/widgets/mainbar.dart';
import '../riverpod/login_riverpod.dart';

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
  int _failedAttempts = 0;
  bool _isCheckingBan = true;
  bool _isBanned = false;

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
  void initState() {
    super.initState();
    _initializeSecurityChecks();
  }

  void _initializeSecurityChecks() async {
    // Request location permission early
    await SecurityService.requestLocationPermission();

    // Check IP ban status
    _checkIPBan();

    // Load failed attempts count
    _loadFailedAttempts();
  }

  void _checkIPBan() async {
    try {
      print('🚨 Login Screen: Starting IP ban check...');
      final isBanned = await SecurityService.isIPBanned();
      print('🚨 Login Screen: Ban check result: $isBanned');

      setState(() {
        _isBanned = isBanned;
        _isCheckingBan = false;
      });

      print(
          '🚨 Login Screen: State updated - isBanned: $_isBanned, isCheckingBan: $_isCheckingBan');
    } catch (e) {
      print('💥 Login Screen: Error checking IP ban status: $e');
      setState(() {
        _isBanned = false;
        _isCheckingBan = false;
      });
    }
  }

  void _loadFailedAttempts() async {
    final attempts = await SecurityService.getFailedAttemptsCount();
    setState(() {
      _failedAttempts = attempts;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(
        '🎨 Login Screen Build: isCheckingBan: $_isCheckingBan, isBanned: $_isBanned');

    // Show loading screen while checking ban status
    if (_isCheckingBan) {
      print('🎨 Showing loading screen...');
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Show banned screen if IP is banned
    if (_isBanned) {
      print('🚫 Showing banned screen...');
      return const BannedScreen();
    }

    print('✅ Showing login screen...');

    final appUserRiverpod = ref.read(appUserRiverpodProvider.notifier);

    ref.listen(loginControllerProvider, (previous, next) {
      if (next.isError()) {
        // Track failed login attempt
        SecurityService.trackFailedLogin(_emailController.text);
        _loadFailedAttempts(); // Update UI counter
        showSnackBar(context, next.error!);
      } else if (next.isSuccess()) {
        // Reset failed attempts on successful login
        SecurityService.resetFailedAttempts();
        setState(() {
          _failedAttempts = 0;
        });
        appUserRiverpod.getUser(_emailController.text);
      }
    });

    ref.listen(appUserRiverpodProvider, (previous, next) {
      print("AppUserState: ${next.state}"); // Debug print

      if (next.isGettedData()) {
        appUserRiverpod.saveUserData(next.user);
      }
      if (next.isFailureGetData()) {
        final user = UserModel(
          email: _emailController.text,
          password: _passController.text,
          name: _emailController.text,
        );
        appUserRiverpod.saveUserToSupabase(user);
      }
      if (next.isFailureSaveUserDataInSupabase()) {
        showSnackBar(context, next.errorMessage!);
      }
      if (next.isSaveUserDataInSupabase()) {
        appUserRiverpod.getUser(_emailController.text);
      }
      if (next.isSaveDataInLocalStorage()) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainBar()),
          );
        });
      }
      if (next.isError()) {
        showSnackBar(context, next.errorMessage!);
      }
    });

    final appUserState = ref.watch(appUserRiverpodProvider);
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
                if (_failedAttempts > 0)
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: _failedAttempts >= 8
                            ? Colors.red.shade100
                            : Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color:
                              _failedAttempts >= 8 ? Colors.red : Colors.orange,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        "Failed attempts: $_failedAttempts/10",
                        style: TextStyle(
                          color: _failedAttempts >= 8
                              ? Colors.red.shade700
                              : Colors.orange.shade700,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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
                    onFieldSubmitted: (_) {},
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
                      Navigator.pushReplacement(
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
                    btnName: state.isLoading() || appUserState.isLoading()
                        ? "Loading..."
                        : "Log in",
                    onPress: () {
                      if (state.isLoading() || appUserState.isLoading()) {
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
