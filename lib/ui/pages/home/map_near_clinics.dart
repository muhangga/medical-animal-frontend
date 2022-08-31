import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:medical_animal/core/api/api_service.dart';
import 'package:medical_animal/core/api/models/clinic_model.dart';
import 'package:medical_animal/core/services/map_service.dart';

class MapNearClinics extends StatefulWidget {
  const MapNearClinics({Key? key}) : super(key: key);

  @override
  State<MapNearClinics> createState() => _MapNearClinicsState();
}

class _MapNearClinicsState extends State<MapNearClinics> {
  GoogleMapController? _controller;

  ApiService apiService = ApiService();
  List<ClinicModel> listClinic = [];
  List<Marker> markers = [];

  Position? _currentPosition;
  LatLng? _currentLocation;
  MapService mapService = MapService();

  String? _mapStyle;

  _getUserCurrentLocation() async {
    await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
            forceAndroidLocationManager: true)
        .then((Position position) {
      setState(() {
        _currentPosition = position;

        _currentLocation = LatLng(_currentPosition!.latitude,
            _currentPosition!.longitude); //current location

        markers.add(
          Marker(
            markerId: const MarkerId('currentLocation'),
            position: _currentLocation!,
            infoWindow: InfoWindow(
                title: 'Current Location',
                snippet:
                    'lat ${_currentLocation!.latitude} long ${_currentLocation!.longitude}'),
          ),
        );
      });
    }).catchError((e) {
      print(e);
    });
  }

  _getNearClinicLocation() async {
    await apiService
        .nearClinic(_currentLocation!.latitude, _currentLocation!.longitude)
        .then((value) {
      setState(() {
        listClinic = value;
        for (var i = 0; i < listClinic.length; i++) {
          markers.add(
            Marker(
              markerId: MarkerId(listClinic[i].id.toString()),
              position:
                  LatLng(listClinic[i].latitude!, listClinic[i].longitude!),
              infoWindow: InfoWindow(
                  title: listClinic[i].clinicName,
                  snippet:
                      'lat ${listClinic[i].address} long ${listClinic[i].distance}'),
            ),
          );
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });

    mapService.getGeoLocationPosition();
    _getUserCurrentLocation();
    _getNearClinicLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(-6.7160119, 106.8615019),
          zoom: 10.0,
        ),
        mapType: MapType.normal,
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
          _controller!.setMapStyle(_mapStyle);
        },
        markers: markers.map((e) => e).toSet(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _getNearClinicLocation();
        },
        child: const Icon(Icons.location_searching),
      ),
    );
  }
}
