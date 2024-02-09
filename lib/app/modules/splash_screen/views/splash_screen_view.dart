import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/splash_screen_controller.dart';

class SplashScreenView extends GetView<SplashScreenController> {
  const SplashScreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      // appBar: AppBar(
      //   actions: [
      //     Switch(
      //       // value: controller.currentTheme.value == ThemeMode.dark,
      //       value: Get.isDarkMode,
      //       onChanged: (value) {
      //         // controller.switchTheme();
      //         // Get.changeThemeMode(controller.currentTheme.value);
      //         Get.changeThemeMode(
      //           Get.isDarkMode ? ThemeMode.light : ThemeMode.dark,
      //         );
      //       },
      //     ),
      //   ],
      // ),
      body: Stack(children: [
        Container(
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.5),
              shape: BoxShape.circle),
        ),
        Center(
          child: Container(
            width: Get.width / 3,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/icons/flutter.png"), scale: 0.2),
            ),
          ),
        )
      ]),
    );
  }
}
