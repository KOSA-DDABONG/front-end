import 'package:flutter/material.dart';
import 'package:front/constants.dart';
import 'package:front/dto/board/board_mylikelist_response_model.dart';
import 'package:front/dto/board/board_myreviewlist_response_model.dart';
import 'package:front/responsive.dart';
import 'package:provider/provider.dart';

import '../../component/mypage/date_format.dart';
import '../../component/mypage/my_title.dart';
import '../../component/snack_bar.dart';
import '../../controller/my_menu_controller.dart';
import '../../dto/travel/my_travel_list_response_model.dart';
import '../../dto/user/login/login_response_model.dart';
import '../../service/session_service.dart';
import '../../service/user_service.dart';

class MyInfoScreen extends StatefulWidget {
  final bool currentLoginState;
  const MyInfoScreen({Key? key, required this.currentLoginState}) : super(key: key);

  @override
  _MyInfoScreenState createState() => _MyInfoScreenState();
}

class _MyInfoScreenState extends State<MyInfoScreen> {
  bool _isLoading = true;
  bool _loginState = false;
  LoginResponseModel? _userinfo;
  MyTravelListResponseModel? _myUpCommingInfo;
  BoardMyListResponseModel? _myReviewInfo;
  MyLikesListResponseModel? _myLikesInfo;


  @override
  void initState() {
    super.initState();
    _loginState = widget.currentLoginState;
    _getNeedInfos();
    _startLoadingTimeout(); // 로딩 시간 제한을 시작
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MyMenuController>().setSelectedScreen('myInfo');
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

  Future<void> _getNeedInfos() async {
    try {
      final upcomimgResult = await UserService.getFutureTravelList();
      final reviewListResult = await UserService.getUserReviewList();
      final likesListResult  = await UserService.getUserLikesList();
      final usermodel = await SessionService.loginDetails();
      if (usermodel != null || reviewListResult.value?.status == 200 || likesListResult.value?.status == 200 || upcomimgResult.value?.status == 200) { // 유저정보 로드 성공
        setState(() {
          _userinfo = usermodel;
          _myUpCommingInfo = upcomimgResult.value;
          _myReviewInfo = reviewListResult.value;
          _myLikesInfo = likesListResult.value;
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
            child: Responsive.isNarrowWidth(context)
                ? _profileNarrowUI(context)
                : _profileWideUI(context),
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
          showTitle('내 프로필'),
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

  //로그인X
  Widget _notLoginProfileUI() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          showTitle('내 프로필'),
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
                    Text(
                      '${_userinfo?.nickname}',
                      style: const TextStyle(
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
                    Text(
                        '${_userinfo?.nickname}',
                        style: const TextStyle(
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
            '다가오는 일정',
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
    if (_myUpCommingInfo == null || _myUpCommingInfo!.data == null || _myUpCommingInfo!.data!.isEmpty) {
      return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 1.0),
            borderRadius: BorderRadius.circular(10),
            color: Colors.transparent,
          ),
          child: const ListTile(
            subtitle: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 30),
                  Center(
                    child: Text('데이터가 존재하지 않습니다.'),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          )
      );
    }
    else {
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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0), // 모서리 둥글기 설정
                    child: Image.asset(
                      'assets/images/travel_schedule_default.jpg',
                      fit: BoxFit.cover,
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
                  Text(changeDateFormat(_myUpCommingInfo!.data.first.startTime), style: TextStyle(fontSize: 14)),
                  const SizedBox(height: 5),
                  Text(_myUpCommingInfo!.data.first.dayAndNights, style: TextStyle(fontSize: 14)),
                  const SizedBox(height: 5),
                  Text(_myUpCommingInfo!.data.first.dday, style: TextStyle(fontSize: 14, color: Colors.red)),
                ],
              )
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('부산 여행 일정', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text('일정 시작일: ${changeDateFormat(_myUpCommingInfo!.data.first.startTime)}', style: TextStyle(fontSize: 14)),
                      const SizedBox(width: 10),
                      Text(_myUpCommingInfo!.data.first.dayAndNights, style: TextStyle(fontSize: 14)),
                      const SizedBox(height: 10),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(_myUpCommingInfo!.data.first.dday, style: TextStyle(fontSize: 14, color: Colors.red)),
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
                  "${_myUpCommingInfo!.data.length} 건",
                  style: const TextStyle(
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
    final highestReview = _myReviewInfo?.data?.isNotEmpty == true
        ? _myReviewInfo!.data!.first
        : null;

    if (highestReview == null) {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1.0),
          borderRadius: BorderRadius.circular(10),
          color: Colors.transparent,
        ),
        child: const ListTile(
          subtitle: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 30),
                Center(
                  child: Text('데이터가 존재하지 않습니다.'),
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        )
      );
    }

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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0), // 모서리 둥글기 설정
                    child: Image.network(
                      _myReviewInfo!.data![0].url.isNotEmpty ? _myReviewInfo!.data![0].url[0] : 'assets/images/noImg.jpg',
                      fit: BoxFit.cover,
                      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                        // 오류가 발생할 경우 대체 이미지 제공
                        return Image.asset('assets/images/noImg.jpg', fit: BoxFit.cover);
                      },
                    ),
                  )
              ),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '부산 여행 일정',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    changeDateFormat(highestReview.startTime),
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    highestReview.dayAndNights,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    highestReview.dday,
                    style: const TextStyle(fontSize: 14, color: Colors.red),
                  ),
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
                "${_myReviewInfo!.data?.length} 건",
                style: const TextStyle(
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

  //좋아요 필드
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
    if (_myLikesInfo == null || _myLikesInfo!.myLikesList == null || _myLikesInfo!.myLikesList!.isEmpty) {
      return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 1.0),
            borderRadius: BorderRadius.circular(10),
            color: Colors.transparent,
          ),
          child: const ListTile(
            subtitle: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 30),
                  Center(
                    child: Text('데이터가 존재하지 않습니다.'),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          )
      );
    }
    else {
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
                    children: List.generate(_myLikesInfo!.myLikesList!.length, (index) {
                      return Container(
                          margin: EdgeInsets.only(right: spacing),
                          width: containerWidth,
                          height: containerWidth,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100), // 모서리 둥글기 설정
                            child: Image.network(
                              (_myLikesInfo!.myLikesList?[index].imgurl != null)
                                  ? _myLikesInfo!.myLikesList![index].imgurl.toString()
                                  : 'assets/images/noImg.jpg',
                              fit: BoxFit.cover,
                              errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                // 오류가 발생할 경우 대체 이미지 제공
                                return Image.asset('assets/images/noImg.jpg', fit: BoxFit.cover);
                              },
                            ),
                          )
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
                  '${_myLikesInfo!.myLikesList!.length}건',
                  style: const TextStyle(
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
}