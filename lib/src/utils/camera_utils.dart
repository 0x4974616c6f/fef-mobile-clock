import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:fef_mobile_clock/src/utils/location_utils.dart';

Future<void> takePicture() async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.camera);

  if (pickedFile == null) {
    print('Nenhuma imagem selecionada.');
    return;
  }

  final File image = File(pickedFile.path);
  print(image.path);

  final position = await getCurrentLocation();
  if (position != null) {
    print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');
  } else {
    print('Não foi possível obter a localização do usuário.');
  }
  // Você pode usar a variável 'image' para exibir a imagem no aplicativo ou fazer upload para um servidor.
}
