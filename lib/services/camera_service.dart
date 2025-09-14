import 'dart:io';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';

class CameraService {
  static List<CameraDescription>? _cameras;
  static CameraController? _controller;

  static Future<void> initializeCameras() async {
    _cameras = await availableCameras();
  }

  static Future<CameraController?> initializeCamera() async {
    if (_cameras == null || _cameras!.isEmpty) {
      await initializeCameras();
    }

    if (_cameras != null && _cameras!.isNotEmpty) {
      _controller = CameraController(
        _cameras![0],
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await _controller!.initialize();
      return _controller;
    }
    return null;
  }

  static Future<File?> takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      return null;
    }

    try {
      final XFile image = await _controller!.takePicture();
      return File(image.path);
    } catch (e) {
      print('Error taking picture: $e');
      return null;
    }
  }

  static Future<File?> pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image != null) {
      return File(image.path);
    }
    return null;
  }

  static void dispose() {
    _controller?.dispose();
  }
}