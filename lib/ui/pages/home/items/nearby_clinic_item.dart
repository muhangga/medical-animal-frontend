import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:medical_animal/core/api/api_service.dart';
import 'package:medical_animal/core/api/models/clinic_model.dart';
import 'package:medical_animal/core/common/theme.dart';
import 'package:medical_animal/core/services/map_service.dart';
import 'package:medical_animal/core/services/permission_service.dart';
import 'package:medical_animal/ui/pages/home/detail_map_page.dart';
import 'package:medical_animal/ui/pages/home/detail_page.dart';
import 'package:permission_handler/permission_handler.dart';

class NearbyClinicItem extends StatefulWidget {
  const NearbyClinicItem({Key? key}) : super(key: key);

  @override
  State<NearbyClinicItem> createState() => _NearbyClinicItemState();
}

class _NearbyClinicItemState extends State<NearbyClinicItem> {
  Position? _currentPosition;

  List<ClinicModel> nearbyClinic = [];

  Permission permission = Permission.location;

  ApiService apiService = ApiService();
  MapService mapService = MapService();
  PermissionService permissionService = PermissionService();

  ConnectionState? _connectionState;

  Future<void> _getUserPosition() async {
    await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
            forceAndroidLocationManager: true)
        .then((Position position) {
      if (!mounted) return;
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
        if (!mounted) return;
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
    permissionService.checkPermissionUser();
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
              margin: const EdgeInsets.only(top: 20, bottom: 60),
              child: ListView.builder(
                itemCount: nearbyClinic.length,
                itemBuilder: (context, index) {
                  if (nearbyClinic.isEmpty) {
                    return const Center(
                      child: Text('No Data'),
                    );
                  }
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailMapPage(
                                    clinicName: nearbyClinic[index].clinicName,
                                    address: nearbyClinic[index].address,
                                    phone: nearbyClinic[index].phoneNumber,
                                    uLat: _currentPosition!.latitude,
                                    uLong: _currentPosition!.longitude,
                                    cLat: nearbyClinic[index].latitude,
                                    cLong: nearbyClinic[index].longitude,
                                    rating: nearbyClinic[index].rating,
                                    website: nearbyClinic[index].website,
                                    reviews: nearbyClinic[index].reviews,
                                    wednesday: nearbyClinic[index]
                                        .wednesday
                                        .toString(),
                                    thursday: nearbyClinic[index].thursday,
                                    friday: nearbyClinic[index].friday,
                                    saturday: nearbyClinic[index].saturday,
                                    sunday: nearbyClinic[index].sunday,
                                    monday: nearbyClinic[index].monday,
                                    tuesday: nearbyClinic[index].tuesday,
                                    distance: nearbyClinic[index].distance,
                                  )));
                    },
                    child: Container(
                        margin: const EdgeInsets.only(bottom: 2),
                        child: Card(
                            // elevation: 1,
                            child: Container(
                          padding: const EdgeInsets.all(10),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(6),
                            leading: Image.asset(
                              'assets/ic_clinic2.png',
                              width: 50,
                              height: 50,
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
                        ))),
                  );
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
