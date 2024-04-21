import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {
  //TODO: Implement OnboardingController
  PageController indicator = PageController();

  RxInt page = 0.obs;

  void changePage(value) {
    page.value = value;
    update();
  }

  @override
  void dispose() {
    indicator.dispose();
    super.dispose();
  }
}
