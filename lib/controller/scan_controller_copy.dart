import 'package:camera/camera.dart';
import 'package:get/get.dart';

class ScanControllerCopy extends GetxController {
  final RxBool _isIntialized = RxBool(false);
  late CameraController _cameraController;
  late List<CameraDescription> _cameras;

  bool get isInitialized => _isIntialized.value;
  CameraController get cameraController => _cameraController;

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    _cameraController = CameraController(_cameras[0], ResolutionPreset.max);
    _cameraController.initialize().then((_) {
      _isIntialized.value = true;
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  @override
  void onInit() {
    // TODO: implement onInit
    _initCamera();
    super.onInit();
  }
}
