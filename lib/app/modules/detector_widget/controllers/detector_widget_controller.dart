import 'dart:developer';

import 'package:get/get.dart';
import 'dart:async';

class DetectorWidgetController extends GetxController {
  Timer? debounceTimer;
  final countdownSeconds = 3.obs; // Observable countdown seconds
  Timer? countdownTimer;
  final afterFinish = false.obs;

  void delayStart() {
    debounceTimer?.cancel();
    debounceTimer = Timer(const Duration(milliseconds: 0), () {
      if (countdownTimer == null || !countdownTimer!.isActive) {
        startCountdown();
      }
      update();
    });
  }

  void startCountdown() {
    // afterFinish.value = false;
    countdownTimer?.cancel(); // Cancel any existing timer
    countdownSeconds.value = 3; // Reset countdown
    countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (countdownSeconds.value > 0) {
        countdownSeconds.value--;
        checkDuplicate(); // Function to run during countdown
        update(); // Trigger GetX state update
      } else {
        countdownTimer?.cancel();
        saveToDatabase();
        afterFinish.value = true;
        // update(); // Trigger GetX state update
      }
      update();
    });
  }

  void resetCountdown() {
    countdownTimer?.cancel();
    countdownSeconds.value = 3;
    afterFinish.value = false;
    update(); // Reset to initial value
  }

  void checkDuplicate() {
    // Check duplicate data to Firebase
    log("Function is being executed during countdown.");
  }

  void saveToDatabase() {
    // Save result to Firebase
    log("Function is being executed after countdown.");
  }

  @override
  void onClose() {
    debounceTimer?.cancel();
    countdownTimer?.cancel();
    super.onClose();
  }
}
