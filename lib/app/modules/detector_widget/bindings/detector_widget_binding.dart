import 'package:get/get.dart';

import '../controllers/detector_widget_controller.dart';

class DetectorWidgetBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetectorWidgetController>(
      () => DetectorWidgetController(),
    );
  }
}
