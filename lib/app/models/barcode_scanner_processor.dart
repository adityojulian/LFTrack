import 'dart:collection';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'dart:io';

import 'package:ordinary/app/models/barcode_recognition.dart';

class BarcodeScannerProcessor {
  final CameraController cameraController;
  final CameraDescription camera;
  final BarcodeScanner barcodeScanner;
  final HashSet<String> scannedBarcodes = HashSet();

  BarcodeScannerProcessor({
    required this.cameraController,
    required this.camera,
    required this.barcodeScanner,
  });

  InputImage? inputImageFromCameraImage(CameraImage image) {
    final _orientations = {
      DeviceOrientation.portraitUp: 0,
      DeviceOrientation.landscapeLeft: 90,
      DeviceOrientation.portraitDown: 180,
      DeviceOrientation.landscapeRight: 270,
    };

    final sensorOrientation = camera.sensorOrientation;
    InputImageRotation? rotation;

    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else if (Platform.isAndroid) {
      var rotationCompensation =
          _orientations[cameraController.value.deviceOrientation];
      if (rotationCompensation == null) return null;
      if (camera.lensDirection == CameraLensDirection.front) {
        rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
      } else {
        rotationCompensation =
            (sensorOrientation - rotationCompensation + 360) % 360;
      }
      rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
    }

    if (rotation == null) return null;
    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    if (format == null ||
        (Platform.isAndroid && format != InputImageFormat.nv21) ||
        (Platform.isIOS && format != InputImageFormat.bgra8888)) {
      return null;
    }
    if (image.planes.length != 1) return null;
    final plane = image.planes.first;

    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: plane.bytesPerRow,
      ),
    );
  }

  Future<List<BarcodeRecognition>> scanBarcodes(CameraImage image) async {
    List<BarcodeRecognition> barcodeRecognitions = [];
    final inputImage = inputImageFromCameraImage(image);
    if (inputImage != null) {
      final barcodes = await barcodeScanner.processImage(inputImage);
      for (final barcode in barcodes) {
        if (barcode.rawValue != null) {
          bool isDuplicate = scannedBarcodes.contains(barcode.rawValue);
          barcodeRecognitions
              .add(BarcodeRecognition(barcode.rawValue!, isDuplicate));
          if (!isDuplicate) {
            // If it's not a duplicate, add it to the set for future checks
            scannedBarcodes.add(barcode.rawValue!);
          }
        }
      }
    }
    return barcodeRecognitions; // Return the list of recognitions
  }
}
