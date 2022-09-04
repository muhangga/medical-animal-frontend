import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:medical_animal/core/common/theme.dart';
import 'package:medical_animal/core/provider/map_provider.dart';
import 'package:medical_animal/ui/pages/home/items/marker_item.dart';
import 'package:provider/provider.dart';

class MapPage extends StatelessWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mapProv = Provider.of<MapProvider>(context);
    if (mapProv.mapController == null) {
      mapProv.initCamera(context);
    }

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark));

    return Scaffold(
        body: SafeArea(
      child: mapProv.cameraPosition != null
          ? GoogleMap(
              myLocationButtonEnabled: false,
              myLocationEnabled: false,
              compassEnabled: false,
              zoomControlsEnabled: false,
              tiltGesturesEnabled: false,
              markers: mapProv.markers,
              mapType: MapType.normal,
              initialCameraPosition: mapProv.cameraPosition!,
              onMapCreated: mapProv.onMapCreated,
              mapToolbarEnabled: false,
            )
          : const Center(
              child: SpinKitFadingCircle(
                color: kSecondaryColor,
              ),
            ),
    ));
  }

  Widget _myLocationWidget() {
    return Builder(builder: (context) {
      return Consumer<MapProvider>(
        builder: (context, mapProv, _) {
          return Padding(
              padding: const EdgeInsets.only(top: 30, right: 20),
              child: InkWell(
                onTap: () =>
                    mapProv.changeCameraPosition(mapProv.sourceLocation!),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50)),
                  child: const Icon(
                    Icons.location_on,
                    color: Colors.orange,
                  ),
                ),
              ));
        },
      );
    });
  }
}
