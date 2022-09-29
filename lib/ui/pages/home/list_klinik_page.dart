import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:medical_animal/core/api/api_service.dart';
import 'package:medical_animal/core/api/models/clinic_model.dart';
import 'package:medical_animal/core/common/theme.dart';
import 'package:medical_animal/core/services/map_service.dart';
import 'package:medical_animal/ui/pages/home/items/nearby_clinic.dart';
import 'package:permission_handler/permission_handler.dart';

class ListKlinikPage extends StatefulWidget {
  const ListKlinikPage({Key? key}) : super(key: key);

  @override
  State<ListKlinikPage> createState() => _ListKlinikPageState();
}

class _ListKlinikPageState extends State<ListKlinikPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  Position? _currentPosition;
  LatLng? _currentLocation;

  List<ClinicModel> listClinic = [];
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

  // Future<void> _getUserPosition() async {
  //   await Geolocator.getCurrentPosition(
  //           desiredAccuracy: LocationAccuracy.high,
  //           forceAndroidLocationManager: true)
  //       .then((Position position) {
  //     setState(() {
  //       _currentPosition = position;
  //     });
  //   }).catchError((e) {
  //     print(e);
  //   });
  // }

  // Future<void> _nearbyClinicByUser() async {
  //   if (_currentPosition != null) {
  //     await apiService
  //         .nearClinic(_currentPosition!.latitude, _currentPosition!.longitude)
  //         .then((value) {
  //       setState(() {
  //         nearbyClinic = value;
  //       });
  //     });
  //   } else {
  //     print('null');
  //   }
  // }

  // Future<void> getUserAndNearClinicLocation() async {
  //   await _getUserPosition();
  //   await _nearbyClinicByUser();
  // }

  final List<Tab> myTabs = [
    const Tab(
        child: Text("Semua", style: TextStyle(fontWeight: FontWeight.bold))),
    const Tab(
        child: Text("Terdekat", style: TextStyle(fontWeight: FontWeight.bold))),
  ];

  @override
  void initState() {
    super.initState();
    checkPermission();

    // print(getUserAndNearClinicLocation());
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
            // // _nearbyClinicWidget(),
            NearbyClinic(),
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

}
