import 'package:flutter/material.dart';

void showTripDetailDialog(BuildContext context) {
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
              borderRadius: BorderRadius.circular(10.0), // Ensure corner radius is set to 10
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white, // Set background color to white
                borderRadius: BorderRadius.circular(10.0), // Ensure corner radius is set to 10
              ),
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.8,
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            '생성된 여행 일정',
                            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.all(20.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.blueAccent),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Stack(
                              children: [
                                ...itinerary[selectedDay - 1].asMap().entries.map((entry) {
                                  int idx = entry.key;
                                  var place = entry.value;
                                  return Positioned(
                                    top: 50.0 + (idx * 30),
                                    left: 50.0 + (idx * 30),
                                    child: Icon(Icons.location_on, color: Colors.red, size: 40),
                                  );
                                }).toList(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(3, (index) {
                              return Expanded(
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(5, 40, 5, 20),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        selectedDay = index + 1;
                                        selectedIndex = null;
                                      });
                                    },
                                    child: Text(
                                      '${index + 1}일차',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: selectedDay == index + 1 ? Color(0xFF005AA7) : Colors.grey,
                                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                                              style: TextStyle(color: Colors.white, fontSize: 12),
                                            ),
                                          ),
                                          SizedBox(width: 8),
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
                                                    borderRadius: BorderRadius.circular(10),
                                                    child: Image.asset(place['image']!,
                                                        width: 60, height: 60, fit: BoxFit.cover),
                                                  ),
                                                  title: Text(
                                                    place['title']!,
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.bold, fontSize: 16),
                                                  ),
                                                  subtitle: Text(place['time']!,
                                                      style: TextStyle(fontSize: 14)),
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

