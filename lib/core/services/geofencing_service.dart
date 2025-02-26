import 'package:atd/core/services/location_service.dart';

class GeofencingService {
  static Future<bool> checkDistance(
      {required double latitude, required double longitude}) async {
    return await LocationService().determinePosition().then((position) {
      if (position.latitude - 0.00050 <= latitude &&
          latitude <= latitude + 0.00050 &&
          position.longitude - 0.00050 <= longitude &&
          longitude <= position.longitude + 0.0050) {
        return true;
      } else {
        return false;
      }
    });
  }
}
