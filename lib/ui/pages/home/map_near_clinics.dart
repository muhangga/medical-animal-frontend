import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:medical_animal/core/api/api_service.dart';
import 'package:medical_animal/core/api/models/clinic_model.dart';
import 'package:medical_animal/core/common/theme.dart';
import 'package:medical_animal/core/services/map_service.dart';
import 'package:permission_handler/permission_handler.dart';

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
  LocationPermission? permission;

  String? _mapStyle;

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Future<void> _getUserCurrentLocation() async {
    final Uint8List markerIcon =
        await getBytesFromAsset('assets/placeholder.png', 130);

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
            infoWindow: const InfoWindow(
              title: 'Lokasi Terkini',
            ),
            icon: BitmapDescriptor.fromBytes(markerIcon),
          ),
        );
      });
    }).catchError((e) {
      print(e);
    });
  }

  Future<void> _getNearClinicLocation() async {
    if (_currentLocation != null) {
      final Uint8List markerIcon =
          await getBytesFromAsset('assets/veterinarian.png', 100);

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
                    snippet: '${listClinic[i].address}'),
                icon: BitmapDescriptor.fromBytes(markerIcon),
              ),
            );
          }
        });
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Lokasi tidak ditemukan silahkan hidupkan GPS anda'),
        ),
      );
      Navigator.pop(context);
    }
  }

  void checkPermission() async {
    if (await Permission.contacts.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.
      getUserAndClinicLocation();
    }

    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
    ].request();
    print(statuses[Permission.location]);
  }

  Future<void> getUserAndClinicLocation() async {
    await _getUserCurrentLocation();
    await _getNearClinicLocation();
  }

  @override
  void initState() {
    super.initState();
    rootBundle.loadString('assets/map_style_2.txt').then((string) {
      _mapStyle = string;
    });

    checkPermission();
    // mapService.getGeoLocationPosition();
    getUserAndClinicLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            _currentLocation != null
                ? GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: CameraPosition(
                      target: _currentLocation!,
                      zoom: 12,
                    ),
                    zoomControlsEnabled: false,
                    myLocationButtonEnabled: false,
                    myLocationEnabled: false,
                    tiltGesturesEnabled: false,
                    mapToolbarEnabled: false,
                    markers: Set.from(markers),
                    onMapCreated: (GoogleMapController controller) {
                      _controller = controller;
                      _controller!.setMapStyle(_mapStyle);
                    },
                  )
                : const Center(
                    child: SpinKitDoubleBounce(
                      color: kMainColor,
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Align(
                      alignment: Alignment.topLeft,
                      child: Icon(Icons.arrow_back_ios, color: kSecondaryColor),
                    ),
                  ),
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: FloatingActionButton(
                      backgroundColor: kSecondaryColor,
                      onPressed: () {
                        _controller!.animateCamera(
                          CameraUpdate.newCameraPosition(
                            CameraPosition(
                              target: _currentLocation!,
                              zoom: 12,
                            ),
                          ),
                        );
                      },
                      child: const Icon(
                        Icons.my_location,
                        color: kWhiteColor,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 80, left: 24, right: 24),
              child: TextFormField(
                autofocus: false,
                decoration: InputDecoration(
                  hintText: 'Cari Klinik',
                  prefixIcon: const Icon(Icons.search, color: kMainColor),
                  contentPadding: const EdgeInsets.only(
                    left: 15.0,
                    top: 15.0,
                  ),
                  filled: true,
                  fillColor: kWhiteColor,
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: kMainColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: kWhiteColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 40,
              child: Container(
                padding: const EdgeInsets.only(left: 24),
                width: 400,
                height: 130,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: listClinic.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              _controller!.animateCamera(
                                CameraUpdate.newCameraPosition(
                                  CameraPosition(
                                    target: LatLng(listClinic[index].latitude!,
                                        listClinic[index].longitude!),
                                    zoom: 12,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 10),
                              width: 200,
                              height: 130,
                              decoration: BoxDecoration(
                                color: kWhiteColor,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: kMainColor.withOpacity(0.2)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 7,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        14, 14, 10, 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          listClinic[index].clinicName!,
                                          style: blackTextStyle.copyWith(
                                              fontSize: 16, fontWeight: bold),
                                        ),
                                        Text(
                                          listClinic[index].address!,
                                          style: greyTextStyle.copyWith(
                                              fontSize: 12),
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          children: [
                                            const Icon(
                                                MdiIcons.mapMarkerDistance,
                                                color: kMainColor,
                                                size: 16),
                                            const SizedBox(width: 10),
                                            Text(
                                              listClinic[index]
                                                      .distance!
                                                      .toStringAsFixed(2) +
                                                  ' km',
                                              style: redTextStyle.copyWith(
                                                  fontSize: 14,
                                                  fontWeight: bold),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
