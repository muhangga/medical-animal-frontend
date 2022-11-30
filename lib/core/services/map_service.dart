import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

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

  Future<void> launchUrlPath(String path) async {
    if (!await launchUrl(Uri.parse(path))) {
      throw 'Could not launch $path';
    }

    await launchUrl(Uri.parse(path));
  }
}
