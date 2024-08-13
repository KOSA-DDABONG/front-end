import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../component/dialog/delete_my_review_dialog.dart';
import '../../component/dialog/detail_review_dialog.dart';
import '../../component/dialog/edit_review_dialog.dart';
import '../../component/mypage/my_title.dart';
import '../../controller/my_menu_controller.dart';
import '../../key/key.dart';
import '../../responsive.dart';

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
        child: _myReviewPageUI(context),
      ),
    );
  }

  //나의 후기 페이지 UI
  Widget _myReviewPageUI(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          showTitle('나의 후기'),
          const SizedBox(height: 20),
          _myReviewCard(context),
        ],
      ),
    );
  }

  //내가 작성한 후기 카드
  Widget _myReviewCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDetailReviewDialog(context, 'assets/images/landing_background.jpg', GOOGLE_MAP_KEY);
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1.0),
          borderRadius: BorderRadius.circular(10),
          color: Colors.transparent,
        ),
        child: Stack(
          children: [
            _cardContent(),
            Responsive.isNarrowWidth(context)
                ? _cardIconNarrowBtn(const Icon(Icons.edit_outlined), const Icon(Icons.delete_outline))
                : _cardIconWideBtn(const Icon(Icons.edit_outlined), const Icon(Icons.delete_outline))
          ],
        ),
      ),
    );
  }

  //카드 내용
  Widget _cardContent() {
    return ListTile(
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
                image: AssetImage('assets/images/landing_background.jpg'),
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
    );
  }

  //카드 내 아이콘 버튼(좁은 화면)
  Widget _cardIconNarrowBtn(Icon icon1, Icon icon2) {
    return Positioned(
      right: 1,
      bottom: 1,
      child: Row(
        children: [
          IconButton(
            icon: icon1,
            iconSize: 16,
            onPressed: () {
              showEditReviewDialog(context);
            },
          ),
          IconButton(
            icon: icon2,
            iconSize: 16,
            onPressed: () {
              showDeleteMyReviewDialog(context);
            },
          ),
        ],
      ),
    );
  }

  //카드 내 아이콘 버튼(넓은 화면)
  Widget _cardIconWideBtn(Icon icon1, Icon icon2) {
    return Positioned(
      right: 8,
      top: 8,
      child: Row(
        children: [
          IconButton(
            icon: icon1,
            iconSize: 22,
            onPressed: () {
              showEditReviewDialog(context);
            },
          ),
          IconButton(
            icon: icon2,
            iconSize: 22,
            onPressed: () {
              showDeleteMyReviewDialog(context);
            },
          ),
        ],
      ),
    );
  }
}
