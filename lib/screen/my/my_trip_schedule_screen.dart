import 'package:flutter/material.dart';
import 'package:front/constants.dart';
import 'package:front/screen/chat/chatbot_screen.dart';
import 'package:front/screen/review/add_review_screen.dart';
import 'package:provider/provider.dart';

import '../../component/dialog/delete_trip_schedule_dialog.dart';
import '../../component/dialog/detail_trip_dialog.dart';
import '../../component/mypage/my_title.dart';
import '../../component/snack_bar.dart';
import '../../controller/check_login_state.dart';
import '../../controller/my_menu_controller.dart';
import '../../dto/user/login/login_response_model.dart';
import '../../key/key.dart';
import '../../responsive.dart';
import '../../service/session_service.dart';

class MyTripScheduleScreen extends StatefulWidget {
  const MyTripScheduleScreen({Key? key}) : super(key: key);

  @override
  _MyTripScheduleScreenState createState() => _MyTripScheduleScreenState();
}

class _MyTripScheduleScreenState extends State<MyTripScheduleScreen> {
  late Map<String, String> scheduleInfo;
  bool _isLoading = true;
  bool _loginState = false;
  LoginResponseModel? _userinfo;

  @override
  void initState() {
    super.initState();
    _checkLoginUserInfo();
    _startLoadingTimeout();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MyMenuController>().setSelectedScreen('mySchedule');
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

  Future<void> _checkLoginUserInfo() async {
    bool isLoggedIn = await checkLoginState(context);
    if (isLoggedIn) {
      setState(() {
        _loginState = isLoggedIn;
      });

      try {
        final usermodel = await SessionService.loginDetails();
        if (usermodel!=null) {
          setState(() {
            _userinfo = usermodel;
            _isLoading = false;
          });
        }
        else {
          setState(() {
            _isLoading = false;
          });
        }
      }
      catch (e) {
        setState(() {
          _isLoading = false;
        });
        showCustomSnackBar(context, '문제가 발생했습니다. 잠시 후 다시 시도해주세요.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if(_isLoading) {
      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _loadingUI(context),
        ),
      );
    }
    else{
      if (_loginState) {
        return Scaffold(
          body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Responsive.isNarrowWidth(context)
                  ? _myTripListPageNarrowUI() : _myTripListPageWideUI()
          ),
        );
      }
      else {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _notLoginProfileUI(),
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
          showTitle('나의 일정'),
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

  //저장된 여행 일정 페이지 UI
  Widget _myTripListPageNarrowUI() {
    return Padding(
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          showTitle('나의 일정'),
          const SizedBox(height: 20),
          _tapControllerUI(),
        ],
      ),
    );
  }

  //저장된 여행 일정 페이지 UI
  Widget _myTripListPageWideUI() {
    return Padding(
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          showTitle('나의 일정'),
          const SizedBox(height: 20),
          _tapControllerUI(),
        ],
      ),
    );
  }

  Widget _notLoginProfileUI() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          showTitle('나의 일정'),
          const SizedBox(height: 200),
          const Center(
            child: Text(
              '데이터를 불러올 수 없습니다.',
            ),
          ),
          const SizedBox(height: 200),
        ],
      ),
    );
  }

  //여행 탭 선택
  Widget _tapControllerUI() {
    return DefaultTabController(
      length: 3,
      child: Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TabBar(
              labelColor: pointColor,
              unselectedLabelColor: Colors.grey,
              indicatorColor: pointColor,
              tabs: [
                Tab(text: '진행중인 일정'),
                Tab(text: '다가오는 일정'),
                Tab(text: '지나간 일정'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _presentScheduleTab(context),
                  _upcomingScheduleTab(context),
                  _pastScheduleTab(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //진행중인 일정 탭 구성
  Widget _presentScheduleTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _presentScheduleCard(context),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  //다가오는 일정 탭 구성
  Widget _upcomingScheduleTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _upcomingScheduleCard(context),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  //지나간 일정 탭 구성
  Widget _pastScheduleTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _pastScheduleCard(context),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  //진행 중인 일정 카드
  Widget _presentScheduleCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1.0),
        borderRadius: BorderRadius.circular(10),
        color: Colors.transparent,
      ),
      child: Stack(
        children: [
          ListTile(
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
            onTap: () {
              showDetailTripDialog(context, GOOGLE_MAP_KEY);
            },
          ),
          Responsive.isNarrowWidth(context)
          ? _cardIconNarrowBtn(const Icon(Icons.chat_bubble_outline), const Icon(Icons.delete_outline))
          : _cardIconWideBtn(const Icon(Icons.chat_bubble_outline), const Icon(Icons.delete_outline))
        ],
      ),
    );
  }

  //다가오는 일정 카드
  Widget _upcomingScheduleCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1.0),
        borderRadius: BorderRadius.circular(10),
        color: Colors.transparent,
      ),
      child: Stack(
        children: [
          ListTile(
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
            onTap: () {
              showDetailTripDialog(context, GOOGLE_MAP_KEY);
            },
          ),
          Responsive.isNarrowWidth(context)
          ? _cardIconNarrowBtn(const Icon(Icons.chat_bubble_outline), const Icon(Icons.delete_outline))
          : _cardIconWideBtn(const Icon(Icons.chat_bubble_outline), const Icon(Icons.delete_outline))
        ],
      ),
    );
  }

  //지나간 일정 카드
  Widget _pastScheduleCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1.0),
        borderRadius: BorderRadius.circular(10),
        color: Colors.transparent,
      ),
      child: Stack(
        children: [
          ListTile(
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
            onTap: () {
              showDetailTripDialog(context, GOOGLE_MAP_KEY);
            },
          ),
          Responsive.isNarrowWidth(context)
          ? _cardIconNarrowBtn(const Icon(Icons.note_add_outlined), const Icon(Icons.delete_outline))
          : _cardIconWideBtn(const Icon(Icons.note_add_outlined), const Icon(Icons.delete_outline))
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
              if (icon1.icon == Icons.chat_bubble_outline) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ChatbotScreen()
                  ),
                );
              }
              else if (icon1.icon == Icons.note_add_outlined) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddReviewScreen()
                  ),
                );
              }
            },
          ),
          IconButton(
            icon: icon2,
            iconSize: 16,
            onPressed: () {
              showDeleteTripScheduleDialog(context);
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
              if (icon1.icon == Icons.chat_bubble_outline) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ChatbotScreen()
                  ),
                );
              }
              else if (icon1.icon == Icons.note_add_outlined) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddReviewScreen()
                  ),
                );
              }
            },
          ),
          IconButton(
            icon: icon2,
            iconSize: 22,
            onPressed: () {
              showDeleteTripScheduleDialog(context);
            },
          ),
        ],
      ),
    );
  }
}
