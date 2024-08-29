import 'package:flutter/material.dart';
import 'package:front/responsive.dart';

import '../../constants.dart';
import '../../dto/travel/my_travel_detail_data_model.dart';
import '../../key/key.dart';
import '../map/get_map.dart';


void showDetailTripDialog(BuildContext context, String apiKey, List<MyTravelDetailDataModel> data) {
  int selectedDay = 1;  // 첫 번째 날을 기본 선택으로 설정
  int? selectedIndex;
  int travelDays = data.length; //여행 날짜

  print("========================================================");
  print("여행 일정 상세 다이어로그 시작 [showDetailTripDialog]");
  print(data);
  print("========================================================");

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
                          child: GetMap(
                            apiKey: GOOGLE_MAP_KEY,
                            origin: '{35.819929,129.478255}',
                            destination: '{35.787994,129.407437}',
                            waypoints: '{35.76999,129.44696}',
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
                              children: List.generate(travelDays, (index) {
                                return Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(5, 5, 5, 20),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          selectedDay = data[index].dayNum;
                                          selectedIndex = null;
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: selectedDay == data[index].dayNum ? pointColor : Colors.grey,
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
          }
          else {
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
                          child: GetMap(
                              apiKey: GOOGLE_MAP_KEY,
                              origin: '{35.819929,129.478255}',
                              destination: '{35.787994,129.407437}',
                              waypoints: '{35.76999,129.44696}'
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
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: selectedDay == index + 1 ? pointColor : Colors.grey,
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