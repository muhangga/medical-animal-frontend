import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:medical_animal/core/api/api_service.dart';
import 'package:medical_animal/core/api/models/clinic_model.dart';
import 'package:medical_animal/core/common/theme.dart';
import 'package:medical_animal/core/services/permission_service.dart';
import 'package:medical_animal/ui/pages/home/detail_map_page.dart';
import 'package:medical_animal/ui/pages/home/detail_page.dart';

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
      await apiService.getClinic().then((value) {
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
    Future.delayed(const Duration(seconds: 4), () async {
      await _getUserPosition();
      await _getAllClinic();
    });
  }

  @override
  void initState() {
    super.initState();
    permissionService.checkPermissionUser();
    print(getAllClinic());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: allClinic.isEmpty
          ? const Center(
              child: SpinKitFadingCircle(
                color: kMainColor,
                size: 50.0,
              ),
            )
          : Container(
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
                            wednesday: allClinic[index].wednesday,
                            thursday: allClinic[index].thursday,
                            friday: allClinic[index].friday,
                            saturday: allClinic[index].saturday,
                            sunday: allClinic[index].sunday,
                            monday: allClinic[index].monday,
                            tuesday: allClinic[index].tuesday,
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
                          textAlign: TextAlign.justify,
                        ),
                        trailing: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.directions,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    )),
                  );
                },
              ),
            ),
    );
  }
}


// return FutureBuilder<List<ClinicModel>>(
//       future: apiService.getClinic(),
//       builder: (BuildContext context, AsyncSnapshot snapshot) {
//         if (snapshot.hasData) {
//           List<ClinicModel> listClinic = snapshot.data;
//           return SingleChildScrollView(
//             child: Container(
//               margin: const EdgeInsets.only(top: 10, bottom: 90),
//               child: Column(
//                 children: listClinic
//                     .map((data) => Container(
//                         margin: const EdgeInsets.only(bottom: 2),
//                         child: GestureDetector(
//                           onTap: () {
//                             Navigator.push(context,
//                                 MaterialPageRoute(builder: (context) {
//                               return DetailPage(
//                                 clinicName: data.clinicName,
//                                 address: data.address,
//                                 phone: data.phoneNumber,
//                                 cLat: data.latitude,
//                                 cLong: data.longitude,
//                                 wednesday: data.wednesday,
//                                 thursday: data.thursday,
//                                 friday: data.friday,
//                                 saturday: data.saturday,
//                                 sunday: data.sunday,
//                                 monday: data.monday,
//                                 tuesday: data.tuesday,
//                               );
//                             }));
//                           },
//                           child: Card(
//                               child: Container(
//                             padding: const EdgeInsets.all(10),
//                             child: ListTile(
//                               contentPadding: const EdgeInsets.all(6),
//                               leading: const Icon(
//                                 Icons.location_on,
//                                 color: Colors.red,
//                               ),
//                               title: Text(
//                                 data.clinicName!,
//                                 style: blackTextStyle.copyWith(
//                                     fontSize: 18, fontWeight: bold),
//                               ),
//                               subtitle: Text(
//                                 data.address!,
//                                 style: greyTextStyle.copyWith(fontSize: 14),
//                                 textAlign: TextAlign.justify,
//                               ),
//                               trailing: IconButton(
//                                 onPressed: () {},
//                                 icon: const Icon(
//                                   Icons.directions,
//                                   color: Colors.red,
//                                 ),
//                               ),
//                             ),
//                           )),
//                         )))
//                     .toList(),
//               ),
//             ),
//           );
//         } else {
//           return const SizedBox(
//             height: 340,
//             child: Center(
//               child: SpinKitDoubleBounce(
//                 color: kSecondaryColor,
//               ),
//             ),
//           );
//         }
//       },
//     );