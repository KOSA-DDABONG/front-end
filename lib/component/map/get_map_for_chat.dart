import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GetMapForChat extends StatefulWidget {
  final List<List<double>> latitudes;
  final List<List<double>> longitudes;
  final int selectedDay;

  GetMapForChat({
    required this.latitudes,
    required this.longitudes,
    required this.selectedDay,
  });

  @override
  _GetMapState createState() => _GetMapState();
}

class _GetMapState extends State<GetMapForChat> {
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _updateMarkers();
  }

  @override
  void didUpdateWidget(GetMapForChat oldWidget) {
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