import 'package:flutter/material.dart';
import 'package:flutter_mapbox_navigation/library.dart';

class TurnNavigationPage extends StatefulWidget {
  late double userLat;
  late double userLong;
  late double clinicLat;
  late double clinicLong;

  TurnNavigationPage({
    Key? key,
    required this.userLat,
    required this.userLong,
    required this.clinicLat,
    required this.clinicLong,
  }) : super(key: key);

  @override
  State<TurnNavigationPage> createState() => _TurnNavigationPageState();
}

class _TurnNavigationPageState extends State<TurnNavigationPage> {
  MapBoxNavigation? _directions;
  MapBoxOptions? _options;

  late WayPoint sourceWaypoint, destinationWaypoint;
  late double distanceRemaining, durationRemaining;

  final bool isMultipleStop = false;

  String instruction = "";
  bool isArrived = false;
  bool isNavigationRunning = false;
  bool routeBuilt = false;

  var wayPoints = <WayPoint>[];

  Future<void> initialize() async {
    if (!mounted) return;

    _directions = MapBoxNavigation(onRouteEvent: _onRouteEvent);
    _options = MapBoxOptions(
      zoom: 18,
      voiceInstructionsEnabled: true,
      bannerInstructionsEnabled: true,
      mode: MapBoxNavigationMode.drivingWithTraffic,
      isOptimized: true,
      units: VoiceUnits.metric,
      language: "en",
      simulateRoute: true,
    );

    sourceWaypoint = WayPoint(
        name: "Source", latitude: widget.userLat, longitude: widget.userLong);

    destinationWaypoint = WayPoint(
        name: "Destination",
        latitude: widget.clinicLat,
        longitude: widget.clinicLong);

    wayPoints.add(sourceWaypoint);
    wayPoints.add(destinationWaypoint);

    await _directions!
        .startNavigation(wayPoints: wayPoints, options: _options!);
  }

  Future<void> _onRouteEvent(event) async {
    distanceRemaining = await _directions!.distanceRemaining;
    durationRemaining = await _directions!.durationRemaining;

    switch (event.eventType) {
      case MapBoxEvent.progress_change:
        var progressEvent = event.data as RouteProgressEvent;
        isArrived = progressEvent.arrived!;

        if (progressEvent.currentStepInstruction != null) {
          instruction = progressEvent.currentStepInstruction!;
        }
        break;
      case MapBoxEvent.route_building:
      case MapBoxEvent.route_built:
        routeBuilt = true;
        break;
      case MapBoxEvent.route_build_failed:
        routeBuilt = false;
        break;
      case MapBoxEvent.navigation_running:
        isNavigationRunning = true;
        break;
      case MapBoxEvent.navigation_finished:
      case MapBoxEvent.navigation_cancelled:
        isNavigationRunning = false;
        routeBuilt = false;
        break;
      case MapBoxEvent.on_arrival:
        isArrived = true;

        if (!isMultipleStop) {
          await Future.delayed(const Duration(seconds: 3));
          await _directions!.finishNavigation();
        } else {}
        break;
      default:
        break;
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
