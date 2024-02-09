import 'package:get/get.dart';

class SplashScreenController extends GetxController {
  //TODO: Implement SplashScreenController

  // Rx<ThemeMode> currentTheme =
  //     SchedulerBinding.instance.platformDispatcher.platformBrightness ==
  //             Brightness.light
  //         ? ThemeMode.light.obs
  //         : ThemeMode.dark.obs;

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
