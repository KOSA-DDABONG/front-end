import 'dart:convert'; // For jsonDecode
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http; // For making HTTP requests

class Map2Screen extends StatefulWidget {
  @override
  _Map2ScreenState createState() => _Map2ScreenState();
}

class _Map2ScreenState extends State<Map2Screen> {
  final Set<Polyline> _polylines = {};
  final Set<Marker> _markers = {};
  final String _apiKey = '[YOUR API KEY]';

  @override
  void initState() {
    super.initState();
    _fetchRoute();
  }

  Future<void> _fetchRoute() async {
    final origin = '37.819929,-122.478255'; // 출발지 좌표
    final destination = '37.787994,-122.407437'; // 도착지 좌표
    final waypoints = '37.76999,-122.44696|37.76899,-122.44596'; // 경유지 좌표

    // https://cors-anywhere.herokuapp.com/corsdemo
    final url = 'https://cors-anywhere.herokuapp.com/https://maps.googleapis.com/maps/api/directions/json'
        '?origin=$origin&destination=$destination'
        '&waypoints=$waypoints'
        '&key=$_apiKey';

    print('url: ' + url);
    try {
      final response = await http.get(Uri.parse(url));
      print('response: ' + response.statusCode.toString());
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
                polylineId: PolylineId('route'),
                color: Colors.blue,
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Map Example'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(37.7881703, -122.4077324), // Start position
          zoom: 12,
        ),
        polylines: _polylines,
        markers: _markers, // 마커 추가
      ),
    );
  }
}
