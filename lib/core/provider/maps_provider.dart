import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsProvider extends ChangeNotifier {
  LatLng? _sourceLocation;
  LatLng? get sourceLocation => _sourceLocation;

  Position? _currentPosition;
  StreamSubscription<Position>? _positionStream;

  Set<Marker> _markers = {};
  Set<Marker> get markers => _markers;

  void initLocation() async {
    LocationPermission permission;
    Position? currentPos;

    if (await Geolocator.isLocationServiceEnabled()) {
      permission = await Geolocator.checkPermission();
      if ((permission != LocationPermission.always ||
          permission != LocationPermission.whileInUse)) {
        permission = await Geolocator.requestPermission();
        currentPos = Position(
            longitude: 0,
            latitude: 0,
            timestamp: DateTime.now(),
            accuracy: 0,
            altitude: 0,
            heading: 0,
            speed: 0,
            speedAccuracy: 0);
      }

      try {
        currentPos = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
            timeLimit: const Duration(seconds: 10));
      } catch (e) {
        currentPos = await Geolocator.getLastKnownPosition();
      }
    } else {
      currentPos = Position(
          longitude: 0,
          latitude: 0,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0);
    }
    _sourceLocation = LatLng(currentPos!.latitude, currentPos.longitude);
    notifyListeners();
  }

  void listeningLocation() async {
    Geolocator.getPositionStream().listen((event) {
      _sourceLocation = LatLng(event.latitude, event.longitude);
      notifyListeners();
    });
  }

  void dispose() {
    _positionStream!.cancel();
    super.dispose();
  }

  void setMyLocation(LatLng latLng) {
    _sourceLocation = latLng;
    print(latLng.latitude.toString());

    updateMyLocationMaker();
    notifyListeners();
  }

  void updateMyLocationMaker() {
    _markers.clear();
    _markers.add(Marker(
        markerId: const MarkerId('myLocation'),
        position: _sourceLocation!,
        infoWindow: const InfoWindow(title: 'My Location')));
    
    notifyListeners();
  }

}
