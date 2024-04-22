import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ordinary/app/shared/theme.dart';
import 'package:ordinary/firebase_constants.dart';

import '../../../models/lft_result.dart';

class LftDetailsController extends GetxController {
  late Rx<LFTResult> currentResult = LFTResult().obs;
  LFTResult? originalResult;

  void loadEditableCopy(LFTResult result) {
    // Clone the passed result to a new object so that changes are not reflected outside unless saved.
    originalResult = LFTResult(
        documentId: result.documentId,
        createdOn: result.createdOn,
        barcode: result.barcode,
        lftResult: result.lftResult,
        confidence: result.confidence);
    currentResult.value = LFTResult(
        documentId: result.documentId,
        createdOn: result.createdOn,
        barcode: result.barcode,
        lftResult: result.lftResult,
        confidence: result.confidence);
  }

  void showSaveConfirmationDialog(context) {
    var stye = Theme.of(context).colorScheme;
    Get.dialog(
      AlertDialog(
        title: Text('Confirm Save', style: bold),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Please review the changes:', style: medium),
              SizedBox(height: 10),
              RichText(
                text: TextSpan(
                  style:
                      regular.copyWith(fontSize: 16, color: stye.onBackground),
                  children: [
                    TextSpan(text: 'Barcode:\n', style: bold),
                    TextSpan(
                        text: 'Original: ',
                        style: regular.copyWith(fontStyle: FontStyle.italic)),
                    TextSpan(
                        text: '${originalResult?.barcode}\n',
                        style: regular.copyWith(
                            decoration: TextDecoration.underline)),
                    TextSpan(
                        text: 'New: ',
                        style: regular.copyWith(fontStyle: FontStyle.italic)),
                    TextSpan(text: '${currentResult.value.barcode}\n'),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  style:
                      regular.copyWith(fontSize: 16, color: stye.onBackground),
                  children: [
                    TextSpan(
                      text: 'Result:\n',
                      style: bold,
                    ),
                    TextSpan(
                        text: 'Original: ',
                        style: regular.copyWith(fontStyle: FontStyle.italic)),
                    TextSpan(
                        text: '${originalResult?.lftResult}\n',
                        style: regular.copyWith(
                            decoration: TextDecoration.underline)),
                    TextSpan(
                        text: 'New: ',
                        style: regular.copyWith(fontStyle: FontStyle.italic)),
                    TextSpan(text: '${currentResult.value.lftResult}\n'),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel', style: regular),
            onPressed: () {
              Get.back(); // Dismiss dialog
            },
          ),
          TextButton(
            child: Text('Save', style: regular),
            onPressed: () {
              updateResult(currentResult.value.documentId!,
                  currentResult.value.toJson());
              Get.back(); // Dismiss dialog
            },
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  void showDeleteConfirmationDialog(context) {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Confirm Delete',
          style: bold,
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Are you sure you want to delete this record?',
                  style: regular),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel', style: regular),
            onPressed: () {
              Get.back(); // Dismiss dialog
            },
          ),
          TextButton(
            child: Text('Delete', style: regular),
            onPressed: () {
              deleteResult(currentResult.value.documentId!);
              Get.back(); // Dismiss dialog
            },
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  void updateResult(String documentId, Map<String, dynamic> newData) async {
    try {
      await firebaseFirestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('lftResults')
          .doc(documentId)
          .update(newData);
      Get.back();
      Get.snackbar('Success', 'LFT result updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update LFT result');
    }
  }

  void deleteResult(String documentId) async {
    try {
      await firebaseFirestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('lftResults')
          .doc(documentId)
          .delete();
      Get.back();
      Get.snackbar('Success', 'LFT result deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete LFT result');
    }
  }
}
