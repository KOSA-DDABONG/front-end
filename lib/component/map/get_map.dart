// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:http/http.dart' as http;
//
// class GetMap extends StatefulWidget {
//   final String apiKey;
//   final String origin;
//   final String destination;
//   final String waypoints;
//
//   GetMap({
//     required this.apiKey,
//     required this.origin,
//     required this.destination,
//     required this.waypoints,
//   });
//
//   @override
//   _GetMapState createState() => _GetMapState();
// }
//
// class _GetMapState extends State<GetMap> {
//   final Set<Polyline> _polylines = {};
//   final Set<Marker> _markers = {};
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchRoute();
//   }
//
//   Future<void> _fetchRoute() async {
//     final url =
//         'https://cors-anywhere.herokuapp.com/https://maps.googleapis.com/maps/api/directions/json'
//         '?origin=${widget.origin}'
//         '&destination=${widget.destination}'
//         '&waypoints=${widget.waypoints}'
//         '&key=${widget.apiKey}';
//     // final url = 'https://cors-anywhere.herokuapp.com/https://maps.googleapis.com/maps/api/directions/json?origin=6.9146871,79.9711348&waypoint=6.9040322,79.948803%7C&destination=6.9058482,79.9248089&sensor=false&key=AIzaSyBqFhlY9_6H7ZddukaBR7RCwzg_wYT0x1A';
//
//     try {
//       final response = await http.get(Uri.parse(url));
//       print("hihihihihi1");
//       print(response.body);
//       print("0000000");
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         print("hihihihihi2");
//         print(data);
//         print("0000000");
//         final encodedPoints = data['routes'][0]['overview_polyline']['points'];
//         final points = PolylinePoints().decodePolyline(encodedPoints);
//
//         if (points != null) {
//           final polylineCoordinates = points
//               .map((point) => LatLng(point.latitude, point.longitude))
//               .toList();
//
//           setState(() {
//             _polylines.add(
//               Polyline(
//                 polylineId: PolylineId('route'),
//                 color: Colors.red,
//                 points: polylineCoordinates,
//                 width: 4,
//               ),
//             );
//           });
//
//           // 마커 추가
//           setState(() {
//             _markers.add(Marker(
//               markerId: MarkerId('origin'),
//               position: LatLng(37.819929, -122.478255),
//               infoWindow: InfoWindow(title: '출발지'),
//             ));
//             _markers.add(Marker(
//               markerId: MarkerId('waypoint1'),
//               position: LatLng(37.76999, -122.44696),
//               infoWindow: InfoWindow(title: '경유지 1'),
//             ));
//             _markers.add(Marker(
//               markerId: MarkerId('waypoint2'),
//               position: LatLng(37.76899, -122.44596),
//               infoWindow: InfoWindow(title: '경유지 2'),
//             ));
//             _markers.add(Marker(
//               markerId: MarkerId('destination'),
//               position: LatLng(37.787994, -122.407437),
//               infoWindow: InfoWindow(title: '도착지'),
//             ));
//           });
//         }
//       } else {
//         print('Failed to load route: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error fetching polyline data: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GoogleMap(
//       initialCameraPosition: const CameraPosition(
//         target: LatLng(35.1796, 129.0756), // Start position
//         zoom: 12,
//       ),
//       polylines: _polylines,
//       markers: _markers,
//     );
//   }
// }


//2
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
// class GetMap extends StatefulWidget {
//   final List<List<double>> latitudes;
//   final List<List<double>> longitudes;
//   final int selectedDay;
//
//   GetMap({
//     required this.latitudes,
//     required this.longitudes,
//     required this.selectedDay,
//   });
//
//   @override
//   _GetMapState createState() => _GetMapState();
// }
//
// class _GetMapState extends State<GetMap> {
//   final Set<Marker> _markers = {};
//
//   @override
//   void initState() {
//     super.initState();
//     _addMarkers();
//   }
//
//   void _addMarkers() {
//     final List<double> latitudes = widget.latitudes[widget.selectedDay - 1];
//     final List<double> longitudes = widget.longitudes[widget.selectedDay - 1];
//     final Color markerColor = widget.selectedDay == 1 ? Colors.red : Colors.yellow;
//
//     for (int i = 0; i < latitudes.length; i++) {
//       _markers.add(Marker(
//         markerId: MarkerId('day${widget.selectedDay}_$i'),
//         position: LatLng(latitudes[i], longitudes[i]),
//         icon: BitmapDescriptor.defaultMarkerWithHue(
//           markerColor == Colors.red ? BitmapDescriptor.hueRed : BitmapDescriptor.hueYellow,
//         ),
//         infoWindow: InfoWindow(title: 'Location ${i + 1}'),
//       ));
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final initialPosition = LatLng(
//       widget.latitudes[widget.selectedDay - 1][0],
//       widget.longitudes[widget.selectedDay - 1][0],
//     );
//
//     return GoogleMap(
//       initialCameraPosition: CameraPosition(
//         target: initialPosition,
//         zoom: 12,
//       ),
//       markers: _markers,
//     );
//   }
// }




// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
// class GetMap extends StatefulWidget {
//   final List<List<double>> latitudes;
//   final List<List<double>> longitudes;
//   final int selectedDay;
//
//   GetMap({
//     required this.latitudes,
//     required this.longitudes,
//     required this.selectedDay,
//   });
//
//   @override
//   _GetMapState createState() => _GetMapState();
// }
//
// class _GetMapState extends State<GetMap> {
//   final Set<Marker> _markers = {};
//
//   @override
//   void initState() {
//     super.initState();
//     _addMarkers();
//   }
//
//   void _addMarkers() {
//     for (int day = 0; day < widget.latitudes.length; day++) {
//       final latitudes = widget.latitudes[day];
//       final longitudes = widget.longitudes[day];
//       final Color markerColor = day + 1 == widget.selectedDay ? Colors.red : Colors.grey;
//
//       for (int i = 0; i < latitudes.length; i++) {
//         _markers.add(Marker(
//           markerId: MarkerId('day${day + 1}_$i'),
//           position: LatLng(latitudes[i], longitudes[i]),
//           icon: BitmapDescriptor.defaultMarkerWithHue(
//             markerColor == Colors.red ? BitmapDescriptor.hueMagenta : BitmapDescriptor.hueBlue,
//           ),
//           infoWindow: InfoWindow(title: 'Location ${i + 1}'),
//         ));
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final initialPosition = LatLng(
//       widget.latitudes[widget.selectedDay - 1][0],
//       widget.longitudes[widget.selectedDay - 1][0],
//     );
//
//     return GoogleMap(
//       initialCameraPosition: CameraPosition(
//         target: initialPosition,
//         zoom: 12,
//       ),
//       markers: _markers,
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GetMap extends StatefulWidget {
  final List<List<double>> latitudes;
  final List<List<double>> longitudes;
  final int selectedDay;

  GetMap({
    required this.latitudes,
    required this.longitudes,
    required this.selectedDay,
  });

  @override
  _GetMapState createState() => _GetMapState();
}

class _GetMapState extends State<GetMap> {
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _updateMarkers();
  }

  @override
  void didUpdateWidget(GetMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDay != oldWidget.selectedDay) {
      _updateMarkers();
    }
  }

  void _updateMarkers() {
    _markers.clear(); // 기존 마커 지우기

    for (int day = 0; day < widget.latitudes.length; day++) {
      final latitudes = widget.latitudes[day];
      final longitudes = widget.longitudes[day];
      final Color markerColor = day + 1 == widget.selectedDay ? Colors.red : Colors.grey;

      for (int i = 0; i < latitudes.length; i++) {
        _markers.add(Marker(
          markerId: MarkerId('day${day + 1}_$i'),
          position: LatLng(latitudes[i], longitudes[i]),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            markerColor == Colors.red ? BitmapDescriptor.hueRed : BitmapDescriptor.hueBlue,
          ),
          infoWindow: InfoWindow(title: 'Location ${i + 1}'),
        ));
      }
    }
    setState(() {}); // 마커 업데이트 후 UI 리빌드
  }

  @override
  Widget build(BuildContext context) {
    final initialPosition = widget.latitudes[widget.selectedDay - 1].isNotEmpty
        ? LatLng(widget.latitudes[widget.selectedDay - 1][0], widget.longitudes[widget.selectedDay - 1][0])
        : LatLng(0.0, 0.0);

    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: initialPosition,
        zoom: 12,
      ),
      markers: _markers,
    );
  }
}
