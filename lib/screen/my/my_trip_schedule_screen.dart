import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controller/my_menu_controller.dart';

// 마무리 할일
// 리스트타일 클릭하면 모달창 띄우기 (일정)
// 리스트 타일 현재날짜 기준으로 지났으면 두번째 탭, 안지났으면 첫번째 탭

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
                        _upcomingScheduleTab(context),
                        _pastScheduleTab(context),
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

  Widget _upcomingScheduleTab(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 각 일정 카드들을 리스트로 반복하여 보여줍니다.
          _upcomingScheduleCard(context),
          SizedBox(height: 20), // 카드 간격
        ],
      ),
    );
  }

  Widget _pastScheduleTab(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 각 일정 카드들을 리스트로 반복하여 보여줍니다.
          _pastScheduleCard(context),
          SizedBox(height: 20), // 카드 간격
        ],
      ),
    );
  }

  Widget _upcomingScheduleCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1.0),
        borderRadius: BorderRadius.circular(10),
        color: Colors.transparent,
      ),
      child: Stack(
        children: [
          ListTile(
            contentPadding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('다가오는 일정'),
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
            onTap: () {
              _showImageDialog(context);
            },
          ),
          Positioned(
            right: 10,
            top: 10,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.chat_bubble_outline),
                  onPressed: () {
                    // 채팅 아이콘 클릭 시 동작
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete_outline),
                  onPressed: () {
                    // 삭제 아이콘 클릭 시 동작
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _pastScheduleCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1.0),
        borderRadius: BorderRadius.circular(10),
        color: Colors.transparent,
      ),
      child: Stack(
        children: [
          ListTile(
            contentPadding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('지나간 일정'),
                SizedBox(height: 20), // 지나간 일정 텍스트 아래 여백 추가
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
            onTap: () {
              _showImageDialog(context);
            },
          ),
          Positioned(
            right: 10,
            top: 10,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // 연필 아이콘 클릭 시 동작
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete_outline),
                  onPressed: () {
                    // 삭제 아이콘 클릭 시 동작
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showImageDialog(BuildContext context) {
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
