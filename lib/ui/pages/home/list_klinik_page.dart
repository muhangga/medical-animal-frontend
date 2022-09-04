import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:medical_animal/core/api/api_service.dart';
import 'package:medical_animal/core/api/models/clinic_model.dart';
import 'package:medical_animal/core/common/theme.dart';
import 'package:medical_animal/core/services/map_service.dart';

// class ListKlinikPage extends StatefulWidget {
//   const ListKlinikPage({Key? key}) : super(key: key);

//   @override
//   State<ListKlinikPage> createState() => _ListKlinikPageState();
// }

// class _ListKlinikPageState extends State<ListKlinikPage> {
//   bool isNearby = true;

//   ApiService apiService = ApiService();
//   MapService mapService = MapService();

//   List<ClinicModel> listClinic = [];

//   Position? _currentPosition;

//   Future<void> _getUserCurrentLocation() async {
//     mapService.getGeoLocationPosition();

//     await Geolocator.getCurrentPosition(
//             desiredAccuracy: LocationAccuracy.high,
//             forceAndroidLocationManager: true)
//         .then((Position position) {
//       setState(() {
//         _currentPosition = position;
//       });
//     }).catchError((e) {
//       print(e);
//     });
//   }

//   Future<List<ClinicModel>> _getNearbyClinic() async {
//     await _getUserCurrentLocation();
//     return apiService.nearClinic(
//         _currentPosition!.latitude, _currentPosition!.longitude);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           children: <Widget>[
//             SafeArea(
//                 child: ClipPath(
//               clipper: HeaderClipper(),
//               child: Container(
//                 height: 140,
//                 color: kSecondaryColor,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: <Widget>[
//                     Container(
//                         margin: const EdgeInsets.only(left: 24, bottom: 32),
//                         child: Text(
//                           "Data Klinik Hewan",
//                           style: whiteTextStyle.copyWith(fontSize: 20),
//                         )),
//                     Row(
//                       children: <Widget>[
//                         Column(
//                           children: <Widget>[
//                             GestureDetector(
//                               onTap: () {
//                                 setState(() {
//                                   isNearby = !isNearby;
//                                 });
//                               },
//                               child: Text(
//                                 "Semua",
//                                 style: whiteTextStyle.copyWith(
//                                     fontSize: 16,
//                                     color: isNearby ? kWhiteColor : kMainColor),
//                               ),
//                             ),
//                             const SizedBox(
//                               height: 15,
//                             ),
//                             Container(
//                                 height: 4,
//                                 width: MediaQuery.of(context).size.width * 0.5,
//                                 color: !isNearby ? kMainColor : kYellowColor),
//                           ],
//                         ),
//                         Column(
//                           children: <Widget>[
//                             GestureDetector(
//                               onTap: () {
//                                 setState(() {
//                                   isNearby = !isNearby;
//                                 });
//                               },
//                               child: Text(
//                                 "Terdekat",
//                                 style: whiteTextStyle.copyWith(
//                                     fontSize: 16,
//                                     color: isNearby ? kMainColor : kWhiteColor),
//                               ),
//                             ),
//                             const SizedBox(
//                               height: 15,
//                             ),
//                             Container(
//                                 height: 4,
//                                 width: MediaQuery.of(context).size.width * 0.5,
//                                 color: isNearby ? kMainColor : kYellowColor),
//                           ],
//                         )
//                       ],
//                     )
//                   ],
//                 ),
//               ),
//             )),
//             FutureBuilder<List<ClinicModel>>(
//                 future: apiService.getClinic(),
//                 builder: (BuildContext context, AsyncSnapshot snapshot) {
//                   if (snapshot.hasData) {
//                     List<ClinicModel> listClinic = snapshot.data;
//                     return Container(
//                       margin: const EdgeInsets.only(top: 10, bottom: 90),
//                       child: Column(
//                         children: listClinic
//                             .map((data) => Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Card(
//                                     child: ListTile(
//                                       title: Text(
//                                         data.clinicName.toString(),
//                                         overflow: TextOverflow.clip,
//                                       ),
//                                       subtitle: Text(
//                                         data.address.toString(),
//                                         overflow: TextOverflow.clip,
//                                       ),
//                                       trailing: data.distance != null
//                                           ? Text('${data.distance}' + ' km')
//                                           : Text('${data.latitude}' +
//                                               '\n' +
//                                               '${data.longitude}'),
//                                     ),
//                                   ),
//                                 ))
//                             .toList(),
//                       ),
//                     );
//                   } else {
//                     return const SizedBox(
//                       height: 340,
//                       child: Center(
//                         child: SpinKitDoubleBounce(
//                           color: kSecondaryColor,
//                         ),
//                       ),
//                     );
//                   }
//                 }),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class HeaderClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     Path path = Path();

//     path.lineTo(0, size.height - 20);
//     path.quadraticBezierTo(0, size.height, 20, size.height);
//     path.lineTo(size.width - 20, size.height);
//     path.quadraticBezierTo(
//         size.width, size.height, size.width, size.height - 20);
//     path.lineTo(size.width, 0);

//     path.close();

//     return path;
//   }

//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) => false;
// }

import 'package:flutter/material.dart';

class ListKlinikPage extends StatefulWidget {
  const ListKlinikPage({Key? key}) : super(key: key);

  @override
  State<ListKlinikPage> createState() => _ListKlinikPageState();
}

class _ListKlinikPageState extends State<ListKlinikPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  Position? _currentPosition;

  List<ClinicModel> listClinic = [];

  ApiService apiService = ApiService();
  MapService mapService = MapService();

  _getUserCurrentLocation() async {
    await mapService.getGeoLocationPosition().then((value) {
      setState(() {
        _currentPosition = value;
      });
    });
  }

  Future<List<ClinicModel>> _getNearbyClinic() async {
    return apiService.nearClinic(
        _currentPosition!.latitude, _currentPosition!.longitude);
  }

  final List<Tab> myTabs = [
    const Tab(
        child: Text("Semua", style: TextStyle(fontWeight: FontWeight.bold))),
    const Tab(
        child: Text("Terdekat", style: TextStyle(fontWeight: FontWeight.bold))),
  ];

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: myTabs.length, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(130),
          child: AppBar(
            backgroundColor: kSecondaryColor,
            title: Container(
              margin: const EdgeInsets.only(top: 30, left: 5),
              child: Text(
                "Data Klinik Hewan",
                style: whiteTextStyle.copyWith(
                  fontSize: 18,
                  fontWeight: bold,
                ),
              ),
            ),
            bottom: TabBar(
              unselectedLabelColor: kGreyColor,
              indicatorColor: kYellowColor,
              indicatorWeight: 4,
              controller: _tabController,
              tabs: myTabs,
            ),
          ),
        ),
        body: SafeArea(
            child: TabBarView(
          controller: _tabController,
          children: [
            _allClinicWidget(),
            // _nearbyClinicWidget(),
            const Center(child: Text("test"))
          ],
        )),
      ),
    );
  }

  Widget _allClinicWidget() {
    return FutureBuilder<List<ClinicModel>>(
      future: apiService.getClinic(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          List<ClinicModel> listClinic = snapshot.data;
          return SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.only(top: 10, bottom: 90),
              child: Column(
                children: listClinic
                    .map((data) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            child: ListTile(
                              title: Text(
                                data.clinicName.toString(),
                                overflow: TextOverflow.clip,
                              ),
                              subtitle: Text(
                                data.address.toString(),
                                overflow: TextOverflow.clip,
                              ),
                              trailing: data.distance != null
                                  ? Text('${data.distance}' + ' km')
                                  : Text('${data.latitude}' +
                                      '\n' +
                                      '${data.longitude}'),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
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
      },
    );
  }

  // Widget _nearbyClinicWidget() {
  //   return FutureBuilder(
  //     future: _getNearbyClinic(),
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
  //     },
  //   );
  // }
}
