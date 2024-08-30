// import 'package:flutter/material.dart';
//
// import '../../component/header/header.dart';
// import '../../component/header/header_drawer.dart';
// import '../../controller/login_state_for_header.dart';
// import '../../responsive.dart';
//
// class ChatbotScreen extends StatefulWidget {
//   const ChatbotScreen({Key? key}) : super(key: key);
//
//   @override
//   _ChatbotScreenState createState() => _ChatbotScreenState();
// }
//
// class _ChatbotScreenState extends State<ChatbotScreen> {
//
//   int selectedDay = 1;
//   int? selectedIndex;
//
//   List<List<Map<String, String>>> itinerary = [
//     [
//       {'title': '부산역', 'image': 'assets/images/travel_schedule_default.jpg'},
//       {'title': '부산 돼지 국밥', 'image': 'assets/images/travel_schedule_default.jpg'},
//       {'title': '감천 문화 마을', 'image': 'assets/images/travel_schedule_default.jpg'},
//       {'title': '부산역', 'image': 'assets/images/travel_schedule_default.jpg'},
//       {'title': '부산 돼지 국밥', 'image': 'assets/images/travel_schedule_default.jpg'},
//       {'title': '감천 문화 마을', 'image': 'assets/images/travel_schedule_default.jpg'},
//     ],
//     [
//       {'title': '해운대 해수욕장', 'image': 'assets/images/travel_schedule_default.jpg'},
//       {'title': '광안리 해수욕장', 'image': 'assets/images/travel_schedule_default.jpg'},
//     ],
//     [
//       {'title': '해동 용궁사', 'image': 'assets/images/travel_schedule_default.jpg'},
//       {'title': '태종대', 'image': 'assets/images/travel_schedule_default.jpg'},
//     ],
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return CheckLoginStateWidget(
//       builder: (context, isLoggedIn) {
//         PreferredSizeWidget currentAppBar;
//         Widget? currentDrawer;
//         if (isLoggedIn) {
//           currentAppBar = Responsive.isNarrowWidth(context)
//             ? ShortHeader(automaticallyImplyLeading: false)
//             : AfterLoginHeader(automaticallyImplyLeading: false, context: context);
//           currentDrawer = Responsive.isNarrowWidth(context)
//             ? AfterLoginHeaderDrawer()
//             : null;
//         }
//         else {
//           currentAppBar = Responsive.isNarrowWidth(context)
//             ? ShortHeader(automaticallyImplyLeading: false)
//             : NotLoginHeader(automaticallyImplyLeading: false, context: context);
//           currentDrawer = Responsive.isNarrowWidth(context)
//             ? NotLoginHeaderDrawer()
//             : null;
//         }
//
//         return Scaffold(
//           appBar: currentAppBar,
//           drawer: currentDrawer,
//           body: Row(
//             children: [
//               // Itinerary Section
//               Expanded(
//                 flex: 2,
//                 child: Padding(
//                   padding: EdgeInsets.all(20),
//                   child: Column(
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: List.generate(3, (index) {
//                           return Expanded(
//                               child: Padding(
//                                 padding: EdgeInsets.fromLTRB(5, 40, 5, 20),
//                                 child: ElevatedButton(
//                                   onPressed: () {
//                                     setState(() {
//                                       selectedDay = index + 1;
//                                       selectedIndex = null;
//                                     });
//                                   },
//                                   child: Text(
//                                     '${index + 1}일차',
//                                     style: TextStyle(color: Colors.white),
//                                   ),
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: selectedDay == index + 1
//                                         ? Color(0xFF005AA7)
//                                         : Colors.grey,
//                                     padding: EdgeInsets.symmetric(
//                                         horizontal: 16, vertical: 8),
//                                     textStyle: TextStyle(fontSize: 16,
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                 ),
//                               )
//                           );
//                         }),
//                       ),
//                       Expanded(
//                         child: ListView.builder(
//                           itemCount: itinerary[selectedDay - 1].length,
//                           itemBuilder: (context, index) {
//                             var place = itinerary[selectedDay - 1][index];
//                             return Stack(
//                               children: [
//                                 Positioned.fill(
//                                   left: 12,
//                                   child: Align(
//                                     alignment: Alignment.topLeft,
//                                     child: DashedLine(
//                                       height: double.infinity,
//                                       color: Colors.grey,
//                                       strokeWidth: 2,
//                                     ),
//                                   ),
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                       vertical: 10.0),
//                                   child: Row(
//                                     children: [
//                                       // Display the number outside the tile
//                                       CircleAvatar(
//                                         backgroundColor: Colors.blue,
//                                         radius: 12,
//                                         child: Text(
//                                           '${index + 1}',
//                                           style: TextStyle(
//                                               color: Colors.white,
//                                               fontSize: 12),
//                                         ),
//                                       ),
//                                       SizedBox(width: 8),
//                                       // Wrap the ListTile with a Card
//                                       Expanded(
//                                         child: GestureDetector(
//                                           onTap: () {
//                                             setState(() {
//                                               selectedIndex = index;
//                                             });
//                                             // Add your onTap functionality here
//                                           },
//                                           child: Card(
//                                             color: selectedIndex == index
//                                                 ? Colors
//                                                 .lightBlueAccent
//                                                 : Colors.white,
//                                             child: ListTile(
//                                               leading: Image.asset(
//                                                   place['image']!,
//                                                   width: 60,
//                                                   height: 60,
//                                                   fit: BoxFit.cover),
//                                               title: Text(
//                                                 place['title']!,
//                                                 style: TextStyle(
//                                                     fontWeight: FontWeight
//                                                         .bold,
//                                                     fontSize: 16),
//                                               ),
//                                               subtitle: Container(height: 5,)
//                                               // Text(place['time']!,
//                                               //     style: TextStyle(
//                                               //         fontSize: 14)),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             );
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Expanded(
//                   flex: 3,
//                   child: Padding(
//                     padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
//                     child: Column(
//                       children: [
//                         Expanded(
//                           child: ListView(
//                             children: [
//                               ListTile(
//                                 title: Align(
//                                   alignment: Alignment.centerRight,
//                                   child: Container(
//                                     padding: EdgeInsets.all(10),
//                                     decoration: BoxDecoration(
//                                       color: Colors.blue[100],
//                                       borderRadius: BorderRadius.circular(10),
//                                     ),
//                                     child: Text('부산 여행으로 2박 3일 추천해줘'),
//                                   ),
//                                 ),
//                               ),
//                               ListTile(
//                                 title: Align(
//                                   alignment: Alignment.centerLeft,
//                                   child: Container(
//                                     padding: EdgeInsets.all(10),
//                                     decoration: BoxDecoration(
//                                       color: Colors.grey[200],
//                                       borderRadius: BorderRadius.circular(10),
//                                     ),
//                                     child: Text('어떤 여행지를 추천해 드릴까요?'),
//                                   ),
//                                 ),
//                               ),
//                               ListTile(
//                                 title: Align(
//                                   alignment: Alignment.centerRight,
//                                   child: Container(
//                                     padding: EdgeInsets.all(10),
//                                     decoration: BoxDecoration(
//                                       color: Colors.blue[100],
//                                       borderRadius: BorderRadius.circular(10),
//                                     ),
//                                     child: Text('액티비티 위주였으면 좋겠어'),
//                                   ),
//                                 ),
//                               ),
//                               ListTile(
//                                 title: Align(
//                                   alignment: Alignment.centerLeft,
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment
//                                         .start,
//                                     children: [
//                                       Container(
//                                         padding: EdgeInsets.all(10),
//                                         decoration: BoxDecoration(
//                                           color: Colors.grey[200],
//                                           borderRadius: BorderRadius.circular(
//                                               10),
//                                         ),
//                                         child: Text('추천 결과입니다.'),
//                                       ),
//                                       SizedBox(height: 5),
//                                       Image.network(
//                                           'assets/images/noImg.jpg'),
//                                       TextButton(
//                                         onPressed: () {},
//                                         child: Text('더보기'),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Row(
//                             children: [
//                               Expanded(
//                                 child: TextField(
//                                   decoration: InputDecoration(
//                                     hintText: '메세지를 입력하세요.',
//                                     border: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(10),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               IconButton(
//                                 icon: Icon(Icons.send),
//                                 onPressed: () {},
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   )
//               ),
//             ],
//           ),
//         );
//       }
//     );
//   }
// }
//
// class DashedLine extends StatelessWidget {
//   final double height;
//   final Color color;
//   final double strokeWidth;
//
//   DashedLine({
//     required this.height,
//     required this.color,
//     this.strokeWidth = 1.0,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: height,
//       width: 2,
//       child: CustomPaint(
//         painter: DashedLinePainter(color: color, strokeWidth: strokeWidth),
//       ),
//     );
//   }
// }
//
// class DashedLinePainter extends CustomPainter {
//   final Color color;
//   final double strokeWidth;
//
//   DashedLinePainter({required this.color, this.strokeWidth = 2.0});
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     var paint = Paint()
//       ..color = color
//       ..strokeWidth = strokeWidth
//       ..style = PaintingStyle.stroke;
//
//     double dashWidth = 8,
//         dashSpace = 3,
//         startY = 0;
//     while (startY < size.height) {
//       canvas.drawLine(Offset(0, startY), Offset(0, startY + dashWidth), paint);
//       startY += dashWidth + dashSpace;
//     }
//   }
//
//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return false;
//   }
// }



//3
import 'dart:async'; // Import to use Timer
import 'package:flutter/material.dart';

import '../../component/header/header.dart';
import '../../component/header/header_drawer.dart';
import '../../controller/login_state_for_header.dart';
import '../../responsive.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({Key? key}) : super(key: key);

  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  int selectedDay = 1;
  int? selectedIndex;
  String? userMessage;
  List<Map<String, String>> chatMessages = [];
  bool isWaiting = false;

  List<List<Map<String, String>>> itinerary = [
    [
      {'title': '고센야 반송점', 'image': 'assets/images/travel_schedule_default.jpg'},
      {'title': '수영강상설카약체험장', 'image': 'assets/images/travel_schedule_default.jpg'},
      {'title': '광안리 해양레포츠센터', 'image': 'assets/images/travel_schedule_default.jpg'},
      {'title': '디레스토랑 부산송정점', 'image': 'assets/images/travel_schedule_default.jpg'},
      {'title': '88간바지', 'image': 'assets/images/travel_schedule_default.jpg'},
      {'title': '다니엘게스트하우스', 'image': 'assets/images/travel_schedule_default.jpg'},
    ],
    [
      {'title': '대도회초밥', 'image': 'assets/images/travel_schedule_default.jpg'},
      {'title': '사라수변공원', 'image': 'assets/images/travel_schedule_default.jpg'},
      {'title': '일광해수욕장', 'image': 'assets/images/travel_schedule_default.jpg'},
      {'title': '동백방파제', 'image': 'assets/images/travel_schedule_default.jpg'},
      {'title': '참가자미 마린시티점', 'image': 'assets/images/travel_schedule_default.jpg'},
      {'title': '감전인생술집', 'image': 'assets/images/travel_schedule_default.jpg'},
      {'title': '태림하우스', 'image': 'assets/images/travel_schedule_default.jpg'},
    ],
    [
      {'title': '두툼 연어', 'image': 'assets/images/travel_schedule_default.jpg'},
      {'title': '천마산전망대', 'image': 'assets/images/travel_schedule_default.jpg'},
      {'title': '빙산저수지', 'image': 'assets/images/travel_schedule_default.jpg'},
      {'title': '고베규카츠', 'image': 'assets/images/travel_schedule_default.jpg'},
      {'title': '파머스버거', 'image': 'assets/images/travel_schedule_default.jpg'},
      {'title': '단디게스트하우스', 'image': 'assets/images/travel_schedule_default.jpg'},
    ],
    [
      {'title': '가족식당', 'image': 'assets/images/travel_schedule_default.jpg'},
      {'title': '낙조분수', 'image': 'assets/images/travel_schedule_default.jpg'},
      {'title': '몰운대 트레킹', 'image': 'assets/images/travel_schedule_default.jpg'},
      {'title': '다대장어숯불구이', 'image': 'assets/images/travel_schedule_default.jpg'},
      {'title': '류가네더덕삼겹살', 'image': 'assets/images/travel_schedule_default.jpg'},
    ],
  ];

  @override
  void initState() {
    super.initState();
  }

  void sendMessage() {
    if (selectedIndex == null || userMessage == null || userMessage!.isEmpty) return;

    setState(() {
      chatMessages.add({'message': userMessage!, 'alignment': 'right'});
      userMessage = null;
    });
    setState(() {
      chatMessages.add({'message': '잠시만 기다려주세요!\n변경될 장소를 추출 중입니다.', 'alignment': 'left'});
      isWaiting = true;
    });

    Timer(Duration(seconds: 5), () {
      setState(() {
        itinerary[selectedDay - 1][selectedIndex!]['title'] = '해운대 해수욕장';
        chatMessages.add({'message': '해당 내용이 \'해운대 해수욕장\'로 추천되었습니다!!\n해당 내용으로 변경합니다!', 'alignment': 'left'});
        isWaiting = false;
      });
    });
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
                          children: List.generate(4, (index) {
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
                                    textStyle: TextStyle(
                                        fontSize: 16, fontWeight: FontWeight.bold),
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
                                            },
                                            child: Card(
                                              color: selectedIndex == index
                                                  ? Colors.lightBlueAccent
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
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 16),
                                                ),
                                                subtitle: Container(height: 5),
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
                          child: ListView.builder(
                            itemCount: chatMessages.length,
                            itemBuilder: (context, index) {
                              var chat = chatMessages[index];
                              return Align(
                                alignment: chat['alignment'] == 'right'
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: chat['alignment'] == 'right'
                                        ? Colors.blue[100]
                                        : Colors.grey[200],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    chat['message']!,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  onChanged: (text) {
                                    setState(() {
                                      userMessage = text;
                                    });
                                  },
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
                                onPressed: () {
                                  if (userMessage != null && userMessage!.isNotEmpty) {
                                    sendMessage();
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
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