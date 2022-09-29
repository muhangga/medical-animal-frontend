import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:medical_animal/core/api/api_service.dart';
import 'package:medical_animal/core/api/models/clinic_model.dart';
import 'package:medical_animal/core/common/theme.dart';
import 'package:medical_animal/core/services/map_service.dart';
import 'package:permission_handler/permission_handler.dart';

class NearbyClinic extends StatefulWidget {
  NearbyClinic({Key? key}) : super(key: key);

  @override
  State<NearbyClinic> createState() => _NearbyClinicState();
}

class _NearbyClinicState extends State<NearbyClinic> {
  Position? _currentPosition;

  List<ClinicModel> nearbyClinic = [];

  Permission permission = Permission.location;

  ApiService apiService = ApiService();

  MapService mapService = MapService();

  void checkPermission() async {
    if (await permission.isGranted) {
      print('permission granted');
    }

    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
    ].request();
    print(statuses[Permission.location]);
  }

  Future<void> _getUserPosition() async {
    await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
            forceAndroidLocationManager: true)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
    }).catchError((e) {
      print(e);
    });
  }

  Future<void> _nearbyClinicByUser() async {
    if (_currentPosition != null) {
      await apiService
          .nearClinic(_currentPosition!.latitude, _currentPosition!.longitude)
          .then((value) {
        setState(() {
          nearbyClinic = value;
        });
      });
    } else {
      print('null');
    }
  }

  Future<void> getUserAndNearClinicLocation() async {
    await _getUserPosition();
    await _nearbyClinicByUser();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkPermission();
    print(getUserAndNearClinicLocation());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.9,
            padding: EdgeInsets.only(left: 10, right: 10, bottom: 20),
            margin: EdgeInsets.only(top: 20, bottom: 60),
            child: ListView.builder(
              itemCount: nearbyClinic.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Card(
                    elevation: 5,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            nearbyClinic[index].clinicName!,
                            style: blackTextStyle.copyWith(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            nearbyClinic[index].address!,
                            style: blackTextStyle.copyWith(
                                fontSize: 14, fontWeight: FontWeight.w300),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            nearbyClinic[index].phoneNumber!,
                            style: blackTextStyle.copyWith(
                                fontSize: 14, fontWeight: FontWeight.w300),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            nearbyClinic[index].distance!.toString(),
                            style: blackTextStyle.copyWith(
                                fontSize: 14, fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
