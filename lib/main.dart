import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/io_client.dart';
import 'package:jailbreak_root_detection/jailbreak_root_detection.dart';
import 'package:mktabte/core/comman/app_user/app_user_state.dart';
import 'package:mktabte/features/auth/presentation/screens/onboarding.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/comman/app_user/app_user_riverpod.dart';
import 'core/utils/custom_error_screen.dart';

import 'features/auth/presentation/screens/login.dart';

import 'features/home/presentation/widgets/mainbar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  PaintingBinding.instance.imageCache.maximumSize = 1000;

  final context = SecurityContext(withTrustedRoots: false);

  final certData = await rootBundle.load('assets/images/supabase.co.pem');
  context.setTrustedCertificatesBytes(certData.buffer.asUint8List());

  final httpClient = HttpClient(context: context);
  final ioClient = IOClient(httpClient);

  await Supabase.initialize(
    url: 'https://gwzvpnetxlpqpjsemttw.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imd3enZwbmV0eGxwcXBqc2VtdHR3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzE1NDMyNDMsImV4cCI6MjA0NzExOTI0M30.M_gXPVEvhH0z69l1VxMt7VwuybOZqQ2gAAnHC1ZMBn0',
    httpClient: ioClient,
  );

  final isNotTrust = await JailbreakRootDetection.instance.isNotTrust;
  final isJailBroken = await JailbreakRootDetection.instance.isJailBroken;
  final isRealDevice = await JailbreakRootDetection.instance.isRealDevice;
  final isOnExternalStorage =
      await JailbreakRootDetection.instance.isOnExternalStorage;
  final checkForIssues = await JailbreakRootDetection.instance.checkForIssues;
  final isDevMode = await JailbreakRootDetection.instance.isDevMode;

  print("isNotTrust: $isNotTrust");
  print("isJailBroken: $isJailBroken");
  print("isRealDevice: $isRealDevice");
  print("isOnExternalStorage: $isOnExternalStorage");
  print("checkForIssues: $checkForIssues");
  print("isDevMode: $isDevMode");

  await ScreenUtil.ensureScreenSize();

  customErorrScreen();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);

  runApp(
    ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return const ProviderScope(child: MyApp());
      },
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  late bool isNotTrust;
  late bool isJailBroken;
  late bool isRealDevice;
  late bool isOnExternalStorage;
  late List<JailbreakIssue> checkForIssues;
  late bool isDevMode;

  Future<void> _checkJailbreak() async {
    isNotTrust = await JailbreakRootDetection.instance.isNotTrust;
    isJailBroken = await JailbreakRootDetection.instance.isJailBroken;
    isRealDevice = await JailbreakRootDetection.instance.isRealDevice;
    isOnExternalStorage =
        await JailbreakRootDetection.instance.isOnExternalStorage;
    checkForIssues = await JailbreakRootDetection.instance.checkForIssues;
    isDevMode = await JailbreakRootDetection.instance.isDevMode;
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _checkJailbreak();
      ref.read(appUserRiverpodProvider.notifier).isFirstInstallation();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appUserRiverpodProvider);
    final appUserRiverpod = ref.read(appUserRiverpodProvider.notifier);
    // Add listener for debugging
    ref.listen(appUserRiverpodProvider, (previous, next) {
      print('AppUserState changed from ${previous?.state} to ${next.state}');
      if (next.user != null) {
        print('User: ${next.user!.email}');
      }
      if (next.isInstalled()) {
        appUserRiverpod.isUserLoggedIn();
      }
    });

    return ScreenUtilInit(
      designSize: const Size(390, 849),
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              elevation: 0,
            ),
            useMaterial3: true,
          ),
          home: isNotTrust ||
                  isJailBroken ||
                  isRealDevice ||
                  isOnExternalStorage ||
                  checkForIssues.isNotEmpty ||
                  isDevMode
              ? const Scaffold(
                  body: Center(
                    child: Text('App Locked For Security Reasons'),
                  ),
                )
              : state.isNotInstalled()
                  ? const Onboard()
                  : state.isGettedDataFromLocalStorage() ||
                          state.isUpdateUserData()
                      ? const MainBar()
                      : const LoginPage(),
        );
      },
    );
  }
}
