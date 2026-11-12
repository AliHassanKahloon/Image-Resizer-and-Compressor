import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ImageService extends ChangeNotifier {
  ImageService._();

  static final ImageService instance = ImageService._();

  File? selectedImage;
  List<File> savedImages = [];

  final ImagePicker _picker = ImagePicker();

  // Select an image from the gallery
  Future<void> pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      selectedImage = File(pickedFile.path);
      notifyListeners();
    }
  }

  // Get the folder where processed images are saved
  Future<Directory> _getSaveDirectory() async {
    final appDirectory = await getApplicationDocumentsDirectory();

    final saveDirectory = Directory(
      '${appDirectory.path}/processed_images',
    );

    if (!await saveDirectory.exists()) {
      await saveDirectory.create(recursive: true);
    }

    return saveDirectory;
  }

  // Resize selected image
  Future<File?> resizeImage(int width, int height) async {
    if (selectedImage == null) return null;

    final bytes = await selectedImage!.readAsBytes();
    final originalImage = img.decodeImage(bytes);

    if (originalImage == null) {
      throw Exception('Unable to read this image.');
    }

    final resizedImage = img.copyResize(
      originalImage,
      width: width,
      height: height,
    );

    final outputBytes = img.encodeJpg(resizedImage, quality: 90);

    final directory = await _getSaveDirectory();

    final outputFile = File(
      '${directory.path}/resized_${DateTime.now().microsecondsSinceEpoch}.jpg',
    );

    await outputFile.writeAsBytes(outputBytes);

    await refreshSavedImages();

    return outputFile;
  }

  // Compress selected image
  Future<File?> compressImage(int quality) async {
    if (selectedImage == null) return null;

    final bytes = await selectedImage!.readAsBytes();
    final originalImage = img.decodeImage(bytes);

    if (originalImage == null) {
      throw Exception('Unable to read this image.');
    }

    final compressedBytes = img.encodeJpg(
      originalImage,
      quality: quality,
    );

    final directory = await _getSaveDirectory();

    final outputFile = File(
      '${directory.path}/compressed_${DateTime.now().microsecondsSinceEpoch}.jpg',
    );

    await outputFile.writeAsBytes(compressedBytes);

    await refreshSavedImages();

    return outputFile;
  }

  // Load saved images
  Future<void> refreshSavedImages() async {
    final directory = await _getSaveDirectory();

    savedImages = directory
        .listSync()
        .whereType<File>()
        .toList();

    savedImages.sort(
          (a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()),
    );

    notifyListeners();
  }

  // Delete a saved image
  Future<void> deleteImage(File file) async {
    if (await file.exists()) {
      await file.delete();
    }

    await refreshSavedImages();
  }
}// TODO Implement this library.