import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:medical_animal/core/api/api_service.dart';
import 'package:medical_animal/core/api/models/clinic_model.dart';
import 'package:medical_animal/core/common/theme.dart';
import 'package:medical_animal/core/services/map_service.dart';
import 'package:medical_animal/ui/widgets/empty_item_widget.dart';
import 'package:medical_animal/ui/widgets/empty_location_widget.dart';
import 'package:permission_handler/permission_handler.dart';

class NearbyClinicItem extends StatefulWidget {
  NearbyClinicItem({Key? key}) : super(key: key);

  @override
  State<NearbyClinicItem> createState() => _NearbyClinicItemState();
}

class _NearbyClinicItemState extends State<NearbyClinicItem> {
  Position? _currentPosition;

  List<ClinicModel> nearbyClinic = [];

  Permission permission = Permission.location;

  ApiService apiService = ApiService();

  MapService mapService = MapService();

  ConnectionState? _connectionState;

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
    super.initState();
    checkPermission();
    print(getUserAndNearClinicLocation());
  }

  @override
  Widget build(BuildContext context) {
    if (_currentPosition != null) {
      return Column(
        children: [
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.9,
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
              margin: const EdgeInsets.only(top: 20, bottom: 60),
              child: ListView.builder(
                itemCount: nearbyClinic.length,
                itemBuilder: (context, index) {
                  if (nearbyClinic.isEmpty) {
                    return const Center(
                      child: Text('No Data'),
                    );
                  }
                  return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Card(
                          child: Container(
                        padding: const EdgeInsets.all(10),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(6),
                          leading: const Icon(
                            Icons.location_on,
                            color: Colors.red,
                          ),
                          title: Text(
                            nearbyClinic[index].clinicName!,
                            style: blackTextStyle.copyWith(
                                fontSize: 18, fontWeight: bold),
                          ),
                          subtitle: Text(nearbyClinic[index].address!,
                              style: greyTextStyle.copyWith(fontSize: 14)),
                          trailing: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.directions,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      )));
                },
              ),
            ),
          ),
        ],
      );
    } else {
      return const SizedBox(
        height: 340,
        child: Center(
          child: SpinKitDoubleBounce(
            color: kSecondaryColor,
          ),
        ),
      );
    }
  }
}
