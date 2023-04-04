import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';

Future<String> fileToBase64(File file) async {
  final bytes = await file.readAsBytes();
  return base64Encode(bytes);
}

Future<String?> takePicture() async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(
      source: ImageSource.camera, preferredCameraDevice: CameraDevice.front);

  if (pickedFile == null) {
    return null;
  }

  final File image = File(pickedFile.path);
  final String base64Image = await fileToBase64(image);
  return base64Image;
}
