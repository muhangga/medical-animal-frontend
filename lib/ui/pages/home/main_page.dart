import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:medical_animal/core/api/api_service.dart';
import 'package:medical_animal/core/common/device_name.dart';
import 'package:medical_animal/core/common/theme.dart';
import 'package:medical_animal/core/services/map_service.dart';
import 'package:medical_animal/core/services/permission_service.dart';
import 'package:medical_animal/ui/pages/home/home_page.dart';
import 'package:medical_animal/ui/pages/home/list_klinik_page.dart';
import 'package:medical_animal/ui/pages/home/map.dart';

class MainPage extends StatefulWidget {
  MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int bottomNavbarIndex = 0;
  PageController? pageController;

  MapService mapService = MapService();
  ApiService apiService = ApiService();
  DeviceName deviceName = DeviceName();

  PermissionService permissionService = PermissionService();
  Position? _currentPosition;
  String? _currentAddress;

  String? deviceNameAndroid;

  void getDeviceName() async {
    deviceName = DeviceName();
    deviceNameAndroid = await deviceName.getDeviceName();
    print(deviceNameAndroid);
  }

  Future<void> _getAddress() async {
    try {
      List<Placemark> placemark = await placemarkFromCoordinates(
          _currentPosition!.latitude, _currentPosition!.longitude);
      Placemark? placemarkData = placemark[0];

      setState(() {
        _currentAddress =
            '${placemarkData.thoroughfare}, ${placemarkData.subLocality} ${placemarkData.locality}, ${placemarkData.subAdministrativeArea} ${placemarkData.administrativeArea}, ${placemarkData.postalCode} ${placemarkData.country}';
        print(_currentAddress.toString());
      });
    } catch (e) {
      print(e);
    }
  }

  void _getUserPosition() async {
    mapService.getGeoLocationPosition().then((value) {
      if (!mounted) return;
      setState(() {
        _currentPosition = value;
        _getAddress();
        apiService.insertUser(_currentPosition!.latitude,
            _currentPosition!.longitude, deviceNameAndroid, _currentAddress);
      });
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      bottomNavbarIndex = index;
      pageController!.animateToPage(index,
          duration: const Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  void _onTappedMap() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const MapPage()));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageController!.dispose();
  }

  @override
  void initState() {
    super.initState();
    _getUserPosition();
    pageController = PageController(initialPage: bottomNavbarIndex);
    permissionService.checkPermission(context);
    getDeviceName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: kBlackColor,
          ),
          SafeArea(
            child: Container(
              color: kWhiteColor,
            ),
          ),
          PageView(
            controller: pageController,
            onPageChanged: (index) {
              setState(() {
                bottomNavbarIndex = index;
              });
            },
            children: [
              HomePage(),
              ListKlinikPage(),
            ],
          ),
          createCustomBottomNavbar(),
          Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 46,
                width: 46,
                margin: const EdgeInsets.only(bottom: 42),
                child: FloatingActionButton(
                  elevation: 0,
                  backgroundColor: const Color(0xffF6C343),
                  child: const SizedBox(
                    height: 26,
                    width: 26,
                    child: Icon(
                      MdiIcons.map,
                      color: kBlackColor,
                    ),
                  ),
                  onPressed: () async {
                    _getUserPosition();
                    _onTappedMap();
                  },
                ),
              )),
        ],
      ),
    );
  }

  Widget createCustomBottomNavbar() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: ClipPath(
        clipper: BottomNavbarClipper(),
        child: Container(
          height: 70,
          decoration: const BoxDecoration(
            color: kWhiteColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: BottomNavigationBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            selectedItemColor: kBlackColor,
            unselectedItemColor: const Color(0xffE5E5E5),
            currentIndex: bottomNavbarIndex,
            onTap: (index) {
              setState(() {
                _onItemTapped(index);
              });
            },
            items: [
              BottomNavigationBarItem(
                label: "Home",
                icon: Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  height: 20,
                  child: Icon(MdiIcons.viewDashboardOutline,
                      color: (bottomNavbarIndex == 0)
                          ? kMainColor
                          : kLightGreyColor),
                ),
              ),
              BottomNavigationBarItem(
                label: "Klinik Hewan",
                icon: Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  height: 20,
                  child: Icon(MdiIcons.texture,
                      color: (bottomNavbarIndex == 1)
                          ? kMainColor
                          : kLightGreyColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BottomNavbarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(size.width / 2 - 28, 0);
    path.quadraticBezierTo(size.width / 2 - 28, 33, size.width / 2, 33);
    path.quadraticBezierTo(size.width / 2 + 28, 33, size.width / 2 + 28, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
