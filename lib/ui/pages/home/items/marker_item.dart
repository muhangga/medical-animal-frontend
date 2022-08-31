import 'package:flutter/material.dart';
import 'package:medical_animal/core/provider/map_provider.dart';
import 'package:medical_animal/ui/widgets/clip_triangle.dart';
import 'package:provider/provider.dart';

class MarkerItem {

  /// Initialize instance
  static MarkerItem instance = MarkerItem();

  Widget clinicMarker() {
    return Consumer<MapProvider>(
      builder: (context, mapProv, _) {
        return RepaintBoundary(
          key: mapProv.markerKey,
          child: Container(
            width: 200,
            height: 120,
            child: Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 10),
                        blurRadius: 10,
                        spreadRadius: 1,
                        color: Colors.grey.withOpacity(0.3)
                      )
                    ]
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Klinik',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
                RotatedBox(
                  quarterTurns: 2,
                  child: CustomPaint(
                    painter: TrianglePainter(
                      strokeColor: Colors.white,
                      strokeWidth: 10,
                      paintingStyle: PaintingStyle.fill,
                    ),
                    child: Container(
                      width: 16,
                      height: 13,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 10),
                        blurRadius: 10,
                        spreadRadius: 1,
                        color: Colors.grey.withOpacity(0.5)
                      )
                    ]
                  ),
                  child: Center(
                    child: Image.asset("assets/ic_war.png", width: 24, height: 24, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  Widget myLocationMarker() {
    return Consumer<MapProvider>(
      builder: (context, mapProv, _) {
        return RepaintBoundary(
          key: mapProv.myLocationKey,
          child: Container(
            width: 200,
            height: 120,
            child: Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 10),
                        blurRadius: 10,
                        spreadRadius: 1,
                        color: Colors.grey.withOpacity(0.3)
                      )
                    ]
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "You",
                      style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                RotatedBox(
                  quarterTurns: 2,
                  child: CustomPaint(
                    painter: TrianglePainter(
                      strokeColor: Colors.white,
                      strokeWidth: 10,
                      paintingStyle: PaintingStyle.fill,
                    ),
                    child: Container(
                      width: 16,
                      height: 13,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.orange,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 10),
                        blurRadius: 10,
                        spreadRadius: 1,
                        color: Colors.grey.withOpacity(0.5)
                      )
                    ]
                  ),
                  child: Icon(Icons.location_on, color: Colors.white, size: 25)
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}