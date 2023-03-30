import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> requestLocationPermission() async {
  PermissionStatus status = await Permission.location.status;

  if (status.isDenied || status.isRestricted || status.isPermanentlyDenied) {
    PermissionStatus newStatus = await Permission.location.request();

    if (newStatus.isGranted) {
      // A permissão foi concedida, obtenha a localização
    } else {
      // A permissão foi negada, mostre uma mensagem de erro ou instruções
    }
  } else if (status.isGranted) {
    // A permissão já foi concedida, obtenha a localização
  } else {
    // Outros casos, como quando o serviço de localização está desabilitado
  }
}

Future<Position?> getCurrentLocation() async {
  try {
    // Verifique se o serviço de localização está habilitado e se o aplicativo possui as permissões necessárias.
    final locationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    final permission = await Geolocator.checkPermission();

    if (!locationServiceEnabled ||
        permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      print(
          "Acesso à localização negado ou serviço de localização desabilitado");
      return null;
    }

    // Obtenha a localização atual do usuário.
    final currentPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    return currentPosition;
  } catch (e) {
    print("Erro ao obter a localização: $e");
    return null;
  }
}
