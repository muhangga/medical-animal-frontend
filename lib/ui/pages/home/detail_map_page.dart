import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:medical_animal/core/common/constant.dart';
import 'package:medical_animal/core/common/theme.dart';

import 'package:medical_animal/core/services/mapbox_directions.dart';
import 'package:medical_animal/ui/pages/home/turn_navigation.dart';

class DetailMapPage extends StatefulWidget {
  String? clinicName;
  String? address;
  String? phone;
  double? uLat;
  double? uLong;
  double? cLat;
  double? cLong;
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.7,
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
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 20, left: 10, right: 10),
            margin: const EdgeInsets.only(top: 400),
            color: kWhiteColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.clinicName!,
                    style: blackTextStyle.copyWith(
                        fontSize: 18, fontWeight: bold)),
                SizedBox(height: 5),
                Text(widget.address!,
                    style: greyTextStyle.copyWith(fontSize: 14)),
              ],
            ),
          )
        ],
      ),
    ));
  }
}
