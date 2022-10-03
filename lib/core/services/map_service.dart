import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class MapService {
  Future<Position?> getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    Position? position;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      debugPrint('Location services are disabled. Please enable the services');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return Future.error('Location Denied Forever');
      }

      if (permission == LocationPermission.denied) {
        return Future.error('Location Denied');
      }

      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        return position;
      }
    }

    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    print(position.latitude);
    print(position.longitude);

    return position;
  }

  Future<void> openMap() async {
    Position? position = await getGeoLocationPosition();
  }
}
