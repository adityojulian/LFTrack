import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class ScanController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    initCamera();
    initTFLite();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    cameraController.dispose();
    super.dispose();
  }

  late CameraController cameraController;
  late List<CameraDescription> cameras;

  var cameraCount = 0;

  var isCameraIntialized = false.obs;

  var x, y, w, h = 0.0;
  var label = "";

  initCamera() async {
    if (await Permission.camera.request().isGranted) {
      cameras = await availableCameras();
      cameraController = CameraController(
        cameras[0],
        ResolutionPreset.max,
      );
      await cameraController.initialize().then((value) {
        cameraController.startImageStream((image) {
          cameraCount++;
          if (cameraCount % 30 == 0) {
            cameraCount = 0;
            objectDetector(image);
          }
          update();
        });
      });
      isCameraIntialized(true);
      update();
    } else {
      print("Permission Denied");
    }
  }

  initTFLite() async {
    await Tflite.loadModel(
        model: "assets/yolov2_tiny.tflite",
        labels: "assets/yolov2_tiny.txt",
        isAsset: true,
        numThreads: 1,
        useGpuDelegate: false);
  }

  objectDetector(CameraImage image) async {
    var detector = await Tflite.detectObjectOnFrame(
        bytesList: image.planes.map((plane) {
          return plane.bytes;
        }).toList(),
        model: "YOLO",
        asynch: true,
        imageHeight: image.height,
        imageWidth: image.width,
        imageMean: 127.5,
        imageStd: 127.5,
        rotation: 90,
        threshold: 0.1,
        numResultsPerClass: 1);
    if (detector != null) {
      log("Result is ${detector}");
      // var detectedObj = detector.first;
      // if (detectedObj['confidenceInClass'] * 100 > 45) {
      //   label = detectedObj['detectedClass'].toString();
      //   h = detectedObj['rect']['h'];
      //   w = detectedObj['rect']['w'];
      //   x = detectedObj['rect']['x'];
      //   y = detectedObj['rect']['y'];
      // }
      // update();
    }
  }
}
