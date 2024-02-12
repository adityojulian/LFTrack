import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ordinary/app/shared/theme.dart';
// import 'package:ordinary/global_bindings.dart';
// import 'package:ordinary/views/camera_screen.dart';
// import 'package:ordinary/views/camera_view.dart';
import 'app/routes/app_pages.dart';

void main() {
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
      themeMode: ThemeMode.light,
      initialRoute: Routes.BOTTOM_NAV_BAR,
      getPages: AppPages.routes,
    );
  }
}
