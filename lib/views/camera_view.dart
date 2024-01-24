import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:ordinary/controller/scan_controller.dart';

class CameraView extends StatelessWidget {
  const CameraView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<ScanController>(
          init: ScanController(),
          builder: (controller) {
            return controller.isCameraIntialized.value
                ? SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height - 100,
                    child: Stack(
                      children: [
                        controller.cameraController.buildPreview(),
                        // Positioned(
                        //   top: 700,
                        //   right: 500,
                        //   child: Container(
                        //     width: 100,
                        //     height: 100,
                        //     decoration: BoxDecoration(
                        //         borderRadius: BorderRadius.circular(8),
                        //         border:
                        //             Border.all(color: Colors.green, width: 4.0)),
                        //     child: Column(
                        //       mainAxisSize: MainAxisSize.min,
                        //       children: [
                        //         Container(
                        //             color: Colors.white,
                        //             child: Text(controller.label))
                        //       ],
                        //     ),
                        //   ),
                        // )
                      ],
                    ),
                  )
                : const Center(child: Text("Loading Preview"));
          }),
    );
  }
}
