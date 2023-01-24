import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:medical_animal/core/api/api_service.dart';
import 'package:medical_animal/core/api/models/clinic_model.dart';
import 'package:medical_animal/core/common/theme.dart';
import 'package:medical_animal/core/services/map_service.dart';
import 'package:medical_animal/core/services/permission_service.dart';
import 'package:medical_animal/ui/pages/home/detail_map_page.dart';
import 'package:medical_animal/ui/widgets/location_off_widget.dart';
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
  ConnectionState? connectionState;

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
    permissionService.checkPermission(context);
    print(getUserAndNearClinicLocation());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentPosition == null
          ? locationOffWidget()
          : _currentPosition != null
              ? Column(
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
                                              clinicName: nearbyClinic[index]
                                                  .clinicName
                                                  .toString(),
                                              address: nearbyClinic[index]
                                                  .address
                                                  .toString(),
                                              phone: nearbyClinic[index]
                                                  .phoneNumber,
                                              uLat: _currentPosition!.latitude,
                                              uLong:
                                                  _currentPosition!.longitude,
                                              cLat:
                                                  nearbyClinic[index].latitude,
                                              cLong:
                                                  nearbyClinic[index].longitude,
                                              rating:
                                                  nearbyClinic[index].rating,
                                              reviews:
                                                  nearbyClinic[index].reviews,
                                              website: nearbyClinic[index]
                                                  .website
                                                  .toString(),
                                              wednesday: nearbyClinic[index]
                                                  .wednesday
                                                  .toString(),
                                              thursday: nearbyClinic[index]
                                                  .thursday
                                                  .toString(),
                                              friday: nearbyClinic[index]
                                                  .friday
                                                  .toString(),
                                              saturday: nearbyClinic[index]
                                                  .saturday
                                                  .toString(),
                                              sunday: nearbyClinic[index]
                                                  .sunday
                                                  .toString(),
                                              monday: nearbyClinic[index]
                                                  .monday
                                                  .toString(),
                                              tuesday: nearbyClinic[index]
                                                  .tuesday
                                                  .toString(),
                                              konsultasi: nearbyClinic[index]
                                                  .konsultasi
                                                  .toString(),
                                              layananMedis: nearbyClinic[index]
                                                  .layananMedis
                                                  .toString(),
                                              penginapan: nearbyClinic[index]
                                                  .penginapan
                                                  .toString(),
                                              grooming: nearbyClinic[index]
                                                  .grooming
                                                  .toString(),
                                              distance:
                                                  nearbyClinic[index].distance,
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
                                      subtitle: Text(
                                          nearbyClinic[index].address!,
                                          style: greyTextStyle.copyWith(
                                              fontSize: 14)),
                                      trailing: Text(
                                        nearbyClinic[index]
                                                .distance!
                                                .toStringAsFixed(2) +
                                            ' km',
                                        style: redTextStyle.copyWith(
                                            fontSize: 14, fontWeight: bold),
                                      ),
                                    ),
                                  ))),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                )
              : const SizedBox(
                  height: 340,
                  child: Center(
                    child: SpinKitDoubleBounce(
                      color: kSecondaryColor,
                    ),
                  ),
                ),
    );
  }
}
