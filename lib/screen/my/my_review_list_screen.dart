// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../../controller/my_menu_controller.dart';
//
//
// class MyReviewListScreen extends StatefulWidget {
//   const MyReviewListScreen({Key? key}) : super(key: key);
//
//   @override
//   _MyReviewListScreenState createState() => _MyReviewListScreenState();
// }
//
// class _MyReviewListScreenState extends State<MyReviewListScreen> {
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<MyMenuController>().setSelectedScreen('myReview');
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: _myScheduleUI(context),
//       ),
//     );
//   }
//
//   Widget _myScheduleUI(BuildContext context) {
//     return SingleChildScrollView(
//       padding: EdgeInsets.all(25),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             '나의 후기',
//             style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
//           ),
//           SizedBox(height: 20),
//           // 작성한 후기 카드
//           _myReviewCard(),
//         ],
//       ),
//     );
//   }
//
//   Widget _myScheduleUIMobile(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 20),
//       child: _myScheduleUI(context),
//     );
//   }
//
//   Widget _myScheduleUITablet(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 60),
//       child: _myScheduleUI(context),
//     );
//   }
//
//   Widget _myScheduleUIDesktop(BuildContext context) {
//     return Center(
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 80),
//         width: MediaQuery.of(context).size.width / 2,
//         child: _myScheduleUI(context),
//       ),
//     );
//   }
//
//   //최근 작성 후기
//   Widget _myReviewCard() {
//     return Container(
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.black, width: 1.0),
//         borderRadius: BorderRadius.circular(10),
//         color: Colors.transparent,
//       ),
//       child: ListTile(
//         title: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('최근 작성한 후기'),
//             SizedBox(height: 20), // 다가오는 일정 텍스트 아래 여백 추가
//           ],
//         ),
//         subtitle: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(width: 10),
//             Container(
//               width: 80,
//               height: 80,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 image: const DecorationImage(
//                   image: AssetImage('../assets/images/noImg.jpg'),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             const SizedBox(width: 10),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,  // 왼쪽 정렬 추가
//               children: [
//                 Text('{일정 이름}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                 Row(
//                   children: [
//                     Text('{일정 날짜: YYYY-MM-DD}', style: TextStyle(fontSize: 14)),
//                     const SizedBox(width: 10),
//                     Text('{D-5}', style: TextStyle(fontSize: 14, color: Colors.red)),
//                   ],
//                 ),
//                 SizedBox(height: 50),
//               ],
//             ),
//           ],
//         ),
//         trailing: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             GestureDetector(
//               onTap: () {
//                 context.read<MyMenuController>().setSelectedScreen('myReview');
//               },
//               child: Text(
//                 '3건',
//                 style: TextStyle(
//                   fontSize: 15,
//                   decoration: TextDecoration.underline,
//                   color: Colors.black, // 링크 스타일로 보이게 하기 위해서 색상 추가
//                 ),
//               ),
//             ),
//             const SizedBox(width: 10),  // 텍스트와 아이콘 사이 간격
//             GestureDetector(
//               onTap: () {
//                 context.read<MyMenuController>().setSelectedScreen('myReview');
//               },
//               child: Icon(Icons.arrow_forward),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controller/my_menu_controller.dart';

class MyReviewListScreen extends StatefulWidget {
  const MyReviewListScreen({Key? key}) : super(key: key);

  @override
  _MyReviewListScreenState createState() => _MyReviewListScreenState();
}

class _MyReviewListScreenState extends State<MyReviewListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MyMenuController>().setSelectedScreen('myReview');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _myScheduleUI(context),
      ),
    );
  }

  Widget _myScheduleUI(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '나의 후기',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          // 작성한 후기 카드
          _myReviewCard(context),
        ],
      ),
    );
  }

  Widget _myScheduleUIMobile(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: _myScheduleUI(context),
    );
  }

  Widget _myScheduleUITablet(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 60),
      child: _myScheduleUI(context),
    );
  }

  Widget _myScheduleUIDesktop(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 80),
        width: MediaQuery.of(context).size.width / 2,
        child: _myScheduleUI(context),
      ),
    );
  }

  //최근 작성 후기
  Widget _myReviewCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showImageModal(context);
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1.0),
          borderRadius: BorderRadius.circular(10),
          color: Colors.transparent,
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('최근 작성한 후기'),
                    SizedBox(height: 20), // 다가오는 일정 텍스트 아래 여백 추가
                  ],
                ),
                subtitle: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(width: 10),
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: const DecorationImage(
                          image: AssetImage('../assets/images/noImg.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,  // 왼쪽 정렬 추가
                      children: [
                        Text('{일정 이름}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        Row(
                          children: [
                            Text('{일정 날짜: YYYY-MM-DD}', style: TextStyle(fontSize: 14)),
                            const SizedBox(width: 10),
                            Text('{D-5}', style: TextStyle(fontSize: 14, color: Colors.red)),
                          ],
                        ),
                        SizedBox(height: 50),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: 8,
              top: 8,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      // Edit action here
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      // Delete action here
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showImageModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Image.asset(
                          '../assets/images/noImg.jpg',
                          width: 300,
                          height: 300,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(height: 10),
                        Text(
                          '이미지가 없습니다',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
