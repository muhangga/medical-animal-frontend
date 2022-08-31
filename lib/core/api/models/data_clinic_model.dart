class DataClinicModel {
  int? id;
  String? clinicName;
  String? address;
  String? phoneNumber;
  String? pathImage;
  String? latitude;
  String? longitude;

  DataClinicModel({
    this.id,
    this.clinicName,
    this.address,
    this.phoneNumber,
    this.pathImage,
    this.latitude,
    this.longitude,
  });

  DataClinicModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    clinicName = json['clinic_name'];
    address = json['address'];
    phoneNumber = json['phone_number'];
    pathImage = json['path_image'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['clinic_name'] = clinicName;
    data['address'] = address;
    data['phone_number'] = phoneNumber;
    data['path_image'] = pathImage;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }
}
