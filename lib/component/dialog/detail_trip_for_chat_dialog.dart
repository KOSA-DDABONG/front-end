import 'package:flutter/material.dart';
import 'package:front/responsive.dart';

import '../../constants.dart';
import '../../key/key.dart';
import '../map/get_map_for_chat.dart';

void showDetailTripForChatDialog(BuildContext context, String apiKey, Map<String, dynamic> scheduleInfo) {
  int selectedDay = 1;
  int? selectedIndex;

  List<String> getPlaceNames(String keyValue) {
    // 일정에 포함된 장소 이름들 리스트를 반환
    List<String> placeNames = [];
    var dayInfo = scheduleInfo[keyValue];

    for (var entry in dayInfo.entries) {
      var value = entry.value;
      if (value is List) {
        if (value.isNotEmpty && value[0] is List) {
          // tourist_spots와 같이 중첩된 리스트의 경우
          for (var spot in value) {
            placeNames.add(spot[0]); // 장소 이름 추출
          }
        } else {
          // 일반 리스트의 경우
          placeNames.add(value[0]); // 장소 이름 추출
        }
      }
    }
    return placeNames;
  }

  List<List<double>> getLatitudes() {
    // 일정에 포함된 장소 위도 리스트를 반환
    List<List<double>> latitudes = [];
    for (var day in scheduleInfo.keys) {
      var dayInfo = scheduleInfo[day];
      List<double> placeLatitude = [];
      for (var entry in dayInfo.entries) {
        var value = entry.value;
        if (value is List) {
          if (value.isNotEmpty && value[0] is List) {
            // tourist_spots와 같이 중첩된 리스트의 경우
            for (var spot in value) {
              placeLatitude.add(spot[1]); // 장소 위도 추출
            }
          } else {
            // 일반 리스트의 경우
            placeLatitude.add(value[1]); // 장소 위도 추출
          }
        }
      }
      latitudes.add(placeLatitude);
    }
    return latitudes;
  }

  List<List<double>> getLongitudes() {
    // 일정에 포함된 장소 경도 리스트를 반환
    List<List<double>> longitudes = [];
    for (var day in scheduleInfo.keys) {
      var dayInfo = scheduleInfo[day];
      List<double> placeLongitude = [];
      for (var entry in dayInfo.entries) {
        var value = entry.value;
        if (value is List) {
          if (value.isNotEmpty && value[0] is List) {
            // tourist_spots와 같이 중첩된 리스트의 경우
            for (var spot in value) {
              placeLongitude.add(spot[2]); // 장소 경도 추출
            }
          } else {
            // 일반 리스트의 경우
            placeLongitude.add(value[2]); // 장소 경도 추출
          }
        }
      }
      longitudes.add(placeLongitude);
    }
    return longitudes;
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          if (Responsive.isNarrowWidth(context)) {
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
                child: Column(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Container(
                        margin: const EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueAccent),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: GetMapForChat(
                            latitudes: getLatitudes(),
                            longitudes: getLongitudes(),
                            selectedDay: selectedDay,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 15),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: List.generate(scheduleInfo.length, (index) {
                                return Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(5, 5, 5, 20),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          selectedDay = index + 1;
                                          selectedIndex = null;
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: selectedDay == index + 1 ? pointColor : Colors.grey,
                                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                      child: Text(
                                        '${index + 1}일차',
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: getPlaceNames(selectedDay.toString()).length,
                                itemBuilder: (context, index) {
                                  var placeNames = getPlaceNames(selectedDay.toString());
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
                                                  });
                                                },
                                                child: Card(
                                                  color: selectedIndex == index ? Colors.lightBlueAccent : Colors.white,
                                                  child: ListTile(
                                                    title: Text(
                                                      placeNames[index],
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
          } else {
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
                          child: GetMapForChat(
                            latitudes: getLatitudes(),
                            longitudes: getLongitudes(),
                            selectedDay: selectedDay,
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
                              children: List.generate(scheduleInfo.length, (index) {
                                return Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(5, 5, 5, 20),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          selectedDay = index + 1;
                                          selectedIndex = null;
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: selectedDay == index + 1 ? pointColor : Colors.grey,
                                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                      child: Text(
                                        '${index + 1}일차',
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: getPlaceNames(selectedDay.toString()).length,
                                itemBuilder: (context, index) {
                                  var placeNames = getPlaceNames(selectedDay.toString());
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
                                                  });
                                                },
                                                child: Card(
                                                  color: selectedIndex == index ? Colors.lightBlueAccent : Colors.white,
                                                  child: ListTile(
                                                    title: Text(
                                                      placeNames[index],
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
          }
        },
      );
    },
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