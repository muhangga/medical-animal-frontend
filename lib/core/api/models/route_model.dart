// To parse this JSON data, do
//
//     final routeModel = routeModelFromJson(jsonString);

import 'dart:convert';

RouteModel routeModelFromJson(String str) =>
    RouteModel.fromJson(json.decode(str));

String routeModelToJson(RouteModel data) => json.encode(data.toJson());

class RouteModel {
  RouteModel({
    this.routes,
  });

  final List<Route>? routes;

  factory RouteModel.fromJson(Map<String, dynamic> json) => RouteModel(
        routes: json["routes"] == null
            ? null
            : List<Route>.from(json["routes"].map((x) => Route.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "routes": routes == null
            ? null
            : List<dynamic>.from(routes!.map((x) => x.toJson())),
      };
}

class Route {
  Route({
    this.countryCrossed,
    this.weightName,
    this.weight,
    this.duration,
    this.distance,
    this.legs,
    this.geometry,
  });

  final bool? countryCrossed;
  final String? weightName;
  final double? weight;
  final double? duration;
  final double? distance;
  final List<Leg>? legs;
  final Geometry? geometry;

  factory Route.fromJson(Map<String, dynamic> json) => Route(
        countryCrossed:
            json["country_crossed"] == null ? null : json["country_crossed"],
        weightName: json["weight_name"] == null ? null : json["weight_name"],
        weight: json["weight"] == null ? null : json["weight"].toDouble(),
        duration: json["duration"] == null ? null : json["duration"].toDouble(),
        distance: json["distance"] == null ? null : json["distance"].toDouble(),
        legs: json["legs"] == null
            ? null
            : List<Leg>.from(json["legs"].map((x) => Leg.fromJson(x))).toList(),
        geometry: json["geometry"] == null
            ? null
            : Geometry.fromJson(json["geometry"]),
      );

  Map<String, dynamic> toJson() => {
        "country_crossed": countryCrossed == null ? null : countryCrossed,
        "weight_name": weightName == null ? null : weightName,
        "weight": weight == null ? null : weight,
        "duration": duration == null ? null : duration,
        "distance": distance == null ? null : distance,
        "legs": legs == null
            ? null
            : List<dynamic>.from(legs!.map((x) => x.toJson())),
        "geometry": geometry == null ? null : geometry!.toJson(),
      };
}

class Geometry {
  Geometry({
    this.coordinates,
    this.type,
  });

  final List<List<double>>? coordinates;
  final Type? type;

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
        coordinates: json["coordinates"] == null
            ? null
            : List<List<double>>.from(json["coordinates"]
                .map((x) => List<double>.from(x.map((x) => x.toDouble())))),
      );

  Map<String, dynamic> toJson() => {
        "coordinates": coordinates == null
            ? null
            : List<dynamic>.from(
                coordinates!.map((x) => List<dynamic>.from(x.map((x) => x)))),
      };
}

class Leg {
  Leg({
    this.duration,
    this.steps,
    this.distance,
  });

  final double? duration;
  final List<Step>? steps;
  final double? distance;

  factory Leg.fromJson(Map<String, dynamic> json) => Leg(
        steps: json["steps"] == null
            ? null
            : List<Step>.from(
                json["steps"].map((x) => Step.fromJson(x)).toList()),
        distance: json["distance"] == null ? null : json["distance"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "duration": duration == null ? null : duration,
        "steps": steps == null
            ? null
            : List<dynamic>.from(steps!.map((x) => x.toJson())),
        "distance": distance == null ? null : distance,
      };
}

class Step {
  Step({
    this.maneuver,
    this.name,
    this.duration,
    this.distance,
    this.drivingSide,
    this.weight,
    this.mode,
    this.geometry,
    this.ref,
  });

  final Maneuver? maneuver;
  final String? name;
  final double? duration;
  final double? distance;
  final String? drivingSide;
  final double? weight;
  final String? mode;
  final Geometry? geometry;
  final String? ref;

  factory Step.fromJson(Map<String, dynamic> json) => Step(
        maneuver: json["maneuver"] == null
            ? null
            : Maneuver.fromJson(json["maneuver"]),
        name: json["name"] == null ? null : json["name"],
        duration: json["duration"] == null ? null : json["duration"].toDouble(),
        distance: json["distance"] == null ? null : json["distance"].toDouble(),
        drivingSide: json["driving_side"] == null ? null : json["driving_side"],
        weight: json["weight"] == null ? null : json["weight"].toDouble(),
        mode: json["mode"] == null ? null : json["mode"],
        geometry: json["geometry"] == null
            ? null
            : Geometry.fromJson(json["geometry"]),
        ref: json["ref"] == null ? null : json["ref"],
      );

  Map<String, dynamic> toJson() => {
        "maneuver": maneuver == null ? null : maneuver!.toJson(),
        "name": name == null ? null : name,
        "duration": duration == null ? null : duration,
        "distance": distance == null ? null : distance,
        "driving_side": drivingSide == null ? null : drivingSide,
        "weight": weight == null ? null : weight,
        "mode": mode == null ? null : mode,
        "geometry": geometry == null ? null : geometry!.toJson(),
        "ref": ref == null ? null : ref,
      };
}

class Intersection {
  Intersection({
    this.entry,
    this.bearings,
    this.duration,
    this.isUrban,
    this.adminIndex,
    this.out,
    this.weight,
    this.geometryIndex,
    this.location,
    this.intersectionIn,
    this.turnWeight,
    this.turnDuration,
    this.trafficSignal,
  });

  final List<bool>? entry;
  final List<int>? bearings;
  final double? duration;
  final bool? isUrban;
  final int? adminIndex;
  final int? out;
  final double? weight;
  final int? geometryIndex;
  final List<double>? location;
  final int? intersectionIn;
  final double? turnWeight;
  final double? turnDuration;
  final bool? trafficSignal;

  factory Intersection.fromJson(Map<String, dynamic> json) => Intersection(
        entry: json["entry"] == null
            ? null
            : List<bool>.from(json["entry"].map((x) => x)),
        bearings: json["bearings"] == null
            ? null
            : List<int>.from(json["bearings"].map((x) => x)),
        duration: json["duration"] == null ? null : json["duration"].toDouble(),
        isUrban: json["is_urban"] == null ? null : json["is_urban"],
        adminIndex: json["admin_index"] == null ? null : json["admin_index"],
        out: json["out"] == null ? null : json["out"],
        weight: json["weight"] == null ? null : json["weight"].toDouble(),
        geometryIndex:
            json["geometry_index"] == null ? null : json["geometry_index"],
        location: json["location"] == null
            ? null
            : List<double>.from(json["location"].map((x) => x.toDouble())),
        intersectionIn: json["in"] == null ? null : json["in"],
        turnWeight:
            json["turn_weight"] == null ? null : json["turn_weight"].toDouble(),
        turnDuration: json["turn_duration"] == null
            ? null
            : json["turn_duration"].toDouble(),
        trafficSignal:
            json["traffic_signal"] == null ? null : json["traffic_signal"],
      );

  Map<String, dynamic> toJson() => {
        "entry":
            entry == null ? null : List<dynamic>.from(entry!.map((x) => x)),
        "bearings": bearings == null
            ? null
            : List<dynamic>.from(bearings!.map((x) => x)),
        "duration": duration == null ? null : duration,
        "is_urban": isUrban == null ? null : isUrban,
        "admin_index": adminIndex == null ? null : adminIndex,
        "out": out == null ? null : out,
        "weight": weight == null ? null : weight,
        "geometry_index": geometryIndex == null ? null : geometryIndex,
        "location": location == null
            ? null
            : List<dynamic>.from(location!.map((x) => x)),
        "in": intersectionIn == null ? null : intersectionIn,
        "turn_weight": turnWeight == null ? null : turnWeight,
        "turn_duration": turnDuration == null ? null : turnDuration,
        "traffic_signal": trafficSignal == null ? null : trafficSignal,
      };
}

class Maneuver {
  Maneuver({
    this.type,
    this.instruction,
    this.bearingAfter,
    this.bearingBefore,
    this.location,
    this.modifier,
  });

  final String? type;
  final String? instruction;
  final int? bearingAfter;
  final int? bearingBefore;
  final List<double>? location;
  final String? modifier;

  factory Maneuver.fromJson(Map<String, dynamic> json) => Maneuver(
        type: json["type"] == null ? null : json["type"],
        instruction: json["instruction"] == null ? null : json["instruction"],
        bearingAfter:
            json["bearing_after"] == null ? null : json["bearing_after"],
        bearingBefore:
            json["bearing_before"] == null ? null : json["bearing_before"],
        location: json["location"] == null
            ? null
            : List<double>.from(json["location"].map((x) => x.toDouble())),
        modifier: json["modifier"] == null ? null : json["modifier"],
      );

  Map<String, dynamic> toJson() => {
        "type": type == null ? null : type,
        "instruction": instruction == null ? null : instruction,
        "bearing_after": bearingAfter == null ? null : bearingAfter,
        "bearing_before": bearingBefore == null ? null : bearingBefore,
        "location": location == null
            ? null
            : List<dynamic>.from(location!.map((x) => x)),
        "modifier": modifier == null ? null : modifier,
      };
}

class Waypoint {
  Waypoint({
    this.distance,
    this.name,
    this.location,
  });

  final double? distance;
  final String? name;
  final List<double>? location;

  factory Waypoint.fromJson(Map<String, dynamic> json) => Waypoint(
        distance: json["distance"] == null ? null : json["distance"].toDouble(),
        name: json["name"] == null ? null : json["name"],
        location: json["location"] == null
            ? null
            : List<double>.from(json["location"].map((x) => x.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "distance": distance == null ? null : distance,
        "name": name == null ? null : name,
        "location": location == null
            ? null
            : List<dynamic>.from(location!.map((x) => x)),
      };
}
