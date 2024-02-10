import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ordinary/app/routes/app_pages.dart';

import '../controllers/splash_screen_controller.dart';

class SplashScreenView extends GetView<SplashScreenController> {
  const SplashScreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), (() {
      Get.offAllNamed(Routes.ONBOARDING);
    }));
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
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
        Center(
          child: Container(
            width: Get.width / 1.5,
            // height: 300,
            // margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.1),
                shape: BoxShape.circle),
          ),
        ),
        Center(
          child: Container(
            // height: 250,
            width: Get.width / 1.8,
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .primaryContainer
                  .withOpacity(0.1),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Center(
          child: Container(
            width: 100,
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
