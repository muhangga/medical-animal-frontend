import 'package:flutter/material.dart';
import 'package:flutter_mapbox_navigation/library.dart';
import 'package:medical_animal/ui/pages/home/main_page.dart';

class TurnNavigationPage extends StatefulWidget {
  double? userLat;
  double? userLong;
  double? clinicLat;
  double? clinicLong;

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
  late MapBoxNavigation directions;
  late double distanceRemaining;
  late double durationRemaining;
  late WayPoint sourceWaypoint, destinationWaypoint;
  late MapBoxNavigationViewController controller;
  late MapBoxOptions _options;

  final bool isMultipleStop = false;

  String instruction = "";
  bool isArrived = false;
  bool isNavigationRunning = false;
  bool routeBuilt = false;

  var wayPoints = <WayPoint>[];

  Future<void> initialize() async {
    if (!mounted) return;

    directions = MapBoxNavigation(onRouteEvent: _onRouteEvent);
    _options = MapBoxOptions(
      zoom: 16,
      voiceInstructionsEnabled: true,
      bannerInstructionsEnabled: true,
      mode: MapBoxNavigationMode.drivingWithTraffic,
      isOptimized: true,
      units: VoiceUnits.metric,
      language: "id",
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

    await directions.startNavigation(wayPoints: wayPoints, options: _options);
  }

  Future<void> _onRouteEvent(e) async {
    distanceRemaining = await directions.distanceRemaining;
    durationRemaining = await directions.durationRemaining;

    //   if (!mounted) return;

    //   if (e.eventType == MapBoxEvent.progress_change) {
    //     distanceRemaining = e.data["distanceRemaining"];
    //     durationRemaining = e.data["durationRemaining"];
    //     instruction = e.data["currentLegProgress"]["currentStep"]["instructions"];
    //     isArrived = e.data["arrived"];
    //     isNavigationRunning = e.data["navigationRunning"];
    //     routeBuilt = e.data["routeBuilt"];
    //   }

    //   if (isArrived) {
    //     await controller.finishNavigation();
    //     Navigator.pushReplacement(
    //         context, MaterialPageRoute(builder: (context) => MainPage()));
    //   }

    //   setState(() {});
    //   print("Event: $e");
    // }

    switch (e.eventType) {
      case MapBoxEvent.progress_change:
        var progressEvent = e.data as RouteProgressEvent;
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
        isNavigationRunning = false;
        break;
      case MapBoxEvent.navigation_cancelled:
        routeBuilt = false;
        isNavigationRunning = false;
        break;
      case MapBoxEvent.on_arrival:
        isArrived = true;

        if (!isMultipleStop) {
          await Future.delayed(const Duration(seconds: 3));
          await controller.finishNavigation();
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
    return WillPopScope(
      onWillPop: () async {
        if (isNavigationRunning && !isArrived) {
          await controller.finishNavigation();
        }

        return true;
      },
      child: MainPage(),
    );
  }
}
