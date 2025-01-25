import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mktabte/core/comman/entitys/categories.dart';
import 'package:mktabte/features/auth/presentation/screens/onboarding.dart';
import 'package:mktabte/features/check_out/presentation/screen/cart_page.dart';
import 'package:mktabte/features/home/presentation/screens/cartscreen.dart';
import 'package:mktabte/features/home/presentation/screens/home.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/utils/custom_error_screen.dart';
import 'features/admin/presentation/screens/add_items.dart';
import 'features/admin/presentation/screens/admin_control_user_orders.dart';
import 'features/admin/presentation/screens/item_page.dart';
import 'features/admin/presentation/screens/view_orders_summary.dart';
import 'features/check_out/presentation/screen/product_details_creen.dart';
import 'features/home/presentation/screens/allcategriesscreen.dart';
import 'features/home/presentation/screens/category.dart';
import 'features/home/presentation/screens/userwishlistscreen.dart';
import 'features/orders/presentation/screens/user_orders_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://gwzvpnetxlpqpjsemttw.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imd3enZwbmV0eGxwcXBqc2VtdHR3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzE1NDMyNDMsImV4cCI6MjA0NzExOTI0M30.M_gXPVEvhH0z69l1VxMt7VwuybOZqQ2gAAnHC1ZMBn0',
  );

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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
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
          home: const AdminControlUserOrders(),
        );
      },
    );
  }
}
