import 'dart:convert';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:medical_animal/core/api/api_service.dart';
import 'package:medical_animal/core/api/models/route_model.dart';
import 'package:medical_animal/core/api/models/route_navigation_model.dart';
import 'package:medical_animal/core/common/constant.dart';
import 'package:medical_animal/core/common/theme.dart';

import 'package:medical_animal/core/services/mapbox_directions.dart';
import 'package:medical_animal/ui/pages/home/turn_navigation.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailMapPage extends StatefulWidget {
  String? clinicName;
  String? address;
  String? phone;
  double? uLat;
  double? uLong;
  double? cLat;
  double? cLong;
  double? rating;
  int? reviews;
  String? website;
  String? wednesday;
  String? thursday;
  String? friday;
  String? saturday;
  String? sunday;
  String? monday;
  String? tuesday;
  double? distance;
  DetailMapPage(
      {Key? key,
      this.clinicName,
      this.address,
      this.phone,
      this.uLat,
      this.uLong,
      this.cLat,
      this.cLong,
      this.rating,
      this.reviews,
      this.website,
      this.wednesday,
      this.thursday,
      this.friday,
      this.saturday,
      this.sunday,
      this.monday,
      this.tuesday,
      this.distance})
      : super(key: key);

  @override
  State<DetailMapPage> createState() => _DetailMapPageState();
}

class _DetailMapPageState extends State<DetailMapPage> {
  MapboxMapController? mapController;
  MapboxService mapboxService = MapboxService();

  ApiService apiService = ApiService();

  List<RouteModel> routeModelList = [];
  late List<RouteNavigationModel> routeNavigationModelList = [];

  RouteModel routeModel = RouteModel();

  int? index = 0;

  void _directionsPolyline() async {
    final _directions = await mapboxService.getDirectionAPIResponse(
        widget.uLong!, widget.uLat!, widget.cLong!, widget.cLat!);

    Map geometry = _directions['geometry'];

    final _fills = {
      "type": "FeatureCollection",
      "features": [
        {
          "type": "Feature",
          "id": 0,
          "properties": <String, dynamic>{},
          "geometry": geometry,
        },
      ]
    };

    await mapController!
        .addSource("fills", GeojsonSourceProperties(data: _fills));
    await mapController!.addLineLayer(
        "fills",
        "lines",
        LineLayerProperties(
          lineColor: Colors.green.toHexStringRGB(),
          lineWidth: 5.0,
          lineCap: "round",
          lineJoin: "round",
        ));
  }

  void _setMarker() async {
    mapController!.addSymbol(SymbolOptions(
      geometry: LatLng(widget.uLat!, widget.uLong!),
      iconImage: 'assets/ic_user2.png',
      iconSize: 0.3,
      zIndex: 99,
    ));

    mapController!.addSymbol(SymbolOptions(
      geometry: LatLng(widget.cLat!, widget.cLong!),
      iconImage: 'assets/ic_clinic.png',
      iconSize: 0.3,
      zIndex: 99,
    ));

    _directionsPolyline();
  }

  void _onMapcreated(MapboxMapController controller) {
    mapController = controller;
  }

  _checkToday() {
    String today = DateTime.now().weekday.toString();

    if (today == '1') {
      return widget.monday;
    } else if (today == '2') {
      return widget.tuesday;
    } else if (today == '3') {
      return widget.wednesday;
    } else if (today == '4') {
      return widget.thursday;
    } else if (today == '5') {
      return widget.friday;
    } else if (today == '6') {
      return widget.saturday;
    } else if (today == '7') {
      return widget.sunday;
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kWhiteColor,
        body: SafeArea(
          child: Stack(
            children: [
              _whiteBoxInformation(context),
              Container(
                height: MediaQuery.of(context).size.height * 0.5,
                width: double.infinity,
                child: MapboxMap(
                  accessToken: MAPBOX_APIKEY,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(widget.cLat!, widget.cLong!),
                    zoom: 11.0,
                  ),
                  onMapCreated: _onMapcreated,
                  onStyleLoadedCallback: _setMarker,
                  annotationOrder: const <AnnotationType>[
                    AnnotationType.symbol,
                    AnnotationType.line,
                  ],
                ),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20, left: 10),
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                  ),
                ),
              ),
              Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.only(right: 10, bottom: 20),
                    child: ElevatedButton(
                      style: ButtonStyle(
                          elevation: MaterialStateProperty.all(0),
                          backgroundColor:
                              MaterialStateProperty.all(kRedColor)),
                      onPressed: _showDialogRoute,
                      child: const Text("Show Route"),
                    ),
                  ))
            ],
          ),
        ));
  }

  Widget _whiteBoxInformation(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      controller: ScrollController(),
      child: Container(
        width: double.infinity,
        padding:
            const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 30),
        margin: const EdgeInsets.only(top: 350),
        decoration: const BoxDecoration(
          color: kWhiteColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.clinicName!,
                style: blackTextStyle.copyWith(fontSize: 18, fontWeight: bold)),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.access_alarms_rounded, color: kMainColor),
                    const SizedBox(width: 5),
                    Text(_checkToday(),
                        style: blackTextStyle.copyWith(
                            fontSize: 14, fontWeight: medium)),
                  ],
                ),
                widget.distance != null
                    ? Text('${widget.distance!.toStringAsFixed(2)} km',
                        style: redTextStyle.copyWith(
                            fontSize: 14, fontWeight: bold))
                    : const SizedBox(),
              ],
            ),
            const SizedBox(height: 14),
            Text(widget.address!, style: greyTextStyle.copyWith(fontSize: 14)),
            const SizedBox(height: 14),
            _informationWidgets(),
            const SizedBox(height: 20),
            Text("Fasilitas",
                style: blackTextStyle.copyWith(fontSize: 16, fontWeight: bold)),
            const SizedBox(height: 10),
            _facilitiesWidget(),
            Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.2,
                  margin: const EdgeInsets.only(top: 20),
                  height: 50,
                  decoration: const BoxDecoration(
                    color: kRedColor,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () async {
                      Uri phoneNumber = Uri.parse("tel:${widget.phone}");

                      // if (await launchUrl(phoneNumber)) {
                      //   print("success");
                      // } else {
                      //   // TODO :: show error with alert dialog
                      // }
                    },
                    icon: const Icon(
                      Icons.phone,
                      color: kWhiteColor,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: kMainColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TurnNavigationPage(
                                    userLat: widget.uLat,
                                    userLong: widget.uLong,
                                    clinicLat: widget.cLat,
                                    clinicLong: widget.cLong,
                                  )));
                    },
                    child: const Text('Navigasi'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _informationWidgets() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            Text("Website", style: blackTextStyle.copyWith(fontWeight: bold)),
            const SizedBox(height: 5),
            widget.website == "null"
                ? Text("null", style: redTextStyle.copyWith(fontSize: 14))
                : GestureDetector(
                    // TODO :: launch link
                    onTap: () {},
                    child: Text("Link",
                        style: redTextStyle.copyWith(
                            fontSize: 14,
                            decoration: TextDecoration.underline)),
                  )
          ],
        ),
        Column(
          children: [
            Text("Rating", style: blackTextStyle.copyWith(fontWeight: bold)),
            const SizedBox(height: 5),
            widget.rating != null
                ? Text(widget.rating!.toStringAsFixed(1),
                    style: redTextStyle.copyWith(fontSize: 14))
                : const Text("null"),
          ],
        ),
        Column(
          children: [
            Text("Reviews", style: blackTextStyle.copyWith(fontWeight: bold)),
            const SizedBox(height: 5),
            widget.reviews != null
                ? Text(widget.reviews!.toString(),
                    style: redTextStyle.copyWith(fontSize: 14))
                : const Text("null"),
          ],
        ),
      ],
    );
  }

  Widget _facilitiesWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Text("Ruang Periksa", style: blackTextStyle),
            const SizedBox(height: 5),
            const Icon(
              Icons.check_circle,
              color: kMainColor,
              size: 20,
            ),
          ],
        ),
        Column(
          children: [
            Text("Layanan Medis", style: blackTextStyle),
            const SizedBox(height: 5),
            const Icon(
              Icons.check_circle,
              color: kMainColor,
              size: 20,
            ),
          ],
        ),
        Column(
          children: [
            Text("Penginapan", style: blackTextStyle),
            const SizedBox(height: 5),
            const Icon(
              Icons.check_circle,
              color: kMainColor,
              size: 20,
            ),
          ],
        ),
        Column(
          children: [
            Text("Grooming", style: blackTextStyle),
            const SizedBox(height: 5),
            const Icon(
              Icons.check_circle,
              color: kMainColor,
              size: 20,
            ),
          ],
        ),
      ],
    );
  }

  _showDialogRoute() async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Rute Perjalanan",
            style: redTextStyle.copyWith(fontSize: 24, fontWeight: bold),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: FutureBuilder<RouteNavigationModel>(
              future: apiService.getRouteAPI(
                  widget.uLat!, widget.uLong!, widget.cLat!, widget.cLong!),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data!.routes![0].legs?[0].steps?.length,
                    itemBuilder: (context, index) {
                      return Text(
                        "${index + 1} - ${snapshot.data!.routes![0].legs![0].steps![index].manuever!.instruction}",
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                } else if (snapshot == null) {
                  return const Text("No Data");
                } else {
                  return const Center(
                      child: SpinKitFadingCircle(
                    color: kMainColor,
                  ));
                }
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }
}
