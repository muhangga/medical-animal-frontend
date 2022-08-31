class ClinicModel {
  int? id;
  String? clinicName;
  String? address;
  String? phoneNumber;
  String? pathImage;
  double? latitude;
  double? longitude;
  double? distance;

  ClinicModel({
    this.id,
    this.clinicName,
    this.address,
    this.phoneNumber,
    this.pathImage,
    this.latitude,
    this.longitude,
    this.distance,
  });

  ClinicModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    clinicName = json['clinic_name'];
    address = json['address'];
    phoneNumber = json['phone_number'];
    pathImage = json['path_image'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    distance = json['distance'];
  }
}
