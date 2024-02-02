import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ordinary/global_bindings.dart';
// import 'package:ordinary/views/camera_screen.dart';
import 'package:ordinary/views/camera_view.dart';

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
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CameraView(),
      initialBinding: GlobalBindings(),
    );
  }
}
