import 'package:geolocator/geolocator.dart';

class Location {
  double? latitude;
  double? longitude;

  Future<void> getCurrentLocation() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.\nTurn on GPS');
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied.\nUse the city search');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'Location permission denied forever.\n'
        'Enable it in app settings or use the city search',
      );
    }
    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.low),
    );
    latitude = position.latitude;
    longitude = position.longitude;
  }
}
