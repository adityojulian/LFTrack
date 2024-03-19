import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:isolate';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:ordinary/app/models/barcode_scanner_processor.dart';
// import 'package:ordinary/app/modules/detector_widget/service/barcode_image.dart';
import 'package:ordinary/app/shared/theme.dart';
import '../controllers/detector_widget_controller.dart';
import 'package:ordinary/app/models/recognition.dart';
import 'package:ordinary/app/models/screen_params.dart';
import 'package:ordinary/app/modules/detector_widget/service/detector_service.dart';
import 'package:ordinary/app/modules/detector_widget/views/box_widget.dart';
import 'package:ordinary/app/modules/detector_widget/views/camera_frame.dart';
import 'package:ordinary/app/modules/detector_widget/views/stats_widget.dart';

/// [DetectorWidget] sends each frame for inference
class DetectorWidget extends StatefulWidget {
  final double bottomPadding;

  /// Constructor
  const DetectorWidget({super.key, required this.bottomPadding});

  @override
  State<DetectorWidget> createState() => _DetectorWidgetState();
}

class _DetectorWidgetState extends State<DetectorWidget>
    with WidgetsBindingObserver {
  /// List of available cameras
  late List<CameraDescription> cameras;
  late CameraDescription cameraDescription;

  /// Controller
  CameraController? _cameraController;

  // use only when initialized, so - not null
  get _controller => _cameraController;

  /// Object Detector is running on a background [Isolate]. This is nullable
  /// because acquiring a [Detector] is an asynchronous operation. This
  /// value is `null` until the detector is initialized.
  Detector? _detector;
  StreamSubscription? _subscription;
  StreamSubscription? _barcodeSubscription;

  /// Results to draw bounding boxes
  List<Recognition>? results;

  /// Realtime stats
  Map<String, String>? stats;

  // Barcode
  final BarcodeScanner barcodeScanner = BarcodeScanner();
  BarcodeScannerProcessor? barcodeScannerProcessor;
  List<Barcode>? barcodes;
  InputImage? inputImage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initStateAsync();
  }

  void _initStateAsync() async {
    // initialize preview and CameraImage stream
    _initializeCamera();
    // Spawn a new isolate
    Detector.start().then((instance) {
      setState(() {
        _detector = instance;
        _barcodeSubscription =
            instance.barcodeResultsStream.stream.listen((values) {
          setState(() {
            barcodes = values['barcodes'];
          });
        });
        _subscription = instance.resultsStream.stream.listen((values) {
          setState(() {
            results = values['recognitions'];
            stats = values['stats'];
          });
        });
      });
    });
  }

  /// Initializes the camera by setting [_cameraController]
  void _initializeCamera() async {
    cameras = await availableCameras();
    cameraDescription = cameras.firstWhere(
        (element) => element.lensDirection == CameraLensDirection.back);

    // cameras[0] for back-camera
    _cameraController = CameraController(
        cameras[0],
        // cameraDescription,
        ResolutionPreset.medium,
        enableAudio: false,
        // )
        imageFormatGroup: Platform.isAndroid
            ? ImageFormatGroup.nv21
            : ImageFormatGroup.bgra8888)
      ..initialize().then((_) async {
        barcodeScannerProcessor = BarcodeScannerProcessor(
            cameraController: _controller,
            camera: cameras[0],
            barcodeScanner: barcodeScanner);
        await _controller.startImageStream(onLatestImageAvailable);
        setState(() {});

        /// previewSize is size of each image frame captured by controller
        ///
        /// 352x288 on iOS, 240p (320x240) on Android with ResolutionPreset.low
        ScreenParams.previewSize = _controller.value.previewSize!;
      });
  }

  void saveResultToFirebase() {
    // Implement your Firebase save operation here
    log("Saving result to Firebase...");
    // Example: FirebaseFirestore.instance.collection('results').add({...});
  }

  @override
  Widget build(BuildContext context) {
    /// Timer controller from GetX
    final DetectorWidgetController detectorController =
        Get.put(DetectorWidgetController());

    // Return empty container while the camera is not initialized
    if (_cameraController == null || !_controller.value.isInitialized) {
      return const SizedBox.shrink();
    }

    final mediaSize = MediaQuery.of(context).size;
    // final mediaSize = ScreenParams.screenPreviewSize;

    var aspect = 1 / _controller.value.aspectRatio;
    // var aspect = 1 /
    //     (_controller.value.aspectRatio *
    //         (mediaSize.width /
    //             (mediaSize.height - AppBar().preferredSize.height)));

    final scale = 1 /
        (_controller.value.aspectRatio *
            (mediaSize.width /
                (mediaSize.height - AppBar().preferredSize.height)));

    // log("Scale: $scale");

    return Stack(
      children: [
        // ClipRect(
        //   clipper: _MediaSizeClipper(mediaSize),
        //   child: Transform.scale(
        //       scale: scale,
        //       alignment: Alignment.topCenter,
        //       child: CameraPreview(_controller)),
        // ),
        AspectRatio(
          aspectRatio: aspect,
          child: CameraPreview(_controller),
        ),
        // Stats
        // _statsWidget(),
        AspectRatio(aspectRatio: aspect, child: _cameraFrame(scale)),
        // Bounding boxes
        // ClipRect(
        //   clipper: _MediaSizeClipper(mediaSize),
        //   child: Transform.scale(
        //       scale: scale,
        //       alignment: Alignment.topCenter,
        //       child: _boundingBoxes()),
        // ),
        AspectRatio(
          aspectRatio: aspect,
          child: _boundingBoxes(),
        ),
        detectorController.countdownTimer != null &&
                detectorController.countdownTimer!.isActive
            ? Obx(() => Center(
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.black.withOpacity(0.8),
                    child: Center(
                      child: Text(
                        '${detectorController.countdownSeconds.value}',
                        style: bold.copyWith(
                            fontSize: 120,
                            color: Theme.of(context).colorScheme.onPrimary),
                      ),
                    ),
                  ),
                ))
            : const SizedBox.shrink()
      ],
    );
  }

  Widget _cameraFrame(double scale) {
    // if (barcodes != null) {
    //   if (barcodes!.isNotEmpty) {
    //     log(barcodes!.first.cornerPoints.toString());
    //   }
    // }
    log("barcodes: ${barcodes.toString()}");
    log("results: ${results.toString()}");
    log("screen: ${ScreenParams.screenPreviewSize.toString()}");
    log("scale: ${scale.toString()}");
    final DetectorWidgetController detectorController = Get.find();
    Color frameColor = Colors.red; // Default color
    const frameSize = Size(250, 500); // Adjust the size as per requirement

    // Check if any recognition is fully within the frame
    if (results != null) {
      if (results!.isEmpty) {
        // _resetCountdown();
        detectorController.resetCountdown();
      } else {
        for (var result in results!) {
          if (isFullyWithinFrame(
              result, frameSize, ScreenParams.screenPreviewSize, scale)) {
            if ((detectorController.countdownTimer == null ||
                    !detectorController.countdownTimer!.isActive) &&
                Get.isDialogOpen == false) {
              detectorController.afterFinish.value
                  ? Future.delayed(const Duration(seconds: 1), () {
                      detectorController.startCountdown();
                    })
                  : detectorController.startCountdown();
              // detectorController.startCountdown();
              // detectorController.checkLftPosition(true);
              // _startCountdown();
            }
            // _resetCountdown();
            log("IN FRAME");
            frameColor = Colors.green; // Change color if fully within the frame
            // break; // Exit loop after the first match
          } else {
            // _resetCountdown();
            detectorController.resetCountdown();
            // detectorController.checkLftPosition(false);
            // detectorController.countdownTimer?.cancel();
            // detectorController.countdownSeconds.value = 3;
            log("NOT IN FRAME");
          }
        }
      }
    }

    // Draw the camera frame with the determined color
    return Center(
      child: CustomPaint(
        size: frameSize,
        painter: CameraFramePainter(frameColor),
      ),
    );
  }

  Widget _statsWidget() => (stats != null)
      ? Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            color: Colors.white.withAlpha(150),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: stats!.entries
                    .map((e) => StatsWidget(e.key, e.value))
                    .toList(),
              ),
            ),
          ),
        )
      : const SizedBox.shrink();

  /// Returns Stack of bounding boxes
  Widget _boundingBoxes() {
    if (results == null || barcodes == null) {
      return const SizedBox.shrink();
    }
    // if (barcodes != null) {
    //   if (barcodes!.isEmpty) {
    //     return const SizedBox.shrink();
    //   }
    // }
    return Stack(
        children: results!
            .map((box) => BoxWidget(
                  result: box,
                  lftID: barcodes!.isNotEmpty ? barcodes!.first.rawValue! : "",
                ))
            .toList());
  }

  /// Callback to receive each frame [CameraImage] perform inference on it
  void onLatestImageAvailable(CameraImage cameraImage) async {
    // LFT Object Detection & Barcode Recognition Isolate
    inputImage =
        barcodeScannerProcessor!.inputImageFromCameraImage(cameraImage);
    _detector?.processFrameBarcode(inputImage!);
    _detector?.processFrame(cameraImage);
  }

  bool isFullyWithinFrame(
      Recognition recognition, Size frameSize, Size screenSize, double scale) {
    // Frame boundaries
    final frameRect = Rect.fromCenter(
        center: Offset(screenSize.width / 2, screenSize.height / 2),
        width: frameSize.width,
        height: frameSize.height);

    // Recognition boundaries (assuming `recognition.renderLocation` is a Rect)
    // log("Scale: $scale");
    final recognitionRect = recognition.renderLocation;
    // var recLeft = recognitionRect.left * scale;
    // var recRight = recognitionRect.right * scale;
    // var recTop = recognitionRect.top * scale;
    // var recBottom = recognitionRect.bottom * scale;

    log("DETECTION L:${recognitionRect.left.toString()}, T:${recognitionRect.top.toString()}");
    log("DETECTION R:${recognitionRect.right.toString()}, B:${recognitionRect.bottom.toString()}");
    // log("DETECTION L:${recLeft.toString()}, T:${recTop.toString()}");
    // log("DETECTION R:${recRight.toString()}, B:${recBottom.toString()}");
    log("FRAME L:${frameRect.left.toString()}, T:${frameRect.top.toString()}");
    log("FRAME R:${frameRect.right.toString()}, B:${frameRect.bottom.toString()}");

    // Check if recognition is fully within the frame
    return recognitionRect.left >= frameRect.left &&
        recognitionRect.top >= frameRect.top &&
        recognitionRect.right <= (frameRect.right + 10) &&
        recognitionRect.bottom <= frameRect.bottom;
    // return recLeft >= frameRect.left &&
    //     recTop >= frameRect.top &&
    //     recRight <= frameRect.right &&
    //     recBottom <= frameRect.bottom;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.inactive:
        _cameraController?.stopImageStream();
        _detector?.stop();
        _subscription?.cancel();
        _barcodeSubscription?.cancel();
        // _countdownTimer?.cancel();
        break;
      case AppLifecycleState.resumed:
        _initStateAsync();
        break;
      default:
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    _detector?.stop();
    _subscription?.cancel();
    _barcodeSubscription?.cancel();
    // _countdownTimer?.cancel();
    super.dispose();
  }
}

class _MediaSizeClipper extends CustomClipper<Rect> {
  final Size mediaSize;
  const _MediaSizeClipper(this.mediaSize);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, mediaSize.width, mediaSize.height);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }
}
