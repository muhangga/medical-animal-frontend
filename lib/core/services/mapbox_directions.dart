import 'dart:convert';

import 'package:medical_animal/core/api/models/mapbox_model.dart';
import 'package:http/http.dart' as http;
import 'package:medical_animal/core/common/constant.dart';

class MapboxService {
  String baseURL = "https://api.mapbox.com/directions/v5/mapbox";
  String accessToken = MAPBOX_APIKEY;
  String navType = "driving";

  Future getDrivingRouteUsingMapbox(
      double uLong, double uLat, double cLong, double cLat) async {
    String url =
        "$baseURL/$navType/$uLong,$uLat; $cLong,$cLat?alternatives=true&geometries=geojson&language=en&overview=full&steps=true&access_token=$accessToken";
    print(url);

    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        // print(data);
        return MapboxModel.fromJson(data);
      } else {
        print("Error: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<Map> getDirectionAPIResponse(
      double uLong, double uLat, double cLong, double cLat) async {
    final response = await getDrivingRouteUsingMapbox(uLong, uLat, cLong, cLat);

    Map geometry = response.routes[0].geometry;
    num duration = response.routes[0].duration;
    num distance = response.routes[0].distance;
    // print(geometry);
    // print(duration);
    // print(distance);

    return {
      "geometry": geometry,
      "duration": duration,
      "distance": distance,
    };
  }
}
