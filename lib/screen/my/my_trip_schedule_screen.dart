import 'package:flutter/material.dart';
import 'package:front/constants.dart';
import 'package:front/screen/chat/chatbot_screen.dart';
import 'package:front/screen/review/add_review_screen.dart';
import 'package:provider/provider.dart';

import '../../component/dialog/delete_trip_schedule_dialog.dart';
import '../../component/dialog/detail_trip_dialog.dart';
import '../../component/mypage/my_title.dart';
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
    return _myTripListPageUI();
  }

  //저장된 여행 일정 페이지 UI
  Widget _myTripListPageUI() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(41, 41, 41, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          showTitle('나의 일정'),
          const SizedBox(height: 20),
          _tapControllerUI(),
        ],
      ),
    );
  }

  //여행 탭 선택
  Widget _tapControllerUI() {
    return DefaultTabController(
      length: 3,
      child: Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TabBar(
              labelColor: pointColor,
              unselectedLabelColor: Colors.grey,
              indicatorColor: pointColor,
              tabs: [
                Tab(text: '진행중인 일정'),
                Tab(text: '다가오는 일정'),
                Tab(text: '지나간 일정'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _presentScheduleTab(context),
                  _upcomingScheduleTab(context),
                  _pastScheduleTab(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //진행중인 일정 탭 구성
  Widget _presentScheduleTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _presentScheduleCard(context),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  //다가오는 일정 탭 구성
  Widget _upcomingScheduleTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _upcomingScheduleCard(context),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  //지나간 일정 탭 구성
  Widget _pastScheduleTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _pastScheduleCard(context),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  //진행 중인 일정 카드
  Widget _presentScheduleCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1.0),
        borderRadius: BorderRadius.circular(10),
        color: Colors.transparent,
      ),
      child: Stack(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
            title: _cardTitleTextUI('진행중인 일정'),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
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
              showDetailTripDialog(context);
            },
          ),
          _cardIconBtn(const Icon(Icons.chat_bubble_outline), const Icon(Icons.delete_outline)),
        ],
      ),
    );
  }

  //다가오는 일정 카드
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
            contentPadding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
            title: _cardTitleTextUI('다가오는 일정'),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
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
              showDetailTripDialog(context);
            },
          ),
          _cardIconBtn(const Icon(Icons.chat_bubble_outline), const Icon(Icons.delete_outline)),
        ],
      ),
    );
  }

  //지나간 일정 카드
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
            contentPadding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
            title: _cardTitleTextUI('지나간 일정'),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
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
              showDetailTripDialog(context);
            },
          ),
          _cardIconBtn(const Icon(Icons.note_add_outlined), const Icon(Icons.delete_outline)),
        ],
      ),
    );
  }

  //카드 타이틀 텍스트
  Widget _cardTitleTextUI(String titleText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(titleText),
        const SizedBox(height: 20),
      ],
    );
  }

  //카드 내 아이콘 버튼
  Widget _cardIconBtn(Icon icon1, Icon icon2) {
    return Positioned(
      right: 10,
      top: 10,
      child: Row(
        children: [
          IconButton(
            icon: icon1,
            onPressed: () {
              if (icon1.icon == Icons.chat_bubble_outline) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ChatbotScreen()
                  ),
                );
              }
              else if (icon1.icon == Icons.note_add_outlined) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddReviewScreen()
                  ),
                );
              }
            },
          ),
          IconButton(
            icon: icon2,
            onPressed: () {
              showDeleteTripScheduleDialog(context);
            },
          ),
        ],
      ),
    );
  }
}
