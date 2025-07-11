import 'package:atd/core/database/database_helper.dart';
import 'package:atd/features/home_navigation_feature/display/pages/home_screen.dart';
import 'package:atd/features/image_upload_feature/display/providers/image_upload_provider.dart';
import 'package:atd/features/login_feature/display/pages/login_screen.dart';
import 'package:atd/features/login_feature/display/pages/splash_screen.dart';
import 'package:atd/features/routine_feature/display/pages/dashboard_screen.dart';
import 'package:atd/features/vehicle_readings_feature/display/providers/vehicle_details_provider.dart';
import 'package:atd/providers/stock_in_list_provider.dart';
import 'package:atd/providers/stock_out_list_provider.dart';
import 'package:atd/providers/stock_transfer_navigation_provider.dart';
import 'package:atd/utils/network_checker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:atd/utils/utils_export.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'utils/widgets/provider_export.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance(); // Ensure it initializes correctly

  await DatabaseHelper().init();
  // NetworkChecker().initialize(navigatorKey);
  //final BackgroundService backgroundService = BackgroundServiceImpl();
  //await backgroundService.init();
  // await BackgroundService().initializeService();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => DrawerNavigationProvider()),
        ChangeNotifierProvider(create: (context) => VehicleChecksProvider()),
        ChangeNotifierProvider(create: (context) => DispenserChecksProvider()),
        ChangeNotifierProvider(create: (context) => RoutinesProvider()),
        ChangeNotifierProvider(
            create: (context) => DispenserPageNavigationProvider()),
        ChangeNotifierProvider(create: (context) => DispenserReportsProvider()),
        ChangeNotifierProvider(
            create: (context) => StockTransferNavigationProvider()),
        ChangeNotifierProvider(create: (context) => StockInListProvider()),
        ChangeNotifierProvider(create: (context) => StockOutListProvider()),
        ChangeNotifierProvider(create: (context) => LoginProvider()),
        ChangeNotifierProvider(create: (context) => ImageUploadProvider()),
        ChangeNotifierProvider(create: (context) => VehicleReadingsProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    return GetMaterialApp(
      // navigatorKey: navigatorKey,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/dashboard': (context) => const HomeScreen(),
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          appBarTheme: const AppBarTheme(color: secondary500),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: secondary500),
          primarySwatch: Colors.blueGrey,
          fontFamily: GoogleFonts.poppins().fontFamily,
          progressIndicatorTheme:
              const ProgressIndicatorThemeData(color: primary500),
          textTheme:
              const TextTheme(subtitle2: TextStyle(color: Colors.black38))),
    );
  }
}
