import 'package:get/get.dart';

import '../controllers/placeholder_controller.dart';

class PlaceholderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlaceholderController>(
      () => PlaceholderController(),
    );
  }
}
