import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GetMapForChat extends StatefulWidget {
  final List<List<dynamic>> dayScheduleData;
  final int selectedDay;
  final LatLng? selectedPlace; // 기존
  final int? selectedIndex; // 추가된 부분

  GetMapForChat({
    required this.dayScheduleData,
    required this.selectedDay,
    this.selectedPlace,
    this.selectedIndex, // 추가된 부분
  });

  @override
  _GetMapState createState() => _GetMapState();
}

class _GetMapState extends State<GetMapForChat> {
  final Set<Marker> _markers = {};
  late GoogleMapController _mapController;

  @override
  void initState() {
    super.initState();
    _updateMarkers();
  }

  @override
  void didUpdateWidget(GetMapForChat oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDay != oldWidget.selectedDay ||
        widget.selectedIndex != oldWidget.selectedIndex) {
      _updateMarkers();
      _moveCameraToSelectedPlace();
    }
  }

  void _updateMarkers() {
    _markers.clear(); // 기존 마커 지우기

    final colors = [
      Colors.red,    // 1일차
      Colors.blue,   // 2일차
      Colors.yellow, // 3일차
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
        : LatLng(0.0, 0.0);

    return GoogleMap(
      onMapCreated: (GoogleMapController controller) {
        _mapController = controller;
      },
      initialCameraPosition: CameraPosition(
        target: initialPosition,
        zoom: 10,
      ),
      markers: _markers,
    );
  }
}
