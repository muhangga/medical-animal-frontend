import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:medical_animal/core/common/theme.dart';
import 'package:medical_animal/core/services/map_service.dart';
import 'package:medical_animal/ui/pages/home/home_page.dart';
import 'package:medical_animal/ui/pages/home/list_klinik_page.dart';
import 'package:medical_animal/ui/pages/home/map_near_clinics.dart';
import 'package:permission_handler/permission_handler.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int bottomNavbarIndex = 0;
  PageController? pageController;
  Permission permission = Permission.location;

  MapService mapService = MapService();

  void _onItemTapped(int index) {
    setState(() {
      bottomNavbarIndex = index;
      pageController!.animateToPage(index,
          duration: const Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  void permissionCheck() async {
    if (await permission.isGranted) {
      print('Permission is granted');
    } else {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.location,
      ].request();

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          'Aktifkan Lokasi untuk menggunakan fitur ini',
          style: whiteTextStyle,
        ),
      ));

      print(statuses[Permission.location]);
    }
  }

  @override
  void initState() {
    super.initState();
    mapService.getGeoLocationPosition();
    pageController = PageController(initialPage: bottomNavbarIndex);
    permissionCheck();

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
            children: const [
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
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const MapNearClinics();
                  }));
                },
              ),
            ),
          )
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
                title: Text(
                  'Home',
                  style: GoogleFonts.raleway(fontSize: 12, fontWeight: bold),
                ),
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
                title: Text(
                  'Klinik Hewan',
                  style: GoogleFonts.raleway(fontSize: 12, fontWeight: bold),
                ),
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
