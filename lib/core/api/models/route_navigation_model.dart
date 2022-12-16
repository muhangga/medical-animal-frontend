class RouteNavigationModel {
  List<Routes>? routes;

  RouteNavigationModel({this.routes});

  RouteNavigationModel.fromJson(Map<String, dynamic> json) {
    routes = json['routes'] != null
        ? (json['routes'] as List).map((i) => Routes.fromJson(i)).toList()
        : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'routes': routes,
    };
  }
}

class Routes {
  bool? countryCrossed;
  double? duration;
  List<Legs>? legs;

  Routes({this.countryCrossed, this.duration, this.legs});

  Routes.fromJson(Map<String, dynamic> json) {
    countryCrossed = json['countryCrossed'];
    duration = json['duration'];
    legs = json['legs'] != null
        ? (json['legs'] as List).map((i) => Legs.fromJson(i)).toList()
        : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'countryCrossed': countryCrossed,
      'duration': duration,
      'legs': legs,
    };
  }
}

class Legs {
  List<Step>? steps;

  Legs({required this.steps});

  Legs.fromJson(Map<String, dynamic> json) {
    steps = json['steps'] != null
        ? (json['steps'] as List).map((i) => Step.fromJson(i)).toList()
        : [];
  }

  Map<String, dynamic> toJson() {
    return {
      'steps': steps,
    };
  }
}

class Step {
  Manuever? manuever;

  Step({required this.manuever});

  Step.fromJson(Map<String, dynamic> json) {
    manuever = Manuever.fromJson(json['maneuver']);
  }
}

class Manuever {
  String? type;
  String? instruction;

  Manuever({this.type, this.instruction});

  Manuever.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    instruction = json['instruction'];
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'instruction': instruction,
    };
  }
}
