import 'package:flutter/material.dart';
import 'package:front/responsive.dart';

import '../../constants.dart';
import '../../key/key.dart';
import '../map/get_map.dart';

void showDetailTripDialog(BuildContext context, String apiKey, List<List<Map<String, String>>> itinerary) {
  int selectedDay = 1;
  int? selectedIndex;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          if(Responsive.isNarrowWidth(context)) {
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
                              origin: '35.819929,129.478255',
                              destination: '35.787994,129.407437',
                              waypoints: '35.76999,129.44696'
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
                              children: List.generate(3, (index) {
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
                                itemCount: itinerary[selectedDay - 1].length,
                                itemBuilder: (context, index) {
                                  var place = itinerary[selectedDay - 1][index];
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
                                                    leading: ClipRRect(
                                                      borderRadius: BorderRadius.circular(5),
                                                      child: Image.asset(place['image']!,
                                                          width: 60, height: 60, fit: BoxFit.cover
                                                      ),
                                                    ),
                                                    title: Text(
                                                      place['title']!,
                                                      style: const TextStyle(
                                                          fontWeight: FontWeight.bold, fontSize: 16
                                                      ),
                                                    ),
                                                    subtitle: Text(place['time']!,
                                                        style: const TextStyle(fontSize: 14)
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
                              origin: '35.819929,129.478255',
                              destination: '35.787994,129.407437',
                              waypoints: '35.76999,129.44696'
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
                              children: List.generate(3, (index) {
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
                                itemCount: itinerary[selectedDay - 1].length,
                                itemBuilder: (context, index) {
                                  var place = itinerary[selectedDay - 1][index];
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
                                                    leading: ClipRRect(
                                                      borderRadius: BorderRadius.circular(5),
                                                      child: Image.asset(place['image']!,
                                                          width: 60, height: 60, fit: BoxFit.cover
                                                      ),
                                                    ),
                                                    title: Text(
                                                      place['title']!,
                                                      style: const TextStyle(
                                                          fontWeight: FontWeight.bold, fontSize: 16
                                                      ),
                                                    ),
                                                    subtitle: Text(place['time']!,
                                                        style: const TextStyle(fontSize: 14)
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
    return Container(
      height: height,
      width: 2,
      child: CustomPaint(
        painter: DashedLinePainter(color: color, strokeWidth: strokeWidth),
      ),
    );
  }
}

class DashedLinePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  DashedLinePainter({required this.color, this.strokeWidth = 2.0});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    double dashWidth = 8,
        dashSpace = 3,
        startY = 0;
    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashWidth), paint);
      startY += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

