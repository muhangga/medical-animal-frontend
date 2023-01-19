import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:medical_animal/core/api/api_service.dart';
import 'package:medical_animal/core/api/models/users_model.dart';
import 'package:medical_animal/core/common/device_name.dart';
import 'package:medical_animal/core/common/theme.dart';
import 'package:medical_animal/core/services/map_service.dart';
import 'package:medical_animal/core/services/permission_service.dart';
import 'package:medical_animal/ui/pages/home/main_page.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({Key? key}) : super(key: key);

  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  MapService mapService = MapService();
  ApiService apiService = ApiService();
  DeviceName deviceName = DeviceName();

  PermissionService permissionService = PermissionService();
  Position? _currentPosition;

  String? deviceNameAndroid;

  void getDeviceName() async {
    deviceName = DeviceName();
    deviceNameAndroid = await deviceName.getDeviceName();
    print(deviceNameAndroid);
  }

  Future<void> _getUserPosition() async {
    mapService.getGeoLocationPosition().then((value) {
      if (!mounted) return;
      setState(() {
        _currentPosition = value;
      });
    });
  }

  Future<void> insertDataUser() async {
    if (_currentPosition != null) {
      await apiService
          .insertUser(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        deviceNameAndroid,
      )
          .then((value) {
        if (!mounted) return;
        setState(() {
          _currentPosition = value as Position?;
        });
      });
    } else {
      print('null');
    }
  }

  Future<void> handleInsert() async {
    await _getUserPosition();
    await insertDataUser();
  }

  @override
  void initState() {
    super.initState();
    permissionService.checkPermission(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Image.asset('assets/ic_user.png', width: 190, height: 190),
            const SizedBox(height: 50),
            Positioned(
              bottom: 0,
              child: Container(
                width: double.infinity,
                height: 240,
                padding: const EdgeInsets.symmetric(vertical: 40),
                decoration: const BoxDecoration(
                  color: kSecondaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      "Klinik Hewan Terdekat",
                      style: whiteTextStyle.copyWith(
                          fontSize: 24, fontWeight: bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Cari Klinik Hewan Terdekat dari posisi anda sekarang",
                      style: whiteTextStyle,
                    ),
                    const SizedBox(height: 30),
                    Container(
                      width: 240,
                      height: 50,
                      child: ButtonToMainPage(context),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget ButtonToMainPage(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await handleInsert();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainPage(),
          ),
        );
      },
      child: Container(
        width: 150,
        height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30), color: kRedColor),
        child: Center(
          child: Text(
            "Hidupkan Lokasi",
            style: whiteTextStyle.copyWith(fontWeight: bold),
          ),
        ),
      ),
    );
  }
}
