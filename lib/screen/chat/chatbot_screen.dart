import 'package:flutter/material.dart';

import '../../component/header/header.dart';
import '../../component/header/header_drawer.dart';
import '../../controller/login_state.dart';
import '../../responsive.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({Key? key}) : super(key: key);

  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {

  int selectedDay = 1;
  int? selectedIndex;

  List<List<Map<String, String>>> itinerary = [
    [
      {'title': '부산역', 'time': '오전 07:48 - 오전 10:03', 'image': 'assets/images/noImg.jpg'},
      {'title': '부산 돼지 국밥', 'time': '오전 10:10 - 오전 10:45', 'image': 'assets/images/noImg.jpg'},
      {'title': '감천 문화 마을', 'time': '오전 10:45 - 오전 12:00', 'image': 'assets/images/noImg.jpg'},
      {'title': '부산역', 'time': '오전 07:48 - 오전 10:03', 'image': 'assets/images/noImg.jpg'},
      {'title': '부산 돼지 국밥', 'time': '오전 10:10 - 오전 10:45', 'image': 'assets/images/noImg.jpg'},
      {'title': '감천 문화 마을', 'time': '오전 10:45 - 오전 12:00', 'image': 'assets/images/noImg.jpg'},
    ],
    [
      {'title': '해운대 해수욕장', 'time': '오전 09:00 - 오후 12:00', 'image': 'assets/images/noImg.jpg'},
      {'title': '광안리 해수욕장', 'time': '오후 01:00 - 오후 03:00', 'image': 'assets/images/noImg.jpg'},
    ],
    [
      {'title': '해동 용궁사', 'time': '오전 08:00 - 오전 10:00', 'image': 'assets/images/noImg.jpg'},
      {'title': '태종대', 'time': '오전 11:00 - 오후 01:00', 'image': 'assets/images/noImg.jpg'},
    ],
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CheckLoginStateWidget(
      builder: (context, isLoggedIn) {
        PreferredSizeWidget currentAppBar;
        Widget? currentDrawer;
        if (isLoggedIn) {
          currentAppBar = Responsive.isNarrowWidth(context)
            ? ShortHeader(automaticallyImplyLeading: false)
            : AfterLoginHeader(automaticallyImplyLeading: false, context: context);
          currentDrawer = Responsive.isNarrowWidth(context)
            ? AfterLoginHeaderDrawer()
            : null;
        }
        else {
          currentAppBar = Responsive.isNarrowWidth(context)
            ? ShortHeader(automaticallyImplyLeading: false)
            : NotLoginHeader(automaticallyImplyLeading: false, context: context);
          currentDrawer = Responsive.isNarrowWidth(context)
            ? NotLoginHeaderDrawer()
            : null;
        }

        return Scaffold(
          appBar: currentAppBar,
          drawer: currentDrawer,
          body: Row(
            children: [
              // Itinerary Section
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
                                    backgroundColor: selectedDay == index + 1
                                        ? Color(0xFF005AA7)
                                        : Colors.grey,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    textStyle: TextStyle(fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )
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
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: Row(
                                    children: [
                                      // Display the number outside the tile
                                      CircleAvatar(
                                        backgroundColor: Colors.blue,
                                        radius: 12,
                                        child: Text(
                                          '${index + 1}',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12),
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      // Wrap the ListTile with a Card
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              selectedIndex = index;
                                            });
                                            // Add your onTap functionality here
                                          },
                                          child: Card(
                                            color: selectedIndex == index
                                                ? Colors
                                                .lightBlueAccent
                                                : Colors.white,
                                            child: ListTile(
                                              leading: Image.asset(
                                                  place['image']!,
                                                  width: 60,
                                                  height: 60,
                                                  fit: BoxFit.cover),
                                              title: Text(
                                                place['title']!,
                                                style: TextStyle(
                                                    fontWeight: FontWeight
                                                        .bold,
                                                    fontSize: 16),
                                              ),
                                              subtitle: Text(place['time']!,
                                                  style: TextStyle(
                                                      fontSize: 14)),
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
              Expanded(
                  flex: 3,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView(
                            children: [
                              ListTile(
                                title: Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.blue[100],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text('부산 여행으로 2박 3일 추천해줘'),
                                  ),
                                ),
                              ),
                              ListTile(
                                title: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text('어떤 여행지를 추천해 드릴까요?'),
                                  ),
                                ),
                              ),
                              ListTile(
                                title: Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.blue[100],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text('액티비티 위주였으면 좋겠어'),
                                  ),
                                ),
                              ),
                              ListTile(
                                title: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius: BorderRadius.circular(
                                              10),
                                        ),
                                        child: Text('추천 결과입니다.'),
                                      ),
                                      SizedBox(height: 5),
                                      Image.network(
                                          'assets/images/noImg.jpg'),
                                      TextButton(
                                        onPressed: () {},
                                        child: Text('더보기'),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: '메세지를 입력하세요.',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.send),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
              ),
            ],
          ),
        );
      }
    );
  }
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