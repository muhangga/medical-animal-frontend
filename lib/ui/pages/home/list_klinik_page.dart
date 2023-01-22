import 'package:flutter/material.dart';
import 'package:medical_animal/core/api/api_service.dart';
import 'package:medical_animal/core/api/models/clinic_model.dart';
import 'package:medical_animal/core/common/theme.dart';
import 'package:medical_animal/core/services/map_service.dart';
import 'package:medical_animal/core/services/permission_service.dart';
import 'package:medical_animal/ui/pages/home/items/all_list_clinic_item.dart';
import 'package:medical_animal/ui/pages/home/items/nearby_clinic_item.dart';

class ListKlinikPage extends StatefulWidget {
  const ListKlinikPage({Key? key}) : super(key: key);

  @override
  State<ListKlinikPage> createState() => _ListKlinikPageState();
}

class _ListKlinikPageState extends State<ListKlinikPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  List<ClinicModel> listClinic = [];
  List<ClinicModel> nearbyClinic = [];

  ApiService apiService = ApiService();
  MapService mapService = MapService();
  PermissionService permissionService = PermissionService();

  final List<Tab> myTabs = [
    const Tab(
        child: Text("Semua", style: TextStyle(fontWeight: FontWeight.bold))),
    const Tab(
      child: Text("Terdekat", style: TextStyle(fontWeight: FontWeight.bold)),
    ),
  ];

  @override
  void initState() {
    super.initState();
    permissionService.checkPermission(context);
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
        backgroundColor: Color(0xffF5F5F5),
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
          children: const [
            AllClinicItem(),
            NearbyClinicItem(),
          ],
        )),
      ),
    );
  }
}
