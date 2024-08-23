import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class GetMap extends StatefulWidget {
  final String apiKey;
  final String origin;
  final String destination;
  final String waypoints;

  GetMap({
    required this.apiKey,
    required this.origin,
    required this.destination,
    required this.waypoints,
  });

  @override
  _GetMapState createState() => _GetMapState();
}

class _GetMapState extends State<GetMap> {
  final Set<Polyline> _polylines = {};
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _fetchRoute();
  }

  Future<void> _fetchRoute() async {
    final url =
        'https://cors-anywhere.herokuapp.com/https://maps.googleapis.com/maps/api/directions/json'
        '?origin=${widget.origin}'
        '&destination=${widget.destination}'
        '&waypoints=${widget.waypoints}'
        '&key=${widget.apiKey}';
    // final url = 'https://cors-anywhere.herokuapp.com/https://maps.googleapis.com/maps/api/directions/json?origin=6.9146871,79.9711348&waypoint=6.9040322,79.948803%7C&destination=6.9058482,79.9248089&sensor=false&key=AIzaSyBqFhlY9_6H7ZddukaBR7RCwzg_wYT0x1A';

    try {
      final response = await http.get(Uri.parse(url));
      print("hihihihihi1");
      print(response.body);
      print("0000000");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("hihihihihi2");
        print(data);
        print("0000000");
        final encodedPoints = data['routes'][0]['overview_polyline']['points'];
        final points = PolylinePoints().decodePolyline(encodedPoints);

        if (points != null) {
          final polylineCoordinates = points
              .map((point) => LatLng(point.latitude, point.longitude))
              .toList();

          setState(() {
            _polylines.add(
              Polyline(
                polylineId: PolylineId('route'),
                color: Colors.red,
                points: polylineCoordinates,
                width: 4,
              ),
            );
          });

          // 마커 추가
          setState(() {
            _markers.add(Marker(
              markerId: MarkerId('origin'),
              position: LatLng(37.819929, -122.478255),
              infoWindow: InfoWindow(title: '출발지'),
            ));
            _markers.add(Marker(
              markerId: MarkerId('waypoint1'),
              position: LatLng(37.76999, -122.44696),
              infoWindow: InfoWindow(title: '경유지 1'),
            ));
            _markers.add(Marker(
              markerId: MarkerId('waypoint2'),
              position: LatLng(37.76899, -122.44596),
              infoWindow: InfoWindow(title: '경유지 2'),
            ));
            _markers.add(Marker(
              markerId: MarkerId('destination'),
              position: LatLng(37.787994, -122.407437),
              infoWindow: InfoWindow(title: '도착지'),
            ));
          });
        }
      } else {
        print('Failed to load route: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching polyline data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: const CameraPosition(
        target: LatLng(35.1796, 129.0756), // Start position
        zoom: 12,
      ),
      polylines: _polylines,
      markers: _markers,
    );
  }
}