import 'package:get/get.dart';
import 'package:ordinary/app/modules/history/controllers/history_controller.dart';
import 'package:ordinary/app/modules/settings/controllers/settings_controller.dart';

import '../controllers/bottom_nav_bar_controller.dart';

class BottomNavBarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BottomNavBarController>(
      () => BottomNavBarController(),
    );
    Get.lazyPut<HistoryController>(
      () => HistoryController(),
    );
    Get.lazyPut<SettingsController>(
      () => SettingsController(),
    );
  }
}
