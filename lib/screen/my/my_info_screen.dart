import 'package:flutter/material.dart';
import 'package:front/constants.dart';
import 'package:provider/provider.dart';

import '../../component/mypage/my_title.dart';
import '../../controller/my_menu_controller.dart';

class MyInfoScreen extends StatefulWidget {
  const MyInfoScreen({Key? key}) : super(key: key);

  @override
  _MyInfoScreenState createState() => _MyInfoScreenState();
}

class _MyInfoScreenState extends State<MyInfoScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MyMenuController>().setSelectedScreen('myInfo');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _myInfoUI(context),
      ),
    );
  }

  //마이페이지 내 프로필 UI
  Widget _myInfoUI(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          showTitle('내 프로필'),
          const SizedBox(height: 20),
          Center(
            child: Column(
              children: <Widget>[
                Row(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[200],
                      child: const Icon(Icons.person, size: 50)
                    ),
                    const SizedBox(width: 20),
                    const Text(
                      '{nickname}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold
                      )
                    ),
                    const SizedBox(width: 10),
                    _editBtnUI(),
                  ],
                ),
                const SizedBox(height: 40),
                _myScheduleCard(),
                const SizedBox(height: 20),
                _myReviewCard(),
                const SizedBox(height: 20),
                _myLikesCard(),
                const SizedBox(height: 100),
              ],
            ),
          )
        ],
      ),
    );
  }

  //회원정보 수정 아이콘 버튼
  Widget _editBtnUI() {
    return IconButton(
      onPressed: () {
        context.read<MyMenuController>().setSelectedScreen('myEdit');
      },
      icon: const Icon(Icons.edit),
      color: pointColor,
      iconSize: 20.0,
      tooltip: '회원정보 수정',
    );
  }

  //다가오는 일정 카드
  Widget _myScheduleCard() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1.0),
        borderRadius: BorderRadius.circular(10),
        color: Colors.transparent,
      ),
      child: ListTile(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('다가오는 일정'),
            SizedBox(height: 20),
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
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () {
                context.read<MyMenuController>().setSelectedScreen('mySchedule');
              },
              child: const Icon(Icons.arrow_forward),
            ),
          ],
        ),
      ),
    );
  }

  //최근 작성 후기 카드
  Widget _myReviewCard() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1.0),
        borderRadius: BorderRadius.circular(10),
        color: Colors.transparent,
      ),
      child: ListTile(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('최근 작성한 후기'),
            SizedBox(height: 20),
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
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                context.read<MyMenuController>().setSelectedScreen('myReview');
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
            const SizedBox(width: 10),  // 텍스트와 아이콘 사이 간격
            GestureDetector(
              onTap: () {
                context.read<MyMenuController>().setSelectedScreen('myReview');
              },
              child: const Icon(Icons.arrow_forward),
            ),
          ],
        ),
      ),
    );
  }

  //최근 좋아요 카드
  Widget _myLikesCard() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1.0),
        borderRadius: BorderRadius.circular(10),
        color: Colors.transparent,
      ),
      child: ListTile(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('최근 좋아요 누른 후기'),
            SizedBox(height: 20),
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
                borderRadius: BorderRadius.circular(100),
                image: const DecorationImage(
                  image: AssetImage('../assets/images/noImg.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                image: const DecorationImage(
                  image: AssetImage('../assets/images/noImg.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                image: const DecorationImage(
                  image: AssetImage('../assets/images/noImg.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                image: const DecorationImage(
                  image: AssetImage('../assets/images/noImg.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                context.read<MyMenuController>().setSelectedScreen('myLikes');
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
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () {
                context.read<MyMenuController>().setSelectedScreen('myLikes');
              },
              child: const Icon(Icons.arrow_forward),
            ),
          ],
        ),
      ),
    );
  }
}