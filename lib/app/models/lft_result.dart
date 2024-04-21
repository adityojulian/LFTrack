// lft_result.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class LFTResult {
  final String barcode;
  final String lftResult;
  final String confidence;
  final Timestamp createdOn;

  LFTResult({
    required this.barcode,
    required this.lftResult,
    required this.confidence,
    required this.createdOn,
  });

  Map<String, dynamic> toJson() => {
        'barcode': barcode,
        'lftResult': lftResult,
        'confidence': confidence,
        'createdOn': createdOn,
      };

  static LFTResult fromJson(Map<String, dynamic> json) => LFTResult(
        barcode: json['barcode'],
        lftResult: json['lftResult'],
        confidence: json['confidence'],
        createdOn: json['createdOn'],
      );
}
