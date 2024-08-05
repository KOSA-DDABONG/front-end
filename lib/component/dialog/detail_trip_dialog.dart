import 'package:flutter/material.dart';

import '../../constants.dart';
import '../map/get_map.dart';

void showDetailTripDialog(BuildContext context) {
  int selectedDay = 1;
  int? selectedIndex;

  List<List<Map<String, String>>> itinerary = [
    [
      {'title': '부산역', 'time': '오전 07:48 - 오전 10:03', 'image': '../assets/images/noImg.jpg'},
      {'title': '부산 돼지 국밥', 'time': '오전 10:10 - 오전 10:45', 'image': '../assets/images/noImg.jpg'},
      {'title': '감천 문화 마을', 'time': '오전 10:45 - 오전 12:00', 'image': '../assets/images/noImg.jpg'},
      {'title': '부산역', 'time': '오전 07:48 - 오전 10:03', 'image': '../assets/images/noImg.jpg'},
      {'title': '부산 돼지 국밥', 'time': '오전 10:10 - 오전 10:45', 'image': '../assets/images/noImg.jpg'},
      {'title': '감천 문화 마을', 'time': '오전 10:45 - 오전 12:00', 'image': '../assets/images/noImg.jpg'},
    ],
    [
      {'title': '해운대 해수욕장', 'time': '오전 09:00 - 오후 12:00', 'image': '../assets/images/noImg.jpg'},
      {'title': '광안리 해수욕장', 'time': '오후 01:00 - 오후 03:00', 'image': '../assets/images/noImg.jpg'},
    ],
    [
      {'title': '해동 용궁사', 'time': '오전 08:00 - 오전 10:00', 'image': '../assets/images/noImg.jpg'},
      {'title': '태종대', 'time': '오전 11:00 - 오후 01:00', 'image': '../assets/images/noImg.jpg'},
    ],
  ];

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
                        child: GetMap(
                          apiKey: mapApiKey,
                          origin: '37.819929,-122.478255',
                          destination: '37.787994,-122.407437',
                          waypoints: '37.76999,-122.44696|37.76899,-122.44596',
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

