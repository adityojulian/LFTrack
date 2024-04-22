import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {
  //TODO: Implement OnboardingController
  @override
  void onInit() {
    super.onInit();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  PageController indicator = PageController();

  RxInt page = 0.obs;

  void changePage(value) {
    page.value = value;
    update();
  }

  // @override
  // void dispose() {
  //       super.dispose();
  // }

  @override
  void onClose() {
    indicator.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    // emailController.text = "";
    // passwordController.text = "";
    // emailController.dispose();
    // passwordController.dispose();
    super.onClose();
  }
}
