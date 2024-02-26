// import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';

InputImage? _inputImageFromCameraImage(
  CameraImage image,
  CameraController cameraController,
  CameraDescription camera,
) {
  // if (_cameraController == null) return null;

  final _orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

  // final camera = cameras[0];
  final sensorOrientation = camera.sensorOrientation;

  InputImageRotation? rotation;
  if (Platform.isIOS) {
    // log("IOS");
    rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
  } else if (Platform.isAndroid) {
    // log("ANDORID");
    var rotationCompensation =
        _orientations[cameraController.value.deviceOrientation];
    if (rotationCompensation == null) {
      // log("rotationCompensation == null");
      return null;
    }
    if (camera.lensDirection == CameraLensDirection.front) {
      // front-facing
      rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
    } else {
      // back-facing
      rotationCompensation =
          (sensorOrientation - rotationCompensation + 360) % 360;
    }
    rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
    // print('rotationCompensation: $rotationCompensation');
  }
  if (rotation == null) {
    // log("rotation == null");
    return null;
  }

  // get image format
  final format = InputImageFormatValue.fromRawValue(image.format.raw);
  // log("Format = ${format.toString()}");
  // validate format depending on platform
  // only supported formats:
  // * nv21 for Android
  // * bgra8888 for iOS
  if (format == null ||
      (Platform.isAndroid && format != InputImageFormat.nv21) ||
      (Platform.isIOS && format != InputImageFormat.bgra8888)) return null;

  // since format is constraint to nv21 or bgra8888, both only have one plane
  if (image.planes.length != 1) return null;
  final plane = image.planes.first;

  // compose InputImage using bytes
  return InputImage.fromBytes(
    bytes: plane.bytes,
    metadata: InputImageMetadata(
      size: Size(image.width.toDouble(), image.height.toDouble()),
      rotation: rotation, // used only in Android
      format: format, // used only in iOS
      bytesPerRow: plane.bytesPerRow, // used only in iOS
    ),
  );
}

Future<String> barcodeScannerResult(
    CameraImage image,
    CameraController cameraController,
    CameraDescription camera,
    BarcodeScanner barcodeScanner) async {
  final inputImage =
      _inputImageFromCameraImage(image, cameraController, camera);
  if (inputImage != null) {
    final barcodes = await barcodeScanner.processImage(inputImage);
    String text = 'Barcodes found: ${barcodes.length}\n\n';
    for (final barcode in barcodes) {
      text += 'Barcode: ${barcode.rawValue}\n\n';
      return text;
    }
  }
  return "No Barcode";
}
