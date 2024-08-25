import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../component/dialog/detail_review_dialog.dart';
import '../../component/dialog/request_login_dialog.dart';
import '../../component/mypage/my_title.dart';
import '../../component/snack_bar.dart';
import '../../controller/check_login_state.dart';
import '../../controller/my_menu_controller.dart';
import '../../dto/board/board_detail_get_response_model.dart';
import '../../dto/board/board_model.dart';
import '../../dto/board/board_mylikelist_response_model.dart';
import '../../key/key.dart';
import '../../service/board_service.dart';
import '../../service/result.dart';

class MyLikesListScreen extends StatefulWidget {
  const MyLikesListScreen({Key? key}) : super(key: key);

  @override
  _MyLikesListScreenState createState() => _MyLikesListScreenState();
}

class _MyLikesListScreenState extends State<MyLikesListScreen> {
  final Map<int, bool> _likedItems = {}; // 각 카드의 좋아요 상태를 저장하는 맵
  late AllBoardList review; // 리뷰가 필요 없으면 제거할 수 있음
  late Result<BoardDetailGetResponseModel> result;
  MyLikesListResponseModel? _myLikesInfo;
  bool _isLoading = true;
  bool _loginState = false;
  bool _dialogShown = false;

  @override
  void initState() {
    super.initState();
    _getMyLikesList();
    _startLoadingTimeout();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MyMenuController>().setSelectedScreen('myLikes');
    });
  }

  void _startLoadingTimeout() {
    Future.delayed(const Duration(seconds: 5), () {
      if (_isLoading) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  Future<void> _getMyLikesList() async {
    bool isLoggedIn = await checkLoginState(context);
    if (isLoggedIn) {
      setState(() {
        _loginState = isLoggedIn;
      });

      try {
        final result = await BoardService.getUserLikesList();
        if (result.value?.status == 200) { // 유저정보 로드 성공
          setState(() {
            _myLikesInfo = result.value;
            // 각 카드의 초기 좋아요 상태를 설정합니다.
            _likedItems.clear();
            for (var item in _myLikesInfo!.myLikesList!) {
              _likedItems[item.postid] = item.likeflag ?? false;
            }
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        showCustomSnackBar(context, '문제가 발생했습니다. 잠시 후 다시 시도해주세요.');
      }
    } else {
      if (!_dialogShown) {
        _dialogShown = true;
        await showRequestLoginDialog(context);
        _dialogShown = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _loadingUI(context),
        ),
      );
    } else {
      if (_myLikesInfo?.myLikesList == null || _myLikesInfo!.myLikesList!.isEmpty) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _myLikesEmptyPageUI(context),
          ),
        );
      } else {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _myLikesUI(context),
          ),
        );
      }
    }
  }

  Widget _loadingUI(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          showTitle('나의 좋아'),
          Expanded(
            flex: 2,
            child: Container(),
          ),
          const Expanded(
              flex: 1,
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.blue, // 로딩 표시 색상 설정 (파란색)
                ),
              )
          ),
          Expanded(
            flex: 2,
            child: Container(),
          )
        ],
      ),
    );
  }

  Widget _myLikesEmptyPageUI(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          showTitle('나의 좋아요'),
          Expanded(
            flex: 2,
            child: Container(),
          ),
          const Expanded(
              flex: 1,
              child: Center(
                child: Text('데이터가 존재하지 않습니다.'),
              )
          ),
          Expanded(
            flex: 2,
            child: Container(),
          )
        ],
      ),
    );
  }

  // 나의 좋아요 리스트 페이지 UI
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
                itemCount: _myLikesInfo?.myLikesList?.length ?? 0,
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

  // 좋아요 누른 후기 이미지 카드
  Widget _buildImageCard(BuildContext context, int index) {
    final postId = _myLikesInfo!.myLikesList![index].postid;
    final isLiked = _likedItems[postId] ?? false;

    return GestureDetector(
      onTap: () {
        // 초기화되지 않은 review 객체를 사용하기 전에 확인 필요
        if (_myLikesInfo != null) {
          showDetailReviewDialog(context, GOOGLE_MAP_KEY, review, result);
        } else {
          showCustomSnackBar(context, '리뷰 정보를 불러올 수 없습니다.');
        }
      },
      child: Stack(
        children: [
          AspectRatio(
            aspectRatio: 4 / 3, // 가로 4, 세로 3 비율
            child: _cardImgUI(index),
          ),
          Positioned(
            top: 1,
            right: 1,
            child: IconButton(
              icon: Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
                color: isLiked ? Colors.red : Colors.black,
              ),
              onPressed: () async {
                try {
                  final response = await BoardService.updateLikes(postId);
                  if (response != null) {
                    setState(() {
                      _likedItems[postId] = !isLiked;
                    });
                  }
                } catch (e) {
                  showCustomSnackBar(context, "좋아요 업데이트에 실패하였습니다.");
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // 대표 이미지
  Widget _cardImgUI(int index) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1.0),
        borderRadius: BorderRadius.circular(10),
        color: Colors.transparent,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0), // 모서리 둥글기 설정
        child: Image.network(
          (_myLikesInfo!.myLikesList![index].imgurl != null && _myLikesInfo!.myLikesList![index].imgurl!.isNotEmpty)
              ? _myLikesInfo!.myLikesList![index].imgurl.toString()
              : 'assets/images/noImg.jpg',
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
            // 오류가 발생할 경우 대체 이미지 제공
            print("@@@@@ postid: ${_myLikesInfo!.myLikesList![index].postid} + $exception" );
            return Image.asset('assets/images/noImg.jpg', fit: BoxFit.cover);
          },
        ),
      ),
    );
  }
}
