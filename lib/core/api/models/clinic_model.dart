import 'package:medical_animal/core/api/models/working_hours_model.dart';

class ClinicModel {
  int? id;
  String? clinicName;
  String? address;
  String? phoneNumber;
  double? rating;
  int? reviews;
  String? website;
  double? latitude;
  double? longitude;
  double? distance;
  String? wednesday;
  String? thursday;
  String? friday;
  String? saturday;
  String? sunday;
  String? monday;
  String? tuesday;

  ClinicModel({
    this.id,
    this.clinicName,
    this.address,
    this.phoneNumber,
    this.rating,
    this.reviews,
    this.website,
    this.latitude,
    this.longitude,
    this.distance,
    this.wednesday,
    this.thursday,
    this.friday,
    this.saturday,
    this.sunday,
    this.monday,
    this.tuesday,
  });

  ClinicModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    clinicName = json['clinic_name'] ?? '';
    address = json['address'] ?? '';
    phoneNumber = json['phone_number'] ?? '';
    rating = json['rating'] != null ? json['rating'].toDouble() : 0.0;
    reviews = json['reviews'] ?? 0;
    website = json['website'] ?? '';
    latitude = json['latitude'] != null ? json['latitude'].toDouble() : 0.0;
    longitude = json['longitude'] != null ? json['longitude'].toDouble() : 0.0;
    distance = json['distance'] != null ? json['distance'].toDouble() : 0.0;
    wednesday = json['wednesday'] ?? '';
    thursday = json['thursday'] ?? '';
    friday = json['friday'] ?? '';
    saturday = json['saturday'] ?? '';
    sunday = json['sunday'] ?? '';
    monday = json['monday'] ?? '';
    tuesday = json['tuesday'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['clinic_name'] = clinicName;
    data['address'] = address;
    data['phone_number'] = phoneNumber;
    data['rating'] = rating;
    data['reviews'] = reviews;
    data['website'] = website;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['distance'] = distance;
    data['wednesday'] = wednesday;
    data['thursday'] = thursday;
    data['friday'] = friday;
    data['saturday'] = saturday;
    data['sunday'] = sunday;
    data['monday'] = monday;
    data['tuesday'] = tuesday;
    return data;
  }
}
