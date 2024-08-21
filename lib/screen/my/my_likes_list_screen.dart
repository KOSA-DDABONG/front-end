import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../component/dialog/detail_review_dialog.dart';
import '../../component/mypage/my_title.dart';
import '../../controller/my_menu_controller.dart';
import '../../dto/board/board_detail_get_response_model.dart';
import '../../dto/board/board_model.dart';
import '../../key/key.dart';
import '../../service/result.dart';

class MyLikesListScreen extends StatefulWidget {
  const MyLikesListScreen({Key? key}) : super(key: key);

  @override
  _MyLikesListScreenState createState() => _MyLikesListScreenState();
}

class _MyLikesListScreenState extends State<MyLikesListScreen> {
  // 상태를 저장하기 위한 변수
  final Set<int> _likedItems = Set<int>();
  late Board review;
  // late Result<BoardDetailResponseModel> result;
  late Result<BoardDetailGetResponseModel> result;

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
          const SizedBox(height: 30),
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = (constraints.maxWidth / 180).floor();
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 30.0,
                ),
                itemCount: 15,
                itemBuilder: (context, index) {
                  return _buildImageCard(context, index);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  //좋아요 누른 후기 이미지 카드
  Widget _buildImageCard(BuildContext context, int index) {
    final isLiked = _likedItems.contains(index);

    return GestureDetector(
      onTap: () {
        showDetailReviewDialog(context, 'assets/images/landing_background.jpg', GOOGLE_MAP_KEY, review, result);
      },
      child: Stack(
        children: [
          AspectRatio(
            aspectRatio: 4 / 3, // 가로 4, 세로 3 비율
            child: _cardImgUI(),
          ),
          Positioned(
            top: 1,
            right: 1,
            child: IconButton(
              icon: Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
                color: isLiked ? Colors.red : Colors.black,
              ),
              onPressed: () {
                setState(() {
                  if (isLiked) {
                    _likedItems.remove(index);
                  } else {
                    _likedItems.add(index);
                  }
                });
              },
            ),
          ),
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
}
