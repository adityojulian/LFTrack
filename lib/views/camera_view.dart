import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ordinary/controller/scan_controller.dart';

class CameraView extends StatelessWidget {
  const CameraView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan Page"),
      ),
      body: GetBuilder<ScanController>(
          init: ScanController(),
          builder: (controller) {
            return controller.isCameraIntialized.value
                ? SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height -
                        AppBar().preferredSize.height,
                    child: Stack(
                      children: [
                        // CameraPreview(controller.cameraController)
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
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(
          height: 50,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.camera),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
