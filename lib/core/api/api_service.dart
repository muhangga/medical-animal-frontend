import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:medical_animal/core/api/models/clinic_model.dart';
import 'package:medical_animal/core/common/constant.dart';

class ApiService {
  Future<List<ClinicModel>> getClinic() async {
    try {
      var url = baseURL + 'clinics';
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var responseJson = json.decode(response.body)["data"];
        // print(responseJson);
        return (responseJson as List)
            .map((data) => ClinicModel.fromJson(data))
            .toList();
      } else {
        throw Exception('Failed to load post');
      }
    } catch (e) {
      throw Exception("Something went wrong");
    }
  }

  Future<List<ClinicModel>> nearClinic(
      double? userLat, double? userLong) async {
    var url =
        baseURL + "near-clinics?latitude=$userLat&longitude=$userLong";
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
}
