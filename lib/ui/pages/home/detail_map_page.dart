import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:medical_animal/core/common/constant.dart';

class DetailMapPage extends StatefulWidget {
  String? clinicName;
  String? address;
  String? phone;
  String? uLat;
  String? uLong;
  double? cLat;
  double? cLong;
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
      this.distance})
      : super(key: key);

  @override
  State<DetailMapPage> createState() => _DetailMapPageState();
}

class _DetailMapPageState extends State<DetailMapPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MapboxMapController? mapController;

    void _setMarker() async {
      mapController!.addSymbol(SymbolOptions(
          geometry:
              LatLng(double.parse(widget.uLat!), double.parse(widget.uLong!)),
          iconImage: 'assets/ic_user2.png',
          iconSize: 0.2));

      mapController!.addSymbol(SymbolOptions(
          geometry: LatLng(widget.cLat!, widget.cLong!),
          iconImage: 'assets/ic_clinic.png',
          iconSize: 0.2));
    }

    void _addPolyline(int index, List<LatLng> points) {
      mapController!.addLine(LineOptions(
          geometry: points,
          lineColor: "#3bb2d0",
          lineWidth: 4.0,
          lineOpacity: 0.9));
    }

    void _onMapcreated(MapboxMapController controller) {
      mapController = controller;
    }

    @override
    void initState() {
      super.initState();
    }

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
                zoom: 11.6,
              ),
              onMapCreated: _onMapcreated,
              onStyleLoadedCallback: _setMarker,
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
        ],
      ),
    ));
  }
}
