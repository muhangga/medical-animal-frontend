import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:medical_animal/core/api/api_service.dart';
import 'package:medical_animal/core/api/models/clinic_model.dart';
import 'package:medical_animal/core/services/map_service.dart';
import 'package:permission_handler/permission_handler.dart';

class NearbyClinic extends StatefulWidget {
  NearbyClinic({Key? key}) : super(key: key);

  @override
  State<NearbyClinic> createState() => _NearbyClinicState();
}

class _NearbyClinicState extends State<NearbyClinic> {
  Position? _currentPosition;

  List<ClinicModel> listClinic = [];

  Permission permission = Permission.location;

  ApiService apiService = ApiService();

  MapService mapService = MapService();

  _getUserPosition() async {
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

  _nearbyClinicByUser() async {
    await apiService.nearClinic(
        _currentPosition!.latitude, _currentPosition!.longitude);
  }

  // Future<List<ClinicModel>> _nearbyClinic() async {
  //   if (_currentPosition != null) {
  //     await Geolocator.getCurrentPosition(
  //           desiredAccuracy: LocationAccuracy.high,
  //           forceAndroidLocationManager: true)
  //       .then((Position position) {
  //     setState(() {
  //       _currentPosition = position;

  //       list

  //       _nearbyClinicByUser();
  //     });
  //   });
  //     return listClinic;
  //   } else {
  //     return [];
  //   }

  //   return listClinic;
  // }

  @override
  Widget build(BuildContext context) {
    // return FutureBuilder<List<ClinicModel>>(
    //     future: _nearbyClinic(),
    //     builder: (BuildContext context, AsyncSnapshot snapshot) {
    //       if (snapshot.hasData) {
    //         List<ClinicModel> listClinic = snapshot.data;
    //         return SingleChildScrollView(
    //           child: Container(
    //             margin: const EdgeInsets.only(top: 10, bottom: 90),
    //             child: Column(
    //               children: listClinic
    //                   .map((data) => Padding(
    //                         padding: const EdgeInsets.all(8.0),
    //                         child: Card(
    //                           child: ListTile(
    //                             title: Text(
    //                               data.clinicName.toString(),
    //                               overflow: TextOverflow.clip,
    //                             ),
    //                             subtitle: Text(
    //                               data.address.toString(),
    //                               overflow: TextOverflow.clip,
    //                             ),
    //                             trailing: data.distance != null
    //                                 ? Text('${data.distance}' + ' km')
    //                                 : Text('${data.latitude}' +
    //                                     '\n' +
    //                                     '${data.longitude}'),
    //                           ),
    //                         ),
    //                       ))
    //                   .toList(),
    //             ),
    //           ),
    //         );
    //       } else {
    //         return const SizedBox(
    //           height: 340,
    //           child: Center(
    //             child: SpinKitDoubleBounce(
    //               color: kSecondaryColor,
    //             ),
    //           ),
    //         );
    //       }
    //     });
    return Container();
  }
}
