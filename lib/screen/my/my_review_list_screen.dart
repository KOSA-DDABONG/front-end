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
import '../../dto/board/board_detail_get_response_model.dart';
import '../../dto/board/board_model.dart';
import '../../dto/board/board_mylist_response.dart';
import '../../key/key.dart';
import '../../responsive.dart';
import '../../service/board_service.dart';
import '../../service/result.dart';

class MyReviewListScreen extends StatefulWidget {
  const MyReviewListScreen({Key? key}) : super(key: key);

  @override
  _MyReviewListScreenState createState() => _MyReviewListScreenState();
}

class _MyReviewListScreenState extends State<MyReviewListScreen> {
  late Board review;
  // late Result<BoardDetailResponseModel> result;
  late Result<BoardDetailGetResponseModel> result;
  bool _isLoading = true;
  bool _loginState = false;
  bool _dialogShown  = false;
  BoardMyListResponseModel? _myReviewInfo;

  @override
  void initState() {
    super.initState();
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
    bool isLoggedIn = await checkLoginState(context);
    if (isLoggedIn) {
      setState(() {
        _loginState = isLoggedIn;
      });

      try {
        final result = await BoardService.getUserReviewList();
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
    // if (_myReviewInfo == null || _myReviewInfo!.data == null || _myReviewInfo!.data!.isEmpty) {
    //   return Scaffold(
    //     body: Padding(
    //       padding: const EdgeInsets.all(16.0),
    //       child: _myReviewEmptyPageUI(context),
    //     ),
    //   );
    // } else {
    //   return Scaffold(
    //     body: Padding(
    //       padding: const EdgeInsets.all(16.0),
    //       child: _myReviewNotEmptyPageUI(context),
    //     ),
    //   );
    // }
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _myReviewNotEmptyPageUI(context),
      ),
    );
  }


  Widget _myReviewEmptyPageUI(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(25),
      child:
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          showTitle('나의 후기'),
          const SizedBox(height: 20),
          Center(
            child: Text('데이터가 존재하지 않습니다.'),
          )
        ],
      ),
    );
  }
  //나의 후기 페이지 UI
  Widget _myReviewNotEmptyPageUI(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(25),
      child:
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          showTitle('나의 후기'),
          const SizedBox(height: 20),
          _myReviewCard(context),
        ],
      ),
    );
  }

  //
  // 내가 작성한 후기 카드
  Widget _myReviewCard(BuildContext context) {
    return ListView.builder(
      itemCount: _myReviewInfo!.data!.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            showDetailReviewDialog(context, _myReviewInfo!.data!.first.url as String, GOOGLE_MAP_KEY, review, result);
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
                    ? _cardIconNarrowBtn(const Icon(Icons.edit_outlined), const Icon(Icons.delete_outline))
                    : _cardIconWideBtn(const Icon(Icons.edit_outlined), const Icon(Icons.delete_outline)),
              ],
            ),
          ),
        );
      },
    );
  }

  // 카드 내용
  Widget _cardContent(int index) {
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
              image: DecorationImage(
                image: NetworkImage(_myReviewInfo!.data![index].url.isNotEmpty ? _myReviewInfo!.data![index].url[0] : 'assets/images/noImg.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Responsive.isNarrowWidth(context)
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('부산 여행 일정', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Text('${_myReviewInfo!.data![index].startTime} ~ ${_myReviewInfo!.data![index].endTime}', style: TextStyle(fontSize: 14)),
              const SizedBox(height: 5),
              Text(_myReviewInfo!.data![index].dayAndNights, style: TextStyle(fontSize: 14)),
              const SizedBox(height: 5),
              Text(_myReviewInfo!.data![index].dday, style: TextStyle(fontSize: 14, color: Colors.red)),
            ],
          )
              : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('부산 여행 일정', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
              Text(_myReviewInfo!.data![index].dday, style: TextStyle(fontSize: 14, color: Colors.red)),
            ],
          ),
        ],
      ),
    );
  }
  //

  // //내가 작성한 후기 카드
  // Widget _myReviewCard(BuildContext context) {
  //   return GestureDetector(
  //     onTap: () {
  //       showDetailReviewDialog(context, _myReviewInfo!.data!.first.url as String, GOOGLE_MAP_KEY, review, result);
  //     },
  //     child: Container(
  //       decoration: BoxDecoration(
  //         border: Border.all(color: Colors.black, width: 1.0),
  //         borderRadius: BorderRadius.circular(10),
  //         color: Colors.transparent,
  //       ),
  //       child: Stack(
  //         children: [
  //           _cardContent(),
  //           Responsive.isNarrowWidth(context)
  //               ? _cardIconNarrowBtn(const Icon(Icons.edit_outlined), const Icon(Icons.delete_outline))
  //               : _cardIconWideBtn(const Icon(Icons.edit_outlined), const Icon(Icons.delete_outline))
  //         ],
  //       ),
  //     ),
  //   );
  // }
  //
  // //카드 내용
  // Widget _cardContent() {
  //   return ListTile(
  //     contentPadding: const EdgeInsets.all(10),
  //     subtitle: Row(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         const SizedBox(width: 10),
  //         Container(
  //           width: 100,
  //           height: 100,
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(10),
  //             image: const DecorationImage(
  //               image: AssetImage('assets/images/landing_background.jpg'),
  //               fit: BoxFit.cover,
  //             ),
  //           ),
  //         ),
  //         const SizedBox(width: 10),
  //         Responsive.isNarrowWidth(context)
  //         ? Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text('{일정 이름}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
  //               const SizedBox(height: 5),
  //               Text('{YYYY-MM-DD}', style: TextStyle(fontSize: 14)),
  //               const SizedBox(height: 5),
  //               Text('{0박 0일}', style: TextStyle(fontSize: 14)),
  //               const SizedBox(height: 5),
  //               Text('{D-5}', style: TextStyle(fontSize: 14, color: Colors.red)),
  //             ],
  //           )
  //          : Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text('{일정 이름}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
  //                 const SizedBox(height: 10),
  //                 Row(
  //                   children: [
  //                     Text('{일정 시작일: YYYY-MM-DD}', style: TextStyle(fontSize: 14)),
  //                     const SizedBox(width: 10),
  //                     Text('{0박 0일}', style: TextStyle(fontSize: 14)),
  //                     const SizedBox(height: 10),
  //                   ],
  //                 ),
  //                 const SizedBox(height: 10),
  //                 Text('{D-5}', style: TextStyle(fontSize: 14, color: Colors.red)),
  //               ],
  //             ),
  //       ],
  //     ),
  //   );
  // }

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
