import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ordinary/app/modules/login/controllers/login_controller.dart';
import 'package:ordinary/app/shared/theme.dart';
// import 'package:ordinary/global_bindings.dart';
// import 'package:ordinary/views/camera_screen.dart';
// import 'package:ordinary/views/camera_view.dart';
import 'app/routes/app_pages.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((value) => Get.put(LoginController()));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LFTrack',
      theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: ColorSeed.baseColor.color,
          brightness: Brightness.light),
      darkTheme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: ColorSeed.baseColor.color,
          brightness: Brightness.dark),
      themeMode: ThemeMode.system,
      initialRoute: Routes.SPLASH_SCREEN,
      getPages: AppPages.routes,
    );
  }
}
