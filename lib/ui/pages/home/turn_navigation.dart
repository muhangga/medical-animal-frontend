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

    sourceWaypoint = WayPoint(
        name: "Lokasi Anda",
        latitude: widget.userLat!,
        longitude: widget.userLong!);

    destinationWaypoint = WayPoint(
        name: "Klinik Hewan",
        latitude: widget.clinicLat!,
        longitude: widget.clinicLong!);

    wayPoints.add(sourceWaypoint);

    wayPoints.add(destinationWaypoint);

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

    // distanceRemaining = await directions!.distanceRemaining;
    // durationRemaining = await directions!.durationRemaining;

    // switch (e.eventType) {
    //   case MapBoxEvent.progress_change:
    //     var progressEvent = e.data as RouteProgressEvent;
    //     if (progressEvent.currentStepInstruction != null) {
    //       instruction = progressEvent.currentStepInstruction!;
    //     }
    //     break;
    //   case MapBoxEvent.route_building:
    //   case MapBoxEvent.route_built:
    //     setState(() {
    //       routeBuilt = true;
    //     });
    //     break;
    //   case MapBoxEvent.route_build_failed:
    //     setState(() {
    //       routeBuilt = false;
    //     });
    //     break;
    //   case MapBoxEvent.navigation_running:
    //     setState(() {
    //       isNavigating = true;
    //     });

    //     break;
    //   case MapBoxEvent.on_arrival:
    //     if (!isMultipleStop) {
    //       await Future.delayed(const Duration(seconds: 3));
    //       await _controller?.finishNavigation();
    //     } else {}

    //     break;
    //   case MapBoxEvent.navigation_finished:
    //     setState(() {
    //       isNavigating = false;
    //     });
    //     break;
    //   case MapBoxEvent.navigation_cancelled:
    //     setState(() {
    //       routeBuilt = false;
    //       isNavigating = false;
    //     });
    //     break;
    //   default:
    //     break;
    // }
    // setState(() {});
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
        // body: Center(
        //   child: Column(children: <Widget>[
        //     Expanded(
        //       child: SingleChildScrollView(
        //         child: Column(
        //           children: [
        //             SizedBox(
        //               height: 10,
        //             ),
        //             Container(
        //               color: Colors.grey,
        //               width: double.infinity,
        //               child: Padding(
        //                 padding: EdgeInsets.all(10),
        //                 child: (Text(
        //                   "Full Screen Navigation",
        //                   style: TextStyle(color: Colors.white),
        //                   textAlign: TextAlign.center,
        //                 )),
        //               ),
        //             ),
        //             Row(
        //               mainAxisAlignment: MainAxisAlignment.center,
        //               children: [
        //                 ElevatedButton(
        //                   child: Text("Start A to B"),
        //                   onPressed: () async {
        //                     // var wayPoints = <WayPoint>[];
        //                     // wayPoints.add(home);
        //                     // wayPoints.add(_store);

        //                     // await _directions.startNavigation(
        //                     //   wayPoints: wayPoints,
        //                     //   options: MapBoxOptions(
        //                     //       mode: MapBoxNavigationMode.drivingWithTraffic,
        //                     //       simulateRoute: false,
        //                     //       language: "en",
        //                     //       units: VoiceUnits.metric),
        //                     // );
        //                   },
        //                 ),
        //                 SizedBox(
        //                   width: 10,
        //                 ),
        //                 ElevatedButton(
        //                   child: Text("Start Multi Stop"),
        //                   onPressed: () async {
        //                     // isMultipleStop = true;
        //                     // var wayPoints = <WayPoint>[];
        //                     // wayPoints.add(_origin);
        //                     // wayPoints.add(_stop1);
        //                     // wayPoints.add(_stop2);
        //                     // wayPoints.add(_stop3);
        //                     // wayPoints.add(_destination);
        //                     // wayPoints.add(_origin);

        //                     // await directions.startNavigation(
        //                     //     wayPoints: wayPoints,
        //                     //     options: MapBoxOptions(
        //                     //         mode: MapBoxNavigationMode.driving,
        //                     //         simulateRoute: true,
        //                     //         language: "en",
        //                     //         allowsUTurnAtWayPoints: true,
        //                     //         units: VoiceUnits.metric));
        //                   },
        //                 )
        //               ],
        //             ),
        //             Container(
        //               color: Colors.grey,
        //               width: double.infinity,
        //               child: Padding(
        //                 padding: EdgeInsets.all(10),
        //                 child: (Text(
        //                   "Embedded Navigation",
        //                   style: TextStyle(color: Colors.white),
        //                   textAlign: TextAlign.center,
        //                 )),
        //               ),
        //             ),
        //             Row(
        //               mainAxisAlignment: MainAxisAlignment.center,
        //               children: [
        //                 ElevatedButton(
        //                   child: Text(routeBuilt && !isNavigating
        //                       ? "Clear Route"
        //                       : "Build Route"),
        //                   onPressed: isNavigating
        //                       ? null
        //                       : () {
        //                           if (routeBuilt) {
        //                             _controller?.clearRoute();
        //                           } else {
        //                             var wayPoints = <WayPoint>[];
        //                             // wayPoints.add();
        //                             // wayPoints.add(_store);
        //                             isMultipleStop = wayPoints.length > 2;
        //                             _controller?.buildRoute(
        //                                 wayPoints: wayPoints,
        //                                 options: _options);
        //                           }
        //                         },
        //                 ),
        //                 SizedBox(
        //                   width: 10,
        //                 ),
        //                 ElevatedButton(
        //                   child: Text("Start "),
        //                   onPressed: routeBuilt && !isNavigating
        //                       ? () {
        //                           _controller?.startNavigation();
        //                         }
        //                       : null,
        //                 ),
        //                 SizedBox(
        //                   width: 10,
        //                 ),
        //                 ElevatedButton(
        //                   child: Text("Cancel "),
        //                   onPressed: isNavigating
        //                       ? () {
        //                           _controller?.finishNavigation();
        //                         }
        //                       : null,
        //                 )
        //               ],
        //             ),
        //             Center(
        //               child: Padding(
        //                 padding: EdgeInsets.all(10),
        //                 child: Text(
        //                   "Long-Press Embedded Map to Set Destination",
        //                   textAlign: TextAlign.center,
        //                 ),
        //               ),
        //             ),
        //             Container(
        //               color: Colors.grey,
        //               width: double.infinity,
        //               child: Padding(
        //                 padding: EdgeInsets.all(10),
        //                 child: (Text(
        //                   instruction == null || instruction.isEmpty
        //                       ? "Banner Instruction Here"
        //                       : instruction,
        //                   style: const TextStyle(color: Colors.white),
        //                   textAlign: TextAlign.center,
        //                 )),
        //               ),
        //             ),
        //             Padding(
        //               padding: const EdgeInsets.only(
        //                   left: 20.0, right: 20, top: 20, bottom: 10),
        //               child: Column(
        //                 mainAxisAlignment: MainAxisAlignment.center,
        //                 children: <Widget>[
        //                   Row(
        //                     children: <Widget>[
        //                       Text("Duration Remaining: "),
        //                       // Text(durationRemaining != null
        //                       //     ? "${(durationRemaining/ 60).toStringAsFixed(0)} minutes"
        //                       //     : "---")
        //                     ],
        //                   ),
        //                   Row(
        //                     children: <Widget>[
        //                       Text("Distance Remaining: "),
        //                       // Text(distanceRemaining != null
        //                       //     ? "${(distanceRemaining! * 0.000621371).toStringAsFixed(1)} miles"
        //                       //     : "---")
        //                     ],
        //                   ),
        //                 ],
        //               ),
        //             ),
        //             Divider()
        //           ],
        //         ),
        //       ),
        //     ),
        //     Expanded(
        //       flex: 1,
        //       child: Container(
        //         color: Colors.grey,
        //         child: MapBoxNavigationView(
        //             options: _options,
        //             onRouteEvent: _onEmbeddedRouteEvent,
        //             onCreated:
        //                 (MapBoxNavigationViewController controller) async {
        //               _controller = controller;
        //               controller.initialize();
        //             }),
        //       ),
        //     )
        //   ]),
        // ),
      ),
    );
  }
}
