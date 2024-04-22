// lft_result.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class LFTResult {
  String? documentId;
  String? barcode;
  String? lftResult;
  String? confidence;
  Timestamp? createdOn;

  LFTResult({
    this.documentId,
    this.barcode,
    this.lftResult,
    this.confidence,
    this.createdOn,
  });

  Map<String, dynamic> toJson() => {
        'barcode': barcode,
        'lftResult': lftResult,
        'confidence': confidence,
        'createdOn': createdOn,
      };

  static LFTResult fromJson(Map<String, dynamic> json, String docId) =>
      LFTResult(
        documentId: docId,
        barcode: json['barcode'],
        lftResult: json['lftResult'],
        confidence: json['confidence'],
        createdOn: json['createdOn'],
      );
}
