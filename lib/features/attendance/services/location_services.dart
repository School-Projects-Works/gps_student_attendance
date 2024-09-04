import 'package:geolocator/geolocator.dart';


class GPSServices {
  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<(bool, String?, Position?)> getPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    //if(!kIsWeb){
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.value((false, 'Location services are disabled.', null));
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.value((false, 'Location permissions are denied', null));
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.value((
        false,
        'Location permissions are permanently denied, we cannot request permissions.',
        null
      ));
    }

    // }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    var position = await Geolocator.getCurrentPosition();
    return Future.value((true, null, position));
  }

  static double? calculateDistance(double latitude, double longitude, double d, double e) {
    try{
     
      double distanceInMeters =  Geolocator.distanceBetween(latitude, longitude,d, e);
      return distanceInMeters;
    }catch(e){
      return null;
    }
  }


}
