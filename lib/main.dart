import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_hungry_hub/firebase_options.dart';
import 'package:flutter_hungry_hub/view/main_logo_app_view.dart';
import 'package:flutter_hungry_hub/view/main_nav_view.dart';
import 'package:flutter_hungry_hub/widgets/common_widget/google_map/MapScreen.dart';
import 'package:flutter_hungry_hub/widgets/common_widget/google_map/access_location.dart';
import 'package:get/get.dart';

import 'view/test_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: const MainNavView(initialIndex: 0),
      home: const MainLogoAppView(),
      // home: const AccessLocation(),
      // home:  RouteScreen(),
    );
  }
}
