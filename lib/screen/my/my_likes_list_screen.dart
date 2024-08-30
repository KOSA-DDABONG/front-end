import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../component/dialog/detail_review_dialog.dart';
import '../../component/dialog/request_login_dialog.dart';
import '../../component/mypage/my_title.dart';
import '../../component/snack_bar.dart';
import '../../controller/check_login_state.dart';
import '../../controller/my_menu_controller.dart';
import '../../dto/board/board_mylikelist_response_model.dart';
import '../../key/key.dart';
import '../../service/board_service.dart';
import '../../service/session_service.dart';
import '../../service/user_service.dart';
import '../start/login_screen.dart';

class MyLikesListScreen extends StatefulWidget {
  final bool currentLoginState;
  const MyLikesListScreen({Key? key, required this.currentLoginState}) : super(key: key);

  @override
  _MyLikesListScreenState createState() => _MyLikesListScreenState();
}

class _MyLikesListScreenState extends State<MyLikesListScreen> {
  final Map<int, bool> _likedItems = {}; // 각 카드의 좋아요 상태를 저장하는 맵
  MyLikesListResponseModel? _myLikesInfo;
  bool _isLoading = true;
  bool _loginState = false;

  @override
  void initState() {
    super.initState();
    _loginState = widget.currentLoginState;
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

    try {
      final result = await UserService.getUserLikesList();
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
  }

  @override
  Widget build(BuildContext context) {
    if(!_loginState) {
      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _notLoginProfileUI(),
        ),
      );
    }
    else {
      if(_isLoading) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _loadingUI(context),
          ),
        );
      }
      else {
        return Scaffold(
          body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _myLikesListPageUI()
          ),
        );
      }
    }
  }

  Widget _myLikesListPageUI() {
    if (_myLikesInfo?.myLikesList == null || _myLikesInfo!.myLikesList!.isEmpty) {
      return Scaffold(
        body: _myLikesEmptyPageUI(context),
      );
    } else {
      return Scaffold(
        body: _myLikesUI(context),
      );
    }
  }

  Widget _notLoginProfileUI() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          showTitle('나의 좋아요'),
          const SizedBox(height: 200),
          const Center(
            child: Text(
              '페이지에 접근할 수 없습니다.',
            ),
          ),
          const SizedBox(height: 200),
        ],
      ),
    );
  }

  Widget _loadingUI(BuildContext context) {
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
    final isLiked = _likedItems[postId] ?? true;

    return GestureDetector(
      onTap: () async {
        try {
          final result = await BoardService.getReviewDetailInfo(postId.toString());
          final accessToken = await SessionService.getAccessToken();
          if (result.value?.status == 200 /*result.value != null*/) {
            showDetailReviewDialog(
              context,
              GOOGLE_MAP_KEY,
              postId,
              result,
            );
          } else {
            if (accessToken == null) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('메세지'),
                    content: Text('로그인 후 이용 가능한 서비스입니다. 로그인 하시겠습니까?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('취소'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                          );
                        },
                        child: Text('로그인'),
                      ),
                    ],
                  );
                },
              );
            } else {
              showCustomSnackBar(context, '상세 정보를 불러오는 데 실패하였습니다. 잠시 후 다시 시도해주세요.');
            }
          }
        } catch (e) {
          showCustomSnackBar(context, '에러가 발생했습니다. 잠시 후 다시 시도해주세요.');
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
                print("좋아요 변경 0");
                try {
                  final response = await BoardService.updateLikes(postId);
                  print("좋아요 변경 1" + response.toString());
                  if (response != null) {
                    print("좋아요 변경 0");
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
            return Image.asset('assets/images/noImg.jpg', fit: BoxFit.cover);
          },
        ),
      ),
    );
  }
}
