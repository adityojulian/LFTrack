import 'package:get/get.dart';
import 'package:ordinary/controller/scan_controller.dart';
// import 'package:ordinary/controller/scan_controller_copy.dart';

// class GlobalBindings extends Bindings {
//   @override
//   void dependencies() {
//     Get.lazyPut<ScanControllerCopy>(() => ScanControllerCopy());
//   }
// }

class GlobalBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ScanController>(() => ScanController());
  }
}
