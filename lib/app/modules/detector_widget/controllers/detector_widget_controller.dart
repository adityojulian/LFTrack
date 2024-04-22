import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

import 'package:ordinary/app/shared/theme.dart';
import 'package:ordinary/firebase_constants.dart';

class DetectorWidgetController extends GetxController {
  Timer? debounceTimer;
  final countdownSeconds = 3.obs; // Observable countdown seconds
  Timer? countdownTimer;
  final afterFinish = false.obs;
  // Set<String> scannedBarcodes = {};

  void startCountdown(
      String lftResult, String barcode, String confidence) async {
    // afterFinish.value = false;
    countdownTimer?.cancel(); // Cancel any existing timer
    countdownSeconds.value = 3; // Reset countdown
    countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (countdownSeconds.value > 0) {
        countdownSeconds.value--;
        checkDuplicate(barcode); // Function to run during countdown
        update(); // Trigger GetX state update
      } else {
        countdownTimer?.cancel();
        saveToDatabase(lftResult, barcode, confidence);
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

  void checkDuplicate(String barcode) async {
    // Check duplicate data to Firebase
    log("Function is being executed during countdown.");
    await firebaseFirestore
        .collection('users')
        .doc(auth.currentUser!.uid) // Ensure 'userId' is defined
        .collection('lftResults')
        .where('barcode', isEqualTo: barcode)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        // Duplicate found
        countdownTimer?.cancel(); // Stop the countdown
        openDuplicateDialog();
      }
    });
  }

  void saveToDatabase(
      String lftResult, String barcode, String confidence) async {
    // Assuming 'users' collection and each user has 'lftResults' collection
    log("barcode: ${barcode}");
    if (barcode.isEmpty) {
      noBarcodeDialog();
      return;
    }
    log("uid: ${auth.currentUser!.uid}");
    await firebaseFirestore
        .collection('users')
        .doc(auth.currentUser!.uid) // Ensure 'userId' is defined
        .collection('lftResults')
        .add({
          'lftResult': lftResult,
          'barcode': barcode,
          'confidence': confidence,
          'createdOn': Timestamp.now(),
        })
        .then((value) => openSuccessDialog())
        .catchError((error) => log('Failed to save LFT result: $error'));
  }

  void openSuccessDialog() {
    Future.delayed(const Duration(seconds: 1), () {
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
        content: Text(
            "This LFT has been scanned before. Please try another one",
            style: medium),
        actions: <Widget>[
          TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text("Close", style: regular))
        ],
      ),
    );
  }

  void noBarcodeDialog() {
    Get.dialog(
      AlertDialog(
        content: Text(
            "LFT detected with no barcode. Please make sure the barcode is visible",
            style: medium),
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

  // Future<bool> isBarcodeScanned(String barcode) async {
  //   // currentBarcode = barcode;
  //   return scannedBarcodes.contains(barcode);
  // }

  @override
  void onClose() {
    debounceTimer?.cancel();
    countdownTimer?.cancel();
    super.onClose();
  }
}
