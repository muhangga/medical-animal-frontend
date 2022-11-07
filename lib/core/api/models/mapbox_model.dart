import 'dart:convert';

MapboxModel mapboxModelFromJson(String str) =>
    MapboxModel.fromJson(json.decode(str));

String mapboxModelToJson(MapboxModel data) => json.encode(data.toJson());

class MapboxModel {
  MapboxModel({
    this.routes,
  });

  List<Route>? routes;

  factory MapboxModel.fromJson(Map<String, dynamic> json) => MapboxModel(
        routes: List<Route>.from(json["routes"].map((x) => Route.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "routes": List<dynamic>.from(routes!.map((x) => x.toJson())),
      };
}

class Route {
  Route({
    required this.duration,
    required this.distance,
    required this.geometry,
  });

  final double duration;
  final double distance;
  final Map<String, dynamic> geometry;

  factory Route.fromJson(Map<String, dynamic> json) => Route(
        duration: json["duration"].toDouble(),
        distance: json["distance"].toDouble(),
        geometry: json["geometry"],
      );

  Map<String, dynamic> toJson() => {
        "duration": duration,
        "distance": distance,
        "geometry": geometry,
      };
}
