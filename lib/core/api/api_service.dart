import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:medical_animal/core/api/models/clinic_model.dart';
import 'package:medical_animal/core/api/models/route_navigation_model.dart';
import 'package:medical_animal/core/common/constant.dart';

class ApiService {
  Future<List<ClinicModel>> getClinic(double? userLat, double? userLong) async {
    try {
      var url = baseURL + 'clinics?latitude=$userLat&longitude=$userLong';
      var response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json;charset=UTF-8',
        'Charset': 'utf-8'
      });

      if (response.statusCode == 200) {
        var responseJson = json.decode(response.body)["data"];
        print(responseJson);
        if (responseJson != null) {
          return (responseJson as List)
              .map((p) => ClinicModel.fromJson(p))
              .toList();
        } else {
          return [];
        }
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<ClinicModel>> nearClinic(
      double? userLat, double? userLong) async {
    var url = baseURL + "near-clinics?latitude=$userLat&longitude=$userLong";
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var responseJson = json.decode(response.body)["data"];

        print(responseJson);
        return (responseJson as List)
            .map((data) => ClinicModel.fromJson(data))
            .toList();
      } else {
        throw Exception('Failed to load post');
      }
    } catch (e) {
      print(e.toString());
      throw Exception(e.toString());
    }
  }

  Future<List<ClinicModel>> nearClinicById(
      double? userLat, double? userLong, int? clinicId) async {
    var url =
        baseURL + "near-clinic/$clinicId?latitude=$userLat&longitude=$userLong";
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var responseJson = json.decode(response.body)["data"];

        print(responseJson);
        return (responseJson as List)
            .map((data) => ClinicModel.fromJson(data))
            .toList();
      } else {
        throw Exception('Failed to load post');
      }
    } catch (e) {
      throw Exception('Something went wrong!');
    }
  }

  Future<RouteNavigationModel> getRouteAPI(double? userLat, double? userLong,
      double? clinicLat, double? clinicLong) async {
    var url =
        "https://api.mapbox.com/directions/v5/mapbox/driving/$userLong,$userLat;$clinicLong,$clinicLat?alternatives=true&exclude=motorway&geometries=geojson&language=id&overview=full&steps=true&access_token=$MAPBOX_APIKEY";

    try {
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var responseJson = json.decode(response.body.toString());

        print(responseJson);
        return RouteNavigationModel.fromJson(responseJson);
      } else {
        throw Exception('Failed to load post');
      }
    } catch (e) {
      log(e.toString());
      throw Exception('Something went wrong!');
    }
  }

  Future insertUser(double? userLat, double? userLong, String? device,
      String? address) async {
    var url = baseURL + "user-request";
    var response = await http.post(Uri.parse(url), body: {
      "latitude": userLat.toString(),
      "longitude": userLong.toString(),
      "address": address.toString(),
      "device": device,
    });

    if (response.statusCode != 200) {
      print(response.body);
      throw Exception('Failed to load post');
    } else {
      return response.body;
    }
  }
}
