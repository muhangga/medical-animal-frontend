import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:medical_animal/core/api/api_service.dart';
import 'package:medical_animal/core/api/models/clinic_model.dart';
import 'package:medical_animal/core/common/constant.dart';
import 'package:medical_animal/core/services/map_service.dart';
import 'package:medical_animal/core/services/mapbox_directions.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:medical_animal/core/common/theme.dart';

import 'detail_map_page.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapState();
}

class _MapState extends State<MapPage> {
  MapboxMapController? mapController;

  ApiService apiService = ApiService();
  List<ClinicModel> listClinic = [];
  List<SymbolOptions> markers = [];

  Position? _currentPosition;
  LatLng? _currentLocation;
  MapService mapService = MapService();
  MapboxService mapboxService = MapboxService();
  LocationPermission? permission;

  

  Future<void> _getUserPosition() async {
    await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
            forceAndroidLocationManager: true)
        .then((Position position) {
      if (!mounted) return;
      setState(() {
        _currentPosition = position;

        _currentLocation =
            LatLng(_currentPosition!.latitude, _currentPosition!.longitude);
        print(_currentLocation);
      });
    }).catchError((e) {
      print(e);
    });
  }

  Future<void> _getNearClinicLocation() async {
    if (_currentPosition != null) {
      await apiService
          .nearClinic(_currentPosition!.latitude, _currentPosition!.longitude)
          .then((value) {
        if (!mounted) return;
        setState(() {
          listClinic = value;
          for (var i = 0; i < listClinic.length; i++) {
            mapController?.addSymbol(
              SymbolOptions(
                  geometry: LatLng(
                      double.parse(listClinic[i].latitude.toString()),
                      double.parse(listClinic[i].longitude.toString())),
                  iconImage: 'assets/ic_clinic.png',
                  iconSize: 0.3),
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

  Future<void> getUserAndClinicLocation() async {
    await _getUserPosition();
    await _getNearClinicLocation();
  }

  void checkPermission() async {
    if (await Permission.contacts.request().isGranted) {
      getUserAndClinicLocation();
    }

    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
    ].request();
    print(statuses[Permission.location]);
  }

  void _onMapcreated(MapboxMapController controller) {
    mapController = controller;
  }

  void _onSelected(int index) {
    setState(() {
      mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
              listClinic[index].latitude!,
              listClinic[index].longitude!,
            ),
            zoom: 14.0,
          ),
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    checkPermission();
    getUserAndClinicLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              child: MapboxMap(
                accessToken: MAPBOX_APIKEY,
                initialCameraPosition: CameraPosition(
                  target: _currentPosition != null
                      ? LatLng(_currentPosition!.latitude,
                          _currentPosition!.longitude)
                      : LatLng(0, 0),
                  zoom: 11.0,
                ),
                onMapCreated: _onMapcreated,
                myLocationEnabled: true,
                myLocationRenderMode: MyLocationRenderMode.GPS,
                myLocationTrackingMode: MyLocationTrackingMode.Tracking,
                // onStyleLoadedCallback: _onStyleLoadedCallback,
              ),
            ),
            _backAndCurrentLocationButton(context),
            _itemClinic(),
          ],
        ),
      ),
    );
  }

  Widget _backAndCurrentLocationButton(BuildContext context) {
    return Padding(
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
                mapController!.animateCamera(
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
    );
  }

  Widget _itemClinic() {
    return Positioned(
      bottom: 20,
      child: Container(
        padding: const EdgeInsets.only(left: 24),
        width: 400,
        height: 125,
        child: ListView.builder(
          itemCount: listClinic.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) => GestureDetector(
            onTap: () {
              _onSelected(index);
            },
            child: Container(
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.only(bottom: 40, right: 10),
              width: MediaQuery.of(context).size.width * 0.7,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: kWhiteColor,
              ),
              child: ListTile(
                leading: Image.asset(
                  'assets/veterinarian.png',
                  width: 40,
                  height: 40,
                ),
                title: Text(
                  listClinic[index].clinicName!,
                  style: blackTextStyle.copyWith(
                    fontSize: 15,
                    fontWeight: bold,
                  ),
                ),
                subtitle: Text(
                  "Jarak : ${listClinic[index].distance?.toStringAsFixed(4)} km",
                  style: greyTextStyle.copyWith(
                    fontSize: 13,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetailMapPage(
                                  clinicName: listClinic[index].clinicName,
                                  address: listClinic[index].address,
                                  phone: listClinic[index].phoneNumber,
                                  uLat: _currentLocation!.latitude,
                                  uLong: _currentLocation!.longitude,
                                  cLat: listClinic[index].latitude,
                                  cLong: listClinic[index].longitude,
                                  rating: listClinic[index].rating,
                                  reviews: listClinic[index].reviews,
                                  website: listClinic[index].website,
                                  wednesday: listClinic[index].wednesday,
                                  thursday: listClinic[index].thursday,
                                  friday: listClinic[index].friday,
                                  saturday: listClinic[index].saturday,
                                  sunday: listClinic[index].sunday,
                                  monday: listClinic[index].monday,
                                  tuesday: listClinic[index].tuesday,
                                  distance: listClinic[index].distance,
                                )));
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: kRedColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.directions,
                      color: kWhiteColor,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
