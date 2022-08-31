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
        return Future.error('Location Not Available');
      }

      if (permission == LocationPermission.denied) {
        return Future.error('Location Not Available');
      }

      if (permission != LocationPermission.always ||
          permission != LocationPermission.whileInUse) {
        return Future.error('Location Not Available');
      }
    }

    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10));

    print(position.latitude);
    print(position.longitude);

    return position;
  }
}

Future<String> getAddress(double lat, double long) async {
  List<Placemark> placemark = await placemarkFromCoordinates(lat, long);

  if (placemark != null && placemark.isNotEmpty) {
    return placemark[0].name!;
  }

  return "";
}
