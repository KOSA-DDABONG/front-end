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
//         '?origin=${widget.origin}&destination=${widget.destination}'
//         '&waypoints=${widget.waypoints}'
//         '&key=${widget.apiKey}';
//
//     try {
//       final response = await http.get(Uri.parse(url));
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
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
//                 color: Colors.blue,
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
//         target: LatLng(37.7881703, -122.4077324), // Start position
//         zoom: 12,
//       ),
//       polylines: _polylines,
//       markers: _markers,
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class GetMap extends StatefulWidget {
  final String apiKey;
  final List<String> origins;
  final List<String> destinations;
  final List<List<String>> waypoints; // 2차원 리스트

  GetMap({
    required this.apiKey,
    required this.origins,
    required this.destinations,
    required this.waypoints,
  });

  @override
  _GetMapState createState() => _GetMapState();
}

class _GetMapState extends State<GetMap> {
  final Set<Polyline> _polylines = {};
  final Set<Marker> _markers = {};
  final List<Color> colors = [Colors.red, Colors.blue, Colors.yellow, Colors.green, Colors.orange];

  @override
  void initState() {
    super.initState();
    _fetchRoutes();
  }

  Future<void> _fetchRoutes() async {
    for (int i = 0; i < widget.origins.length; i++) {
      final waypointsString = widget.waypoints[i].join('|');
      final url =
          'https://cors-anywhere.herokuapp.com/https://maps.googleapis.com/maps/api/directions/json'
          '?origin=${widget.origins[i]}'
          '&destination=${widget.destinations[i]}'
          '&waypoints=$waypointsString'
          '&key=${widget.apiKey}';

      try {
        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final encodedPoints = data['routes'][0]['overview_polyline']['points'];
          final points = PolylinePoints().decodePolyline(encodedPoints);

          if (points != null) {
            final polylineCoordinates = points
                .map((point) => LatLng(point.latitude, point.longitude))
                .toList();

            setState(() {
              _polylines.add(
                Polyline(
                  polylineId: PolylineId('route_$i'),
                  color: colors[i % colors.length], // 색상 순환 사용
                  points: polylineCoordinates,
                  width: 4,
                ),
              );
            });

            // 마커 추가: 출발지, 경유지들, 도착지
            _markers.add(Marker(
              markerId: MarkerId('origin_$i'),
              position: _getLatLng(widget.origins[i]),
              infoWindow: InfoWindow(title: '출발지 $i'),
            ));

            for (int j = 0; j < widget.waypoints[i].length; j++) {
              _markers.add(Marker(
                markerId: MarkerId('waypoint_${i}_$j'),
                position: _getLatLng(widget.waypoints[i][j]),
                infoWindow: InfoWindow(title: '경유지 ${i + 1}-${j + 1}'),
              ));
            }

            _markers.add(Marker(
              markerId: MarkerId('destination_$i'),
              position: _getLatLng(widget.destinations[i]),
              infoWindow: InfoWindow(title: '도착지 $i'),
            ));
          }
        } else {
          print('Failed to load route $i: ${response.statusCode}');
        }
      } catch (e) {
        print('Error fetching polyline data for route $i: $e');
      }
    }
  }

  LatLng _getLatLng(String location) {
    final parts = location.split(',');
    final lat = double.parse(parts[0]);
    final lng = double.parse(parts[1]);
    return LatLng(lat, lng);
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: const CameraPosition(
        target: LatLng(37.7881703, -122.4077324), // Start position
        zoom: 12,
      ),
      polylines: _polylines,
      markers: _markers,
    );
  }
}
