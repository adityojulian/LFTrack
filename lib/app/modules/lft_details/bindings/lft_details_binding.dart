import 'package:get/get.dart';

import '../controllers/lft_details_controller.dart';

class LftDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LftDetailsController>(
      () => LftDetailsController(),
    );
  }
}
