import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:front/component/dialog/detail_review_dialog.dart';
import 'package:provider/provider.dart';

import '../../component/mypage/my_title.dart';
import '../../controller/my_menu_controller.dart';
import '../../key.dart';

class MyLikesListScreen extends StatefulWidget {
  const MyLikesListScreen({Key? key}) : super(key: key);

  @override
  _MyLikesListScreenState createState() => _MyLikesListScreenState();
}

class _MyLikesListScreenState extends State<MyLikesListScreen> {
  // String mapApiKey = dotenv.get("GOOGLE_MAP_KEY");

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MyMenuController>().setSelectedScreen('myLikes');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _myLikesUI(context),
      ),
    );
  }

  //나의 좋아요 리스트 페이지 UI
  Widget _myLikesUI(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          showTitle('나의 좋아요'),
          const SizedBox(height: 50),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              crossAxisSpacing: 30.0,
              mainAxisSpacing: 30.0,
            ),
            itemCount: 15,
            itemBuilder: (context, index) {
              return _buildImageCard(context);
            },
          ),
        ],
      ),
    );
  }

  //좋아요 누른 후기 이미지 카드
  Widget _buildImageCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDetailReviewDialog(context, 'assets/images/landing_background.jpg', GOOGLE_MAP_KEY);
      },
      child: Stack(
        children: [
          _cardImgUI(),
          _heartBtn()
        ],
      ),
    );
  }

  //대표이미지
  Widget _cardImgUI() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1.0),
        borderRadius: BorderRadius.circular(10),
        color: Colors.transparent,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(
          'assets/images/noImg.jpg',
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }

  //좋아요 버튼
  Widget _heartBtn() {
    return Positioned(
      top: 10,
      right: 10,
      child: IconButton(
        icon: const Icon(Icons.favorite_border, color: Colors.black),
        onPressed: () {},
      ),
    );
  }
}
