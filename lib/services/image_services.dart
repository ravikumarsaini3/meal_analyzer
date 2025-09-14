// import 'dart:io';
// import 'dart:typed_data';
//
// import 'package:flutter/services.dart';
// import 'package:path_provider/path_provider.dart';
//
// class ImageService {
//   static Future<File> compressImage(File originalFile) async {
//     try {
//       // Read the image
//       Uint8List imageBytes = await originalFile.readAsBytes();
//       img.Image? originalImage = img.decodeImage(imageBytes);
//
//       if (originalImage == null) return originalFile;
//
//       // Resize if too large
//       img.Image resizedImage = originalImage;
//       if (originalImage.width > 800 || originalImage.height > 800) {
//         resizedImage = img.copyResize(
//           originalImage,
//           width: originalImage.width > originalImage.height ? 800 : null,
//           height: originalImage.height > originalImage.width ? 800 : null,
//         );
//       }
//
//       // Compress with quality 85
//       List<int> compressedBytes = img.encodeJpg(resizedImage, quality: 85);
//
//       // Save compressed image
//       final directory = await getTemporaryDirectory();
//       final compressedFile = File('${directory.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg');
//       await compressedFile.writeAsBytes(compressedBytes);
//
//       return compressedFile;
//     } catch (e) {
//       print('Error compressing image: $e');
//       return originalFile;
//     }
//   }
//
//   static Future<String> getImagePath(String filename) async {
//     final directory = await getApplicationDocumentsDirectory();
//     return '${directory.path}/$filename';
//   }
//
//   static Future<void> saveImagePermanently(File tempFile, String filename) async {
//     final permanentPath = await getImagePath(filename);
//     await tempFile.copy(permanentPath);
//   }
// }