import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

import 'package:ordinary/app/shared/theme.dart';

class DetectorWidgetController extends GetxController {
  Timer? debounceTimer;
  final countdownSeconds = 3.obs; // Observable countdown seconds
  Timer? countdownTimer;
  final afterFinish = false.obs;
  Set<String> scannedBarcodes = {};
  // String? currentBarcode;

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
        // update(); // Trigger GetX state update
      } else {
        countdownTimer?.cancel();
        saveToDatabase();
        afterFinish.value = true;
        // update(); // Trigger GetX state update
      }
      update(); // Trigger GetX state update
    });
  }

  void resetCountdown() {
    countdownTimer?.cancel();
    // countdownSeconds.value = 3;
    afterFinish.value = false;
    update(); // Reset to initial value
  }

  void checkDuplicate() {
    // Check duplicate data to Firebase
    log("Function is being executed during countdown.");
  }

  void saveToDatabase() {
    // Save result to Firebase
    // scannedBarcodes.add(barcode);
    openSucessDialog();
    log("Function is being executed after countdown.");
  }

  void openSucessDialog() {
    Future.delayed(const Duration(seconds: 3), () {
      Get.back();
    });

    Get.dialog(AlertDialog(
      content:
          Text("The LFT scan result has been saved to database", style: medium),
    ));
  }

  void openDuplicateDialog() {
    Get.dialog(
      AlertDialog(
        content: Text("The LFT scan result is a duplicate", style: medium),
        actions: <Widget>[
          TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text("Close"))
        ],
      ),
    );
  }

  // Barcode Controller for Databse Check and Duplicate Logic

  Future<bool> isBarcodeScanned(String barcode) async {
    // currentBarcode = barcode;
    return scannedBarcodes.contains(barcode);
  }

  @override
  void onClose() {
    debounceTimer?.cancel();
    countdownTimer?.cancel();
    super.onClose();
  }
}
