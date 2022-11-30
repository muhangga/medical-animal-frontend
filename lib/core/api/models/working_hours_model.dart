class WorkingHoursModel {
  String? wednesday;
  String? thursday;
  String? friday;
  String? saturday;
  String? sunday;
  String? monday;
  String? tuesday;


  WorkingHoursModel({
    this.wednesday,
    this.thursday,
    this.friday,
    this.saturday,
    this.sunday,
    this.monday,
    this.tuesday,
  });

  WorkingHoursModel.fromJson(Map<String, dynamic> json) {
    wednesday = json['wednesday'] ?? '';
    thursday = json['thursday'] ?? '';
    friday = json['friday'] ?? '';
    saturday = json['saturday'] ?? '';
    sunday = json['sunday'] ?? '';
    monday = json['monday'] ?? '';
    tuesday = json['tuesday'] ?? '';
  }
}