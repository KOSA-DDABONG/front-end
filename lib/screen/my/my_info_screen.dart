import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../controller/menu_app_controller.dart';


class MyInfoScreen extends StatefulWidget {
  const MyInfoScreen({Key? key}) : super(key: key);

  @override
  _MyInfoScreenState createState() => _MyInfoScreenState();
}

class _MyInfoScreenState extends State<MyInfoScreen> {

  @override
  void initState() {
    super.initState();
    //
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MenuAppController>().setSelectedScreen('myInfo');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Login', style: TextStyle(color: Colors.white),),
      //   backgroundColor: secondaryColor,
      // ),
      backgroundColor: bgColor,
      body: _myInfoUIMobile(context),
    );
  }

  Widget _myInfoUIMobile(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: _MyInfoUI(context),
    );
  }

  Widget _myInfoUITablet(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 60),
      child: _MyInfoUI(context),
    );
  }

  Widget _myInfoUIDesktop(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 80),
        width: MediaQuery.of(context).size.width / 2,
        child: _MyInfoUI(context),
      ),
    );
  }

  Widget _MyInfoUI(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          const SizedBox(height: 100),
          Text('my information', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Row(
            children: [
              // 기본 이미지
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('../assets/images/noImg.jpg'), // 기본 이미지 경로
              ),
              const SizedBox(width: 20),

              // 닉네임 텍스트
              Text('{nickname}', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(width: 20),

              // 회원정보 수정 버튼
              ElevatedButton(
                onPressed: () {
                  context.read<MenuAppController>().setSelectedScreen('myEdit');
                },
                child: Text('회원정보 수정'),
              ),
            ],
          ),

          const SizedBox(height: 40),

          // 다가오는 일정 카드
          _myScheduleCard(),
          // Container(
          //   decoration: BoxDecoration(
          //     border: Border.all(color: Colors.black, width: 1.0),
          //     borderRadius: BorderRadius.circular(10),
          //     color: Colors.transparent,
          //   ),
          //   child: ListTile(
          //     title: Text('다가오는 일정'),
          //     subtitle: Row(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         const SizedBox(width: 10),
          //         Container(
          //           width: 50,
          //           height: 50,
          //           decoration: BoxDecoration(
          //             borderRadius: BorderRadius.circular(10),
          //             image: DecorationImage(
          //               image: AssetImage('../assets/images/noImg.jpg'),
          //               fit: BoxFit.cover,
          //             ),
          //           ),
          //         ),
          //         const SizedBox(width: 10),
          //         Column(
          //           children: [
          //             Text('{일정 이름}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          //             Row(
          //               children: [
          //                 Text('{일정 날짜: YYYY-MM-DD}', style: TextStyle(fontSize: 14)),
          //                 const SizedBox(width: 10),
          //                 Text('{D-5}', style: TextStyle(fontSize: 14, color: Colors.red)),
          //               ],
          //             ),
          //           ],
          //         ),
          //       ],
          //     ),
          //     trailing: GestureDetector(
          //       onTap: () {
          //         context.read<MenuAppController>().setSelectedScreen('mySchedule');
          //       },
          //       child: Icon(Icons.arrow_forward),
          //     ),
          //   ),
          // ),

          const SizedBox(height: 20),

          // 작성한 후기 카드
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 1.0),
              borderRadius: BorderRadius.circular(10),
              color: Colors.transparent,
            ),
            child: ListTile(
              title: Text('작성한 후기'),
              trailing: GestureDetector(
                onTap: () {
                  context.read<MenuAppController>().setSelectedScreen('myReview');
                },
                child: Icon(Icons.arrow_forward),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // 좋아하는 후기 카드
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 1.0),
              borderRadius: BorderRadius.circular(10),
              color: Colors.transparent,
            ),
            child: ListTile(
              title: Text('좋아하는 후기'),
              trailing: GestureDetector(
                onTap: () {
                  context.read<MenuAppController>().setSelectedScreen('myLikes');
                },
                child: Icon(Icons.arrow_forward),
              ),
            ),
          ),

          const SizedBox(height: 100),
          // _buildInfoField(),
        ],
      ),
    );
  }

  Widget _myScheduleCard() {
    return // 다가오는 일정 카드
      Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1.0),
          borderRadius: BorderRadius.circular(10),
          color: Colors.transparent,
        ),
        child: ListTile(
          title: Text('다가오는 일정'),
          subtitle: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(width: 10),
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
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
                ],
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  context.read<MenuAppController>().setSelectedScreen('mySchedule');
                },
                child: Text(
                  '3건',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.blue, // 링크 스타일로 보이게 하기 위해서 색상 추가
                  ),
                ),
              ),
              const SizedBox(width: 10),  // 텍스트와 아이콘 사이 간격
              GestureDetector(
                onTap: () {
                  context.read<MenuAppController>().setSelectedScreen('mySchedule');
                },
                child: Icon(Icons.arrow_forward),
              ),
            ],
          ),
        ),
      );
  }

}