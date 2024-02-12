import 'package:get/get.dart';

class BottomNavBarController extends GetxController {
  //TODO: Implement BottomNavBarController

  RxInt currentIndex = 0.obs;

  setPage(index) {
    currentIndex.value = index;
    update();
  }

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
}
