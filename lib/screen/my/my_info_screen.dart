import 'package:flutter/material.dart';
import 'package:front/constants.dart';
import 'package:front/responsive.dart';
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
        child: Responsive.isNarrowWidth(context)
          ? _profileNarrowUI(context) : _profileWideUI(context)
      ),
    );
  }

  //프로필 정보 페이지 UI(좁은 화면)
  Widget _profileNarrowUI(BuildContext context) {
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
                            color: pointColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                        )
                    ),
                    const SizedBox(width: 10),
                    _editBtnUI(),
                  ],
                ),
                const SizedBox(height: 40),
                _myScheduleField(),
                const SizedBox(height: 30),
                _myReviewField(),
                const SizedBox(height: 30),
                _myLikesField(),
                const SizedBox(height: 100),
              ],
            ),
          )
        ],
      ),
    );
  }

  //프로필 정보 페이지 UI(넓은 화면)
  Widget _profileWideUI(BuildContext context) {
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
                            color: pointColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                        )
                    ),
                    const Text(
                        ' 님 환영합니다!',
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                            fontWeight: FontWeight.bold
                        )
                    ),
                    const SizedBox(width: 10),
                    _editBtnUI(),
                  ],
                ),
                const SizedBox(height: 40),
                _myScheduleField(),
                const SizedBox(height: 30),
                _myReviewField(),
                const SizedBox(height: 30),
                _myLikesField(),
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

  //가까운 일정 필드
  Widget _myScheduleField() {
    return Column(
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '가까운 일정',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
        const SizedBox(height: 10,),
        _myScheduleCard()
      ],
    );
  }

  //일정 카드
  Widget _myScheduleCard() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1.0),
        borderRadius: BorderRadius.circular(10),
        color: Colors.transparent,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        subtitle: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(width: 10),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: const DecorationImage(
                  image: AssetImage('assets/images/noImg.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Responsive.isNarrowWidth(context)
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('{일정 이름}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    Text('{YYYY-MM-DD}', style: TextStyle(fontSize: 14)),
                    const SizedBox(height: 5),
                    Text('{0박 0일}', style: TextStyle(fontSize: 14)),
                    const SizedBox(height: 5),
                    Text('{D-5}', style: TextStyle(fontSize: 14, color: Colors.red)),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('{일정 이름}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text('{일정 시작일: YYYY-MM-DD}', style: TextStyle(fontSize: 14)),
                        const SizedBox(width: 10),
                        Text('{0박 0일}', style: TextStyle(fontSize: 14)),
                        const SizedBox(height: 10),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text('{D-5}', style: TextStyle(fontSize: 14, color: Colors.red)),
                  ],
                ),
          ],
        ),
        trailing: Responsive.isNarrowWidth(context)
          ? GestureDetector(
              onTap: () {
                context.read<MyMenuController>().setSelectedScreen('mySchedule');
              },
              child: const Icon(Icons.arrow_forward),
            )
          : Row(
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

  //작성 후기 필드
  Widget _myReviewField() {
    return Column(
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '최근 작성한 후기',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
        const SizedBox(height: 10,),
        _myReviewCard()
      ],
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
        subtitle: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/noImg.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Responsive.isNarrowWidth(context)
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('{일정 이름}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 5),
                        Text('{YYYY-MM-DD}', style: TextStyle(fontSize: 14)),
                        const SizedBox(height: 5),
                        Text('{0박 0일}', style: TextStyle(fontSize: 14)),
                        const SizedBox(height: 5),
                        Text('{D-5}', style: TextStyle(fontSize: 14, color: Colors.red)),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('{일정 이름}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Text('{일정 시작일: YYYY-MM-DD}', style: TextStyle(fontSize: 14)),
                            const SizedBox(width: 10),
                            Text('{0박 0일}', style: TextStyle(fontSize: 14)),
                            const SizedBox(height: 10),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text('{D-5}', style: TextStyle(fontSize: 14, color: Colors.red)),
                      ],
                    ),
            ],
          ),
        ),
        trailing: Responsive.isNarrowWidth(context)
          ? GestureDetector(
              onTap: () {
                context.read<MyMenuController>().setSelectedScreen('myReview');
              },
              child: const Icon(Icons.arrow_forward),
            )
          : Row(
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
                const SizedBox(width: 10),
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

  //좋아요 필
  Widget _myLikesField() {
    return Column(
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '나의 좋아요',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
        const SizedBox(height: 10,),
        _myLikesCard()
      ],
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
        subtitle: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: LayoutBuilder(
              builder: (context, constraints) {
                double containerWidth = 100;
                double spacing = 15;

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(8, (index) {
                    return Container(
                      margin: EdgeInsets.only(right: spacing),
                      width: containerWidth,
                      height: containerWidth,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/noImg.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
          ),
        ),
        trailing: Responsive.isNarrowWidth(context)
          ? GestureDetector(
              onTap: () {
                context.read<MyMenuController>().setSelectedScreen('myLikes');
              },
              child: const Icon(Icons.arrow_forward),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    context.read<MyMenuController>().setSelectedScreen('myLikes');
                  },
                  child: Text(
                    '8건',
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