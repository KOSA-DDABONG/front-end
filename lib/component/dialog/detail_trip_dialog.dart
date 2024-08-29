import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../dto/travel/my_travel_detail_data_model.dart';

void showDetailTripDialog(BuildContext context, String apiKey, List<MyTravelDetailDataModel> data) {
  int selectedDay = 1;
  int? selectedIndex;
  int travelDays = data.length;

  print("========================================================");
  print("여행 일정 상세 다이어로그 시작 [showDetailTripDialog]");
  print(data);
  print("========================================================");

  // 마커를 관리하고 경로를 생성하기 위한 변수들
  Map<int, Set<Marker>> markersByDay = {};
  Map<int, Polyline> polylinesByDay = {};
  GoogleMapController? mapController;

  // 마커 색상 배열 (날짜별로 다른 색상을 사용하기 위해)
  List<BitmapDescriptor> markerColors = [
    BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
  ];

  // 각 날짜별로 마커와 경로를 생성하는 함수
  void generateMarkersAndPolylines() {
    for (int i = 0; i < travelDays; i++) {
      Set<Marker> markers = {};
      List<LatLng> path = [];
      for (int j = 0; j < data[i].place.length; j++) {
        final place = data[i].place[j];
        markers.add(Marker(
          markerId: MarkerId('${i}_${j}'),
          position: LatLng(place.latitude, place.longitude),
          infoWindow: InfoWindow(title: place.name),
          icon: markerColors[i % markerColors.length], // 날짜별로 다른 색상 사용
        ));
        path.add(LatLng(place.latitude, place.longitude));
      }
      markersByDay[i] = markers;

      if (path.isNotEmpty) {
        polylinesByDay[i] = Polyline(
          polylineId: PolylineId('${i}_path'),
          points: path,
          color: Colors.orange, // 경로의 색상
          width: 3, // 경로의 두께
        );
      }
    }
  }

  // 마커와 경로 생성 함수 호출
  generateMarkersAndPolylines();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
              ),
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.8,
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      margin: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: GoogleMap(
                          onMapCreated: (controller) {
                            mapController = controller;
                          },
                          initialCameraPosition: CameraPosition(
                            target: LatLng(
                              data[0].place[0].latitude,
                              data[0].place[0].longitude,
                            ),
                            zoom: 12,
                          ),
                          markers: markersByDay[selectedDay - 1] ?? {},
                          polylines: {if (polylinesByDay.containsKey(selectedDay - 1)) polylinesByDay[selectedDay - 1]!},
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 20, 25, 30),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(travelDays, (index) {
                              return Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(5, 5, 5, 20),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        selectedDay = data[index].dayNum;
                                        selectedIndex = null;

                                        // 선택된 날짜의 마커와 경로로 지도 갱신
                                        if (mapController != null) {
                                          mapController!.animateCamera(
                                            CameraUpdate.newLatLngBounds(
                                              _boundsFromLatLngList(
                                                data[index].place.map((e) => LatLng(e.latitude, e.longitude)).toList(),
                                              ),
                                              50, // padding
                                            ),
                                          );
                                        }
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: selectedDay == data[index].dayNum ? Colors.blue : Colors.grey,
                                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                    child: Text(
                                      '${data[index].dayNum}일차',
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: data[selectedDay - 1].place.length,
                              itemBuilder: (context, index) {
                                var place = data[selectedDay - 1].place[index].name;
                                return Stack(
                                  children: [
                                    Positioned.fill(
                                      left: 12,
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: DashedLine(
                                          height: double.infinity,
                                          color: Colors.grey,
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: Colors.blue,
                                            radius: 12,
                                            child: Text(
                                              '${index + 1}',
                                              style: const TextStyle(color: Colors.white, fontSize: 12),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  selectedIndex = index;

                                                  // 선택된 장소의 위치로 지도 이동
                                                  if (mapController != null) {
                                                    mapController!.animateCamera(
                                                      CameraUpdate.newLatLng(
                                                        LatLng(
                                                          data[selectedDay - 1].place[index].latitude,
                                                          data[selectedDay - 1].place[index].longitude,
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                });
                                              },
                                              child: Card(
                                                color: selectedIndex == index ? Colors.lightBlueAccent : Colors.white,
                                                child: ListTile(
                                                  title: Text(
                                                    place,
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

// 지도에서 마커들을 포함하는 LatLngBounds를 생성하는 함수
LatLngBounds _boundsFromLatLngList(List<LatLng> list) {
  assert(list.isNotEmpty);
  double x0 = list.first.latitude, x1 = list.first.latitude;
  double y0 = list.first.longitude, y1 = list.first.longitude;

  for (LatLng latLng in list) {
    if (latLng.latitude > x1) x1 = latLng.latitude;
    if (latLng.latitude < x0) x0 = latLng.latitude;
    if (latLng.longitude > y1) y1 = latLng.longitude;
    if (latLng.longitude < y0) y0 = latLng.longitude;
  }

  return LatLngBounds(
    northeast: LatLng(x1, y1),
    southwest: LatLng(x0, y0),
  );
}

class DashedLine extends StatelessWidget {
  final double height;
  final Color color;
  final double strokeWidth;

  DashedLine({
    required this.height,
    required this.color,
    this.strokeWidth = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(strokeWidth, height),
      painter: _DashedLinePainter(
        color: color,
        strokeWidth: strokeWidth,
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  _DashedLinePainter({
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double dashHeight = 5, dashSpace = 5, startY = 0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth;

    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
