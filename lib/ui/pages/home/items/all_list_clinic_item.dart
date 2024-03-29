import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:medical_animal/core/api/api_service.dart';
import 'package:medical_animal/core/api/models/clinic_model.dart';
import 'package:medical_animal/core/common/theme.dart';
import 'package:medical_animal/core/services/permission_service.dart';
import 'package:medical_animal/ui/pages/home/detail_map_page.dart';

class AllClinicItem extends StatefulWidget {
  const AllClinicItem({Key? key}) : super(key: key);

  @override
  State<AllClinicItem> createState() => _AllClinicItemState();
}

class _AllClinicItemState extends State<AllClinicItem> {
  List<ClinicModel> allClinic = [];

  ApiService apiService = ApiService();
  PermissionService permissionService = PermissionService();

  Position? _currentPosition;

  Future<void> _getUserPosition() async {
    await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
            forceAndroidLocationManager: true)
        .then((Position position) {
      if (!mounted) return;
      setState(() {
        _currentPosition = position;
      });
    }).catchError((e) => print(e));
  }

  Future<void> _getAllClinic() async {
    if (_currentPosition != null) {
      await apiService
          .getClinic(_currentPosition!.latitude, _currentPosition!.longitude)
          .then((value) {
        if (!mounted) return;
        setState(() {
          allClinic = value;
        });
      });
    } else {
      print('null');
    }
  }

  Future<void> getAllClinic() async {
    Future.delayed(const Duration(seconds: 1), () async {
      await _getUserPosition();
      await _getAllClinic();
    });
  }

  @override
  void initState() {
    super.initState();
    permissionService.checkPermission(context);
    print(getAllClinic());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _currentPosition != null
            ? Container(
                margin: const EdgeInsets.only(bottom: 90, top: 20),
                child: ListView.builder(
                  itemCount: allClinic.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailMapPage(
                              clinicName: allClinic[index].clinicName,
                              address: allClinic[index].address,
                              phone: allClinic[index].phoneNumber,
                              uLat: _currentPosition!.latitude,
                              uLong: _currentPosition!.longitude,
                              cLat: allClinic[index].latitude,
                              cLong: allClinic[index].longitude,
                              rating: allClinic[index].rating,
                              website: allClinic[index].website,
                              reviews: allClinic[index].reviews,
                              wednesday: allClinic[index].wednesday,
                              thursday: allClinic[index].thursday,
                              friday: allClinic[index].friday,
                              saturday: allClinic[index].saturday,
                              sunday: allClinic[index].sunday,
                              monday: allClinic[index].monday,
                              tuesday: allClinic[index].tuesday,
                              konsultasi: allClinic[index].konsultasi,
                              layananMedis: allClinic[index].layananMedis,
                              penginapan: allClinic[index].penginapan,
                              grooming: allClinic[index].grooming,
                              distance: allClinic[index].distance,
                            ),
                          ),
                        );
                      },
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
                            allClinic[index].clinicName.toString(),
                            style: blackTextStyle.copyWith(
                                fontSize: 18, fontWeight: bold),
                          ),
                          subtitle: Text(
                            allClinic[index].address.toString(),
                            style: greyTextStyle.copyWith(fontSize: 14),
                          ),
                          trailing: Text(
                            allClinic[index].distance!.toStringAsFixed(2) +
                                " km",
                            style: redTextStyle.copyWith(
                                fontSize: 14, fontWeight: bold),
                          ),
                        ),
                      )),
                    );
                  },
                ),
              )
            : const Center(
                child: SpinKitFadingCircle(
                  color: kMainColor,
                  size: 50.0,
                ),
              ));
  }
}
