// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../../controller/my_menu_controller.dart';
//
// class MyTripScheduleScreen extends StatefulWidget {
//   const MyTripScheduleScreen({Key? key}) : super(key: key);
//
//   @override
//   _MyTripScheduleScreenState createState() => _MyTripScheduleScreenState();
// }
//
// class _MyTripScheduleScreenState extends State<MyTripScheduleScreen> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<MyMenuController>().setSelectedScreen('mySchedule');
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       // padding: EdgeInsets.all(41),
//       padding: EdgeInsets.fromLTRB(41, 41, 41, 10),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             '나의 일정',
//             style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
//           ),
//           DefaultTabController(
//             length: 2,
//             child: Expanded(
//               child: Scaffold(
//                 appBar: AppBar(
//                   backgroundColor: Colors.white,
//                   elevation: 0, // AppBar 밑에 경계선 제거
//                   bottom: TabBar(
//                     labelColor: Colors.black,
//                     unselectedLabelColor: Colors.grey,
//                     indicatorColor: Colors.black,
//                     tabs: [
//                       Tab(text: '다가오는 일정'),
//                       Tab(text: '지나간 일정'),
//                     ],
//                   ),
//                 ),
//                 body: TabBarView(
//                   children: [
//                     _myScheduleTab(context, '다가오는 일정'),
//                     _myScheduleTab(context, '지나간 일정'),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _myScheduleTab(BuildContext context, String scheduleType) {
//     return SingleChildScrollView(
//       padding: EdgeInsets.all(25),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // 각 일정 카드들을 리스트로 반복하여 보여줍니다.
//           _myScheduleCard(scheduleType),
//           SizedBox(height: 20), // 카드 간격
//           _myScheduleCard(scheduleType),
//         ],
//       ),
//     );
//   }
//
//   Widget _myScheduleCard(String scheduleType) {
//     return Container(
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.black, width: 1.0),
//         borderRadius: BorderRadius.circular(10),
//         color: Colors.transparent,
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: EdgeInsets.all(8.0),
//             child: Text(scheduleType, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//           ),
//           Divider(color: Colors.black),
//           ListTile(
//             leading: Container(
//               width: 80,
//               height: 80,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 image: DecorationImage(
//                   image: AssetImage('../assets/images/noImg.jpg'),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             title: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text('{일정 이름}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                 SizedBox(height: 5),
//                 Row(
//                   children: [
//                     Text('{일정 날짜: YYYY-MM-DD}', style: TextStyle(fontSize: 14)),
//                     SizedBox(width: 10),
//                     Text('{D-5}', style: TextStyle(fontSize: 14, color: Colors.red)),
//                   ],
//                 ),
//               ],
//             ),
//             trailing: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 GestureDetector(
//                   onTap: () {
//                     context.read<MyMenuController>().setSelectedScreen('mySchedule');
//                   },
//                   child: Text(
//                     '3건',
//                     style: TextStyle(
//                       fontSize: 15,
//                       decoration: TextDecoration.underline,
//                       color: Colors.black,
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 10),
//                 GestureDetector(
//                   onTap: () {
//                     context.read<MyMenuController>().setSelectedScreen('mySchedule');
//                   },
//                   child: Icon(Icons.arrow_forward),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controller/my_menu_controller.dart';

class MyTripScheduleScreen extends StatefulWidget {
  const MyTripScheduleScreen({Key? key}) : super(key: key);

  @override
  _MyTripScheduleScreenState createState() => _MyTripScheduleScreenState();
}

class _MyTripScheduleScreenState extends State<MyTripScheduleScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MyMenuController>().setSelectedScreen('mySchedule');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(41, 41, 41, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '나의 일정',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          DefaultTabController(
            length: 2,
            child: Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TabBar(
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Colors.black,
                    tabs: [
                      Tab(text: '다가오는 일정'),
                      Tab(text: '지나간 일정'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _myScheduleTab(context, '다가오는 일정'),
                        _myScheduleTab(context, '지나간 일정'),
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

  Widget _myScheduleTab(BuildContext context, String scheduleType) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 각 일정 카드들을 리스트로 반복하여 보여줍니다.
          _myScheduleCard(scheduleType),
          SizedBox(height: 20), // 카드 간격
          _myScheduleCard(scheduleType),
        ],
      ),
    );
  }

  Widget _myScheduleCard(String scheduleType) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1.0),
        borderRadius: BorderRadius.circular(10),
        color: Colors.transparent,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(scheduleType, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          Divider(color: Colors.black),
          ListTile(
            leading: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: AssetImage('../assets/images/noImg.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('{일정 이름}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                Row(
                  children: [
                    Text('{일정 날짜: YYYY-MM-DD}', style: TextStyle(fontSize: 14)),
                    SizedBox(width: 10),
                    Text('{D-5}', style: TextStyle(fontSize: 14, color: Colors.red)),
                  ],
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    context.read<MyMenuController>().setSelectedScreen('mySchedule');
                  },
                  child: Text(
                    '3건',
                    style: TextStyle(
                      fontSize: 15,
                      decoration: TextDecoration.underline,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    context.read<MyMenuController>().setSelectedScreen('mySchedule');
                  },
                  child: Icon(Icons.arrow_forward),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
