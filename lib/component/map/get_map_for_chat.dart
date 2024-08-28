import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class GetMapForChat extends StatefulWidget {
  final List<List<dynamic>> dayScheduleData;
  final int selectedDay;
  final LatLng? selectedPlace;
  final int? selectedIndex;
  final String googleApiKey; // API 키 추가

  GetMapForChat({
    required this.dayScheduleData,
    required this.selectedDay,
    this.selectedPlace,
    this.selectedIndex,
    required this.googleApiKey, // API 키 추가
  });

  @override
  _GetMapState createState() => _GetMapState();
}

class _GetMapState extends State<GetMapForChat> {
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  late GoogleMapController _mapController;

  @override
  void initState() {
    super.initState();
    _updateMarkers();
    _fetchRoute(); // 실제 경로 가져오기
  }

  @override
  void didUpdateWidget(GetMapForChat oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDay != oldWidget.selectedDay ||
        widget.selectedIndex != oldWidget.selectedIndex) {
      _clearPolylines(); // 폴리라인 초기화
      _updateMarkers();
      _fetchRoute(); // 실제 경로 가져오기
      _moveCameraToSelectedPlace();
    }
  }

  void _updateMarkers() {
    _markers.clear(); // 기존 마커 지우기

    final colors = [
      Colors.red,
      Colors.blue,
      Colors.yellow,
      Colors.green,
      Colors.orange,
      Colors.deepPurpleAccent,
    ];

    final dayData = widget.dayScheduleData[widget.selectedDay - 1];
    final markerColor = colors[widget.selectedDay - 1];

    for (int i = 0; i < dayData.length; i++) {
      final place = dayData[i];
      final name = place[0];
      final latitude = place[1];
      final longitude = place[2];

      _markers.add(Marker(
        markerId: MarkerId('day${widget.selectedDay}_$i'),
        position: LatLng(latitude, longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          markerColor == Colors.red
              ? BitmapDescriptor.hueRed
              : markerColor == Colors.blue
              ? BitmapDescriptor.hueBlue
              : BitmapDescriptor.hueYellow,
        ),
        infoWindow: InfoWindow(title: name),
      ));
    }
    setState(() {});
  }

  Future<void> _fetchRoute() async {
    final dayData = widget.dayScheduleData[widget.selectedDay - 1];
    if (dayData.length < 2) return; // 최소 2개 이상의 포인트가 있어야 경로를 그릴 수 있습니다.

    final origin = '${dayData.first[1]},${dayData.first[2]}';
    final destination = '${dayData.last[1]},${dayData.last[2]}';
    final waypoints = dayData
        .skip(1)
        .take(dayData.length - 2)
        .map((place) => '${place[1]},${place[2]}')
        .join('|');

    final url =
        'https://cors-anywhere.herokuapp.com/https://maps.googleapis.com/maps/api/directions/json'
        '?origin=$origin'
        '&destination=$destination'
        '&waypoints=optimize:true|$waypoints'
        '&key=${widget.googleApiKey}';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['routes'] != null && data['routes'].isNotEmpty) {
          final encodedPoints = data['routes'][0]['overview_polyline']['points'];
          final points = PolylinePoints().decodePolyline(encodedPoints);

          if (points != null) {
            final polylineCoordinates = points
                .map((point) => LatLng(point.latitude, point.longitude))
                .toList();

            setState(() {
              _polylines.add(
                Polyline(
                  polylineId: PolylineId('day${widget.selectedDay}_route'),
                  color: Colors.blue,
                  points: polylineCoordinates,
                  width: 4,
                ),
              );
            });
          }
        } else {
          print('No routes found in the API response.');
          // 기본 직선 폴리라인 추가
          _addDefaultPolyline(dayData);
        }
      } else {
        print('Failed to load route: ${response.statusCode}');
        // 기본 직선 폴리라인 추가
        _addDefaultPolyline(dayData);
      }
    } catch (e) {
      print('Error fetching polyline data: $e');
      // 기본 직선 폴리라인 추가
      _addDefaultPolyline(dayData);
    }
  }

  void _clearPolylines() {
    setState(() {
      _polylines.clear(); // 기존 폴리라인 지우기
    });
  }

  void _addDefaultPolyline(List<dynamic> dayData) {
    final polylinePoints = dayData.map((place) => LatLng(place[1], place[2])).toList();

    setState(() {
      _polylines.add(
        Polyline(
          polylineId: PolylineId('day${widget.selectedDay}_default_route'),
          color: Colors.blue,
          points: polylinePoints,
          width: 4,
        ),
      );
    });
  }

  void _moveCameraToSelectedPlace() {
    if (widget.selectedIndex != null) {
      final dayData = widget.dayScheduleData[widget.selectedDay - 1];
      if (widget.selectedIndex! < dayData.length) {
        final place = dayData[widget.selectedIndex!];
        final position = LatLng(place[1], place[2]);
        _mapController.animateCamera(CameraUpdate.newLatLng(position));
      }
    } else if (widget.selectedPlace != null) {
      _mapController.animateCamera(
        CameraUpdate.newLatLng(widget.selectedPlace!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final initialPosition = widget.dayScheduleData[widget.selectedDay - 1].isNotEmpty
        ? LatLng(widget.dayScheduleData[widget.selectedDay - 1][0][1], widget.dayScheduleData[widget.selectedDay - 1][0][2])
        : const LatLng(0.0, 0.0);

    return GoogleMap(
      onMapCreated: (GoogleMapController controller) {
        _mapController = controller;
      },
      initialCameraPosition: CameraPosition(
        target: initialPosition,
        zoom: 10,
      ),
      markers: _markers,
      polylines: _polylines,
    );
  }
}