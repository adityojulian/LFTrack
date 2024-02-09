import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/splash_screen_controller.dart';

class SplashScreenView extends GetView<SplashScreenController> {
  const SplashScreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Stack(children: [
        Container(
          margin: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
              color: Colors.white10, shape: BoxShape.circle),
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
