import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GetMapForChat extends StatefulWidget {
  final List<List<dynamic>> dayScheduleData;
  final int selectedDay;

  GetMapForChat({
    required this.dayScheduleData,
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

    final colors = [
      Colors.red,    // 1일차
      Colors.blue,   // 2일차
      Colors.yellow, // 3일차
      // 필요한 경우 색상을 추가할 수 있습니다.
    ];

    // 선택된 날짜에 대한 데이터 가져오기
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
    setState(() {}); // 마커 업데이트 후 UI 리빌드
  }

  @override
  Widget build(BuildContext context) {
    final initialPosition = widget.dayScheduleData[widget.selectedDay - 1].isNotEmpty
        ? LatLng(widget.dayScheduleData[widget.selectedDay - 1][0][1], widget.dayScheduleData[widget.selectedDay - 1][0][2])
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
