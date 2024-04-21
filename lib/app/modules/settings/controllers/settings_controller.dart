import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ordinary/firebase_constants.dart';

class SettingsController extends GetxController {
  var isDarkMode = false.obs;
  late String? email;

  @override
  void onInit() {
    super.onInit();
    isDarkMode.value = Get.isDarkMode;
    email = auth.currentUser!.email;
  }

  void switchTheme() {
    isDarkMode.value = !isDarkMode.value;
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  void signOut() {
    try {
      auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}
