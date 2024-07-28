// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
// class GetMap extends StatefulWidget {
//   const GetMap({Key? key}) : super(key: key);
//
//   @override
//   _GetMapState createState() => _GetMapState();
// }
//
// class _GetMapState extends State<GetMap> {
//   final Completer<GoogleMapController> _controller = Completer();
//   static final CameraPosition _kGooglePlex = CameraPosition(
//     target: LatLng(37.42796133580664, -122.085749655962),
//     zoom: 14.4746,
//   );
//
//   @override
//   Widget build(BuildContext context) {
//     return GoogleMap(
//       mapType: MapType.hybrid,
//       initialCameraPosition: _kGooglePlex,
//       onMapCreated: (GoogleMapController controller) {
//         _controller.complete(controller);
//       },
//     );
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GetMap extends StatefulWidget {
  final List<LatLng> day1Coordinates;
  final List<LatLng> day2Coordinates;

  const GetMap({Key? key, required this.day1Coordinates, required this.day2Coordinates}) : super(key: key);

  @override
  _GetMapState createState() => _GetMapState();
}

class _GetMapState extends State<GetMap> {
  final Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      mapType: MapType.hybrid,
      initialCameraPosition: _kGooglePlex,
      markers: _createMarkers(),
      polylines: _createPolylines(),
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
    );
  }

  Set<Marker> _createMarkers() {
    Set<Marker> markers = {};

    for (int i = 0; i < widget.day1Coordinates.length; i++) {
      markers.add(
        Marker(
          markerId: MarkerId('day1_marker_$i'),
          position: widget.day1Coordinates[i],
          infoWindow: InfoWindow(title: 'Day 1 - Stop ${i + 1}'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
    }

    for (int i = 0; i < widget.day2Coordinates.length; i++) {
      markers.add(
        Marker(
          markerId: MarkerId('day2_marker_$i'),
          position: widget.day2Coordinates[i],
          infoWindow: InfoWindow(title: 'Day 2 - Stop ${i + 1}'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
        ),
      );
    }

    return markers;
  }

  Set<Polyline> _createPolylines() {
    Set<Polyline> polylines = {};

    if (widget.day1Coordinates.length > 1) {
      polylines.add(
        Polyline(
          polylineId: PolylineId('day1_route'),
          points: widget.day1Coordinates,
          color: Colors.blue,
          width: 5,
        ),
      );
    }

    if (widget.day2Coordinates.length > 1) {
      polylines.add(
        Polyline(
          polylineId: PolylineId('day2_route'),
          points: widget.day2Coordinates,
          color: Colors.yellow,
          width: 5,
        ),
      );
    }

    return polylines;
  }
}
