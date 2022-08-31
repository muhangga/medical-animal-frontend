import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:medical_animal/core/api/models/clinic_model.dart';

class MapProvider extends ChangeNotifier {
  double _cameraZoom = 16;
  double get cameraZoom => _cameraZoom;

  double _cameraTilt = 0;
  double get cameraTilt => _cameraTilt;

  double _cameraBearing = 30;
  double get cameraBearing => _cameraBearing;

  CameraPosition? _cameraPosition;
  CameraPosition? get cameraPosition => _cameraPosition;

  String? _mapStyle;
  String? get mapStyle => _mapStyle;

  GoogleMapController? _mapController;
  GoogleMapController? get mapController => _mapController;

  Completer<GoogleMapController> _completer = Completer();
  Completer<GoogleMapController> get completer => _completer;

  Set<Marker> _markers = {};
  Set<Marker> get markers => _markers;

  Position? position;
  StreamSubscription<Position>? locationSubscription;

  List<ClinicModel> _clinicList = [];
  List<ClinicModel> get clinicList => _clinicList;

  BuildContext? _context;
  BuildContext? get context => _context;

  ClinicModel? _clinicModel;
  ClinicModel? get clinicModel => _clinicModel;

  LatLng? _sourceLocation;
  LatLng? get sourceLocation => _sourceLocation;

  final markerKey = GlobalKey();
  final myLocationKey = GlobalKey();

  void initCamera(BuildContext context) async {
    await initLocation();

    _cameraPosition = CameraPosition(
      zoom: cameraZoom,
      bearing: cameraBearing,
      tilt: cameraTilt,
      target: sourceLocation!,
    );

    _context = context;
    notifyListeners();
  }

  Future<void> initLocation() async {
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
            desiredAccuracy: LocationAccuracy.bestForNavigation,
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

  void listeningLocation() {
    Geolocator.getPositionStream().listen((data) {
      var locData = LatLng(data.latitude, data.longitude);

      setMyLocation(locData);
    });
  }

  void stopListeningLocation() {
    locationSubscription?.cancel();
  }

  void setMyLocation(LatLng locData) {
    _sourceLocation = locData;
    print(locData.latitude.toString());

    updateMyLocationMarker(true, false);
    notifyListeners();
  }

  void changeCameraPosition(LatLng location,
      {bool useBearing = false, bool customZoom = false}) {
    _mapController!.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(location.latitude, location.longitude),
      zoom: customZoom == true ? 18 : cameraZoom,
      bearing: useBearing == true ? cameraBearing : 0,
    )));

    notifyListeners();
  }

  void onMapCreated(GoogleMapController controller) async {
    _mapStyle = await rootBundle.loadString('assets/map_style.txt');

    _completer.complete(controller);
    _mapController = controller;

    _mapController!.setMapStyle(_mapStyle!);
    setMapPins(sourceLocation, _clinicList);

    notifyListeners();
  }

  void setMyLocationMarker() async {
    Uint8List markerIcon = await getUint8List(myLocationKey);
    notifyListeners();

    _markers.add(Marker(
        markerId: MarkerId('myLocation'),
        icon: BitmapDescriptor.fromBytes(markerIcon),
        position: sourceLocation!));
    notifyListeners();
  }

  void updateMyLocationMarker(bool customZoom, bool useBearing) async {
    //Change camera position
    if (_mapController != null) {
      changeCameraPosition(sourceLocation!,
          customZoom: customZoom, useBearing: useBearing);
    }

    //Remove current marker
    _markers.removeWhere((m) => m.markerId.value == "sourcePin");

    ///Create marker point
    Uint8List markerIcon = await getUint8List(myLocationKey);
    notifyListeners();
    //Adding new marker
    _markers.add(Marker(
        markerId: const MarkerId("sourcePin"),
        position: sourceLocation!,
        icon: BitmapDescriptor.fromBytes(markerIcon)));

    notifyListeners();
  }

  void setMapPins(
      LatLng? sourceLocation, List<ClinicModel> destinationList) async {
    //Set my location marker
    setMyLocationMarker();

    for (int i = 0; i < destinationList.length; i++) {
      var data = destinationList[i];

      _clinicModel = data;
      await Future.delayed(Duration(milliseconds: 100));

      ///Create marker point
      Uint8List markerIcon = await getUint8List(markerKey);
      notifyListeners();

      _markers.add(Marker(
        markerId: MarkerId(data.clinicName.toString()),
        position: LatLng(data.latitude!, data.longitude!),
        icon: BitmapDescriptor.fromBytes(markerIcon),

        // onTap: () => setSelected(data)
      ));
    }

    notifyListeners();
  }

  void setClinicMarker() async {
    ///Create marker point
    Uint8List markerIcon = await getUint8List(markerKey);
    notifyListeners();

    _markers.add(Marker(
      markerId: MarkerId(_clinicModel!.clinicName.toString()),
      position: LatLng(_clinicModel!.latitude!, _clinicModel!.longitude!),
      icon: BitmapDescriptor.fromBytes(markerIcon),

      // onTap: () => setSelected(data)
    ));

    notifyListeners();
  }

  Future<Uint8List> getUint8List(GlobalKey widgetKey) async {
    RenderRepaintBoundary boundary =
        widgetKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
    var image = await boundary.toImage(pixelRatio: 2.0);
    ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }
}
