

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
  String? konsultasi;
  String? layananMedis;
  String? penginapan;
  String? grooming;

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
    this.konsultasi,
    this.layananMedis,
    this.penginapan,
    this.grooming,
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
    konsultasi = json['konsultasi'] ?? '';
    layananMedis = json['layanan_medis'] ?? '';
    penginapan = json['penginapan'] ?? '';
    grooming = json['grooming'] ?? '';
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
    data['konsultasi'] = konsultasi;
    data['layanan_medis'] = layananMedis;
    data['penginapan'] = penginapan;
    data['grooming'] = grooming;
    return data;
  }
}
