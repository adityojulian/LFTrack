import "package:camera/camera.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:ordinary/controller/scan_controller_copy.dart";

class CameraScreen extends GetView<ScanControllerCopy> {
  const CameraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<ScanControllerCopy>(builder: (controller) {
      if (!controller.isInitialized) {
        return const Text("Loading Preview");
      }
      return SizedBox(
          height: Get.height,
          width: Get.width,
          child: CameraPreview(controller.cameraController));
    });
  }
}
