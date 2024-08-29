import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../component/dialog/delete_my_review_dialog.dart';
import '../../component/dialog/detail_review_dialog.dart';
import '../../component/dialog/edit_review_dialog.dart';
import '../../component/dialog/request_login_dialog.dart';
import '../../component/mypage/my_title.dart';
import '../../component/snack_bar.dart';
import '../../controller/check_login_state.dart';
import '../../controller/my_menu_controller.dart';
import '../../dto/board/board_myreviewlist_response_model.dart';
import '../../key/key.dart';
import '../../responsive.dart';
import '../../service/board_service.dart';
import '../../service/user_service.dart';

class MyReviewListScreen extends StatefulWidget {
  final bool currentLoginState;
  const MyReviewListScreen({Key? key, required this.currentLoginState}) : super(key: key);

  @override
  _MyReviewListScreenState createState() => _MyReviewListScreenState();
}

class _MyReviewListScreenState extends State<MyReviewListScreen> {
  bool _isLoading = true;
  bool _loginState = false;
  BoardMyListResponseModel? _myReviewInfo;

  @override
  void initState() {
    super.initState();
    _loginState = widget.currentLoginState;
    _getMyReviewList();
    _startLoadingTimeout();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MyMenuController>().setSelectedScreen('myReview');
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

  Future<void> _getMyReviewList() async {
    try {
      final result = await UserService.getUserReviewList();
      if (result.value?.status == 200) { // 유저정보 로드 성공
        setState(() {
          _myReviewInfo = result.value;
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
              child: _myReviewListPageUI()
          ),
        );
      }
    }
    // if(_isLoading) {
    //   return Scaffold(
    //     body: Padding(
    //       padding: const EdgeInsets.all(16.0),
    //       child: _loadingUI(context),
    //     ),
    //   );
    // }
    // else {
    //   if (_myReviewInfo == null || _myReviewInfo!.data == null || _myReviewInfo!.data!.isEmpty) {
    //     return Scaffold(
    //       body: Padding(
    //         padding: const EdgeInsets.all(16.0),
    //         child: _myReviewEmptyPageUI(context),
    //       ),
    //     );
    //   } else {
    //     return Scaffold(
    //       body: Padding(
    //         padding: const EdgeInsets.all(16.0),
    //         child: _myReviewNotEmptyPageUI(context),
    //       ),
    //     );
    //   }
    // }
  }

  Widget _myReviewListPageUI() {
    if (_myReviewInfo == null || _myReviewInfo!.data == null || _myReviewInfo!.data!.isEmpty) {
      return _myReviewEmptyPageUI(context);
    }
    else {
      return _myReviewNotEmptyPageUI(context);
    }
  }

  Widget _notLoginProfileUI() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          showTitle('나의 후기'),
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
          showTitle('나의 후기'),
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

  Widget _myReviewEmptyPageUI(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          showTitle('나의 후기'),
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

  //나의 후기 페이지 UI
  Widget _myReviewNotEmptyPageUI(BuildContext context) {
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

  // 내가 작성한 후기 카드
  Widget _myReviewCard(BuildContext context) {
    return Column(
      children: List.generate(_myReviewInfo!.data!.length, (index) {
        return GestureDetector(
          onTap: () async {
            try {
              final result = await BoardService.getReviewDetailInfo(_myReviewInfo!.data![index].postId.toString());
              if (result.value?.status == 200 /*result.value != null*/) {
                showDetailReviewDialog(
                  context,
                  GOOGLE_MAP_KEY,
                  _myReviewInfo!.data![index].postId,
                  result,
                );
              } else {
                showCustomSnackBar(context, '상세 정보를 불러오는 데 실패하였습니다. 잠시 후 다시 시도해주세요.');
              }
            } catch (e) {
              showCustomSnackBar(context, '에러가 발생했습니다. 잠시 후 다시 시도해주세요.');
            }
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 1.0),
              borderRadius: BorderRadius.circular(10),
              color: Colors.transparent,
            ),
            child: Stack(
              children: [
                _cardContent(index),
                Responsive.isNarrowWidth(context)
                    ? _cardIconNarrowBtn(const Icon(Icons.edit_outlined), const Icon(Icons.delete_outline), index)
                    : _cardIconWideBtn(const Icon(Icons.edit_outlined), const Icon(Icons.delete_outline), index),
              ],
            ),
          ),
        );
      }),
    );
  }

  // 카드 내용
  Widget _cardContent(int index) {
    String originalText = _myReviewInfo!.data![index].dday;
    String modifiedText = originalText.replaceAll('--', '+');
    return ListTile(
      contentPadding: const EdgeInsets.all(10),
      subtitle: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 10),
          Container(
            width: 100,
            height: 100,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0), // 모서리 둥글기 설정
              child: Image.network(
                _myReviewInfo!.data![index].url.isNotEmpty ? _myReviewInfo!.data![index].url[0] : 'assets/images/noImg.jpg',
                fit: BoxFit.cover,
                errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                  // 오류가 발생할 경우 대체 이미지 제공
                  return Image.asset('assets/images/noImg.jpg', fit: BoxFit.cover);
                },
              ),
            )
          ),
          const SizedBox(width: 10),
          Responsive.isNarrowWidth(context)
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('부산 여행 일정', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Text('${_myReviewInfo!.data![index].startTime} ~ ${_myReviewInfo!.data![index].endTime}', style: TextStyle(fontSize: 14)),
              const SizedBox(height: 5),
              Text(_myReviewInfo!.data![index].dayAndNights, style: TextStyle(fontSize: 14)),
              const SizedBox(height: 5),
              Text(modifiedText, style: TextStyle(fontSize: 14, color: Colors.red)),
            ],
          )
              : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('부산 여행 일정', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text('${_myReviewInfo!.data![index].startTime} ~ ${_myReviewInfo!.data![index].endTime}', style: TextStyle(fontSize: 14)),
                  const SizedBox(width: 10),
                  Text(_myReviewInfo!.data![index].dayAndNights, style: TextStyle(fontSize: 14)),
                  const SizedBox(height: 10),
                ],
              ),
              const SizedBox(height: 10),
              Text(modifiedText, style: TextStyle(fontSize: 14, color: Colors.red)),
            ],
          ),
        ],
      ),
    );
  }

  //카드 내 아이콘 버튼(좁은 화면)
  Widget _cardIconNarrowBtn(Icon icon1, Icon icon2, int index) {
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
              showDeleteMyReviewDialog(context, _myReviewInfo!.data![index].postId);
            },
          ),
        ],
      ),
    );
  }

  //카드 내 아이콘 버튼(넓은 화면)
  Widget _cardIconWideBtn(Icon icon1, Icon icon2, int index) {
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
            onPressed: () async {
              showDeleteMyReviewDialog(context, _myReviewInfo!.data![index].postId);
            },
          ),
        ],
      ),
    );
  }
}
