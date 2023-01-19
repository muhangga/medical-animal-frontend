import 'package:flutter/material.dart';
import 'package:flutter_mapbox_navigation/library.dart';
import 'package:medical_animal/core/common/theme.dart';
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
  MapBoxNavigation? directions;
  MapBoxOptions? _options;
  MapBoxNavigationViewController? _controller;

  late WayPoint sourceWaypoint, destinationWaypoint;

  String instruction = "";
  bool isMultipleStop = false;
  bool arrived = false;
  bool isNavigating = false;
  bool routeBuilt = false;
  late double distanceRemaining;
  late double durationRemaining;

  var wayPoints = <WayPoint>[];

  @override
  void initState() {
    super.initState();
    initialize();
  }

  // create function when mapbox on destroy
  @override
  void dispose() {
    directions?.distanceRemaining
        .then((value) => distanceRemaining = value)
        .whenComplete(() => print(distanceRemaining))
        .onError((error, stackTrace) {
      print(error);
      return 0.0;
    }).asStream();
    super.dispose();
  }

  Future<void> initialize() async {
    if (!mounted) return;

    directions = MapBoxNavigation(onRouteEvent: _onEmbeddedRouteEvent);

    _options = MapBoxOptions(
        zoom: 18,
        tilt: 0,
        bearing: 0,
        enableRefresh: false,
        alternatives: true,
        voiceInstructionsEnabled: true,
        bannerInstructionsEnabled: true,
        allowsUTurnAtWayPoints: true,
        mode: MapBoxNavigationMode.drivingWithTraffic,
        units: VoiceUnits.metric,
        simulateRoute: true,
        animateBuildRoute: true,
        longPressDestinationEnabled: true,
        language: "id");

    destinationWaypoint = WayPoint(
        name: "Lokasi Anda",
        latitude: widget.userLat!,
        longitude: widget.userLong!);

    sourceWaypoint = WayPoint(
        name: "Klinik Hewan",
        latitude: widget.clinicLat!,
        longitude: widget.clinicLong!);

    wayPoints.add(destinationWaypoint);
    wayPoints.add(sourceWaypoint);

    await directions?.startNavigation(
      wayPoints: wayPoints,
      options: _options!,
    );
  }

  Future<void> _onEmbeddedRouteEvent(e) async {
    if (!mounted) return;

    if (e.eventType == MapBoxEvent.navigation_finished) {
      _pushReplacament();
    } else if (e.eventType == MapBoxEvent.navigation_running) {
      setState(() {
        isNavigating = true;
      });
    } else if (e.eventType == MapBoxEvent.navigation_cancelled) {
      setState(() {
        isNavigating = false;
      });
    } else if (e.eventType == MapBoxEvent.on_arrival) {
      setState(() {
        arrived = true;
      });
    } else if (e.eventType == MapBoxEvent.route_building) {
      setState(() {
        routeBuilt = true;
      });
    } else if (e.eventType == MapBoxEvent.route_built) {
      setState(() {
        routeBuilt = true;
      });
    } else if (e.eventType == MapBoxEvent.route_build_failed) {
      setState(() {
        routeBuilt = false;
      });
    } else if (e.eventType == MapBoxEvent.progress_change) {
      var progressEvent = e.data as RouteProgressEvent;

      if (progressEvent.currentStepInstruction != null) {
        instruction = progressEvent.currentStepInstruction!;
      } else {
        instruction = "";
      }

      // distanceRemaining = await directions!.distanceRemaining;
      // durationRemaining = await directions!.durationRemaining;

      print("distanceRemaining: $distanceRemaining");
    } else {
      print("Unhandled event: ${e.eventType}");
    }
  }

  _pushReplacament() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MainPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: MainPage(),
      ),
    );
  }
}
