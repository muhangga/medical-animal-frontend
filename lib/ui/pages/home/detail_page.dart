import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:medical_animal/core/common/theme.dart';

class DetailPage extends StatefulWidget {
  String? clinicName;
  String? address;
  String? phone;
  String? uLat;
  String? uLong;
  double? cLat;
  double? cLong;
  double? distance;
  DetailPage(
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
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  String? _mapStyle;
  String googleAPIKey = "AIzaSyCJQyqFJ12Y8NIK-5Nud1F4on1-d34KGE8";

  GoogleMapController? mapController;

  final List<Marker> allMarkers = [];
  Map<PolylineId, Polyline> polylines = {};
  // final Set<Polyline> _polyLines = {};

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  void _setMarker() async {
    final Uint8List userIcon =
        await getBytesFromAsset('assets/ic_user.png', 220);

    final Uint8List markerIcon =
        await getBytesFromAsset('assets/ic_clinic.png', 100);
    setState(() {
      allMarkers.add(Marker(
          markerId: const MarkerId('Lokasi Pengguna'),
          draggable: false,
          icon: BitmapDescriptor.fromBytes(userIcon),
          infoWindow: const InfoWindow(title: 'Your Location'),
          position:
              LatLng(double.parse(widget.uLat!), double.parse(widget.uLong!))));

      allMarkers.add(Marker(
          markerId: const MarkerId('clinic'),
          draggable: false,
          icon: BitmapDescriptor.fromBytes(markerIcon),
          infoWindow: InfoWindow(title: widget.clinicName),
          position: LatLng(widget.cLat!, widget.cLong!)));
    });
  }

  void getDirections() async {
    List<LatLng> polylineCoordinates = [];

    PolylinePoints? polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints!.getRouteBetweenCoordinates(
        googleAPIKey,
        PointLatLng(double.parse(widget.uLat!), double.parse(widget.uLong!)),
        PointLatLng(widget.cLat!, widget.cLong!),
        travelMode: TravelMode.driving);

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });

      setState(() {
        PolylineId id = PolylineId('poly');
        Polyline polyline = Polyline(
            polylineId: id,
            color: Colors.blue,
            points: polylineCoordinates,
            width: 3);
        polylines[id] = polyline;
      });
    } else {
      print('No route found!');
    }
  }

  addPolyline(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId('poly');
    Polyline polyline = Polyline(
        polylineId: id,
        visible: true,
        color: Colors.blue,
        points: polylineCoordinates,
        width: 8);
    polylines[id] = polyline;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });

    _setMarker();
    getDirections();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 1.3,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  double.parse(widget.uLat.toString()),
                  double.parse(widget.uLong.toString()),
                ),
                zoom: 13,
              ),
              zoomControlsEnabled: true,
              myLocationButtonEnabled: false,
              tiltGesturesEnabled: false,
              mapToolbarEnabled: false,
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
                mapController!.setMapStyle(_mapStyle);
              },
              padding: const EdgeInsets.only(bottom: 50),
              minMaxZoomPreference: const MinMaxZoomPreference(10, 20),
              markers: Set.from(
                allMarkers,
              ),
              polylines: Set<Polyline>.of(polylines.values),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 40, left: 10),
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
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: 200,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}