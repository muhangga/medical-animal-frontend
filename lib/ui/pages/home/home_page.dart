import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:medical_animal/core/common/theme.dart';
import 'package:medical_animal/core/services/map_service.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  MapService mapService = MapService();
  Position? _currentPosition;
  String? _currentAddress;

  double? userLat;
  double? userLong;

  void _getUserCurrentLocation() async {
    mapService.getGeoLocationPosition().then((value) {
      if (!mounted) {
        return;
      }
      setState(() {
        _currentPosition = value;
        userLat = _currentPosition!.latitude;
        userLong = _currentPosition!.longitude;
        _getAddressFromLatLng();
      });
    });
  }

  void _getAddressFromLatLng() async {
    try {
      List<Placemark> placemark = await placemarkFromCoordinates(
          _currentPosition!.latitude, _currentPosition!.longitude);
      Placemark? placemarkData = placemark[0];
      if (!mounted) {
        return;
      }
      setState(() {
        _currentAddress =
            '${placemarkData.thoroughfare}, ${placemarkData.subLocality} ${placemarkData.locality}, ${placemarkData.subAdministrativeArea} ${placemarkData.administrativeArea}, ${placemarkData.postalCode} ${placemarkData.country}';
        print(_currentAddress.toString());
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _getUserCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF1F1F1),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 130,
              decoration: const BoxDecoration(
                color: kSecondaryColor,
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                child: Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 15, left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Pencarian Klinik Hewan",
                              style: whiteTextStyle.copyWith(
                                  fontSize: 20, fontWeight: semiBold),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "Cari Klinik Hewan terdekat!",
                              style: greyTextStyle.copyWith(
                                  fontSize: 14, fontWeight: medium),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 20),
              child: Text("Lokasi Anda",
                  style: blackTextStyle.copyWith(
                      fontSize: 20, fontWeight: semiBold)),
            ),
            const Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 20, top: 40),
                child: SizedBox(
                  child: Icon(
                    MdiIcons.mapMarker,
                    size: 110,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        "Latitude",
                        style: blackTextStyle.copyWith(
                            fontSize: 20, fontWeight: bold),
                      ),
                      const SizedBox(height: 10),
                      userLat == null
                          ? const SpinKitFadingCircle(
                              color: Colors.red,
                              size: 25,
                            )
                          : Text(
                              userLat.toString(),
                              style: greyTextStyle.copyWith(
                                  fontSize: 16, fontWeight: medium),
                              overflow: TextOverflow.clip,
                            ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "Longitude",
                        style: blackTextStyle.copyWith(
                            fontSize: 20, fontWeight: bold),
                      ),
                      const SizedBox(height: 10),
                      userLong == null
                          ? const SpinKitFadingCircle(
                              color: Colors.red,
                              size: 25,
                            )
                          : Text(
                              userLong.toString(),
                              style: greyTextStyle.copyWith(
                                  fontSize: 16, fontWeight: medium),
                              overflow: TextOverflow.clip,
                            ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Center(
                child: Column(
                  children: [
                    Text(
                      "Alamat",
                      style: blackTextStyle.copyWith(
                          fontSize: 20, fontWeight: bold),
                    ),
                    const SizedBox(height: 10),
                    _currentAddress == null
                        ? const SpinKitFadingCircle(
                            color: Colors.red,
                            size: 25,
                          )
                        : Text(
                            _currentAddress ?? "Mencari alamat...",
                            style: greyTextStyle.copyWith(
                                fontSize: 16, fontWeight: medium),
                            overflow: TextOverflow.clip,
                            textAlign: TextAlign.center,
                          ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
