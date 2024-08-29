import 'package:flutter/material.dart';
import 'package:front/constants.dart';
import 'package:front/dto/travel/my_travel_list_response_model.dart';
import 'package:front/screen/chat/chatbot_screen.dart';
import 'package:front/screen/review/add_review_screen.dart';
import 'package:provider/provider.dart';

import '../../component/dialog/delete_trip_schedule_dialog.dart';
import '../../component/dialog/detail_trip_dialog.dart';
import '../../component/mypage/date_format.dart';
import '../../component/mypage/my_title.dart';
import '../../component/snack_bar.dart';
import '../../controller/my_menu_controller.dart';
import '../../key/key.dart';
import '../../responsive.dart';
import '../../service/user_service.dart';

class MyTripScheduleScreen extends StatefulWidget {
  final bool currentLoginState;
  const MyTripScheduleScreen({Key? key, required this.currentLoginState}) : super(key: key);

  @override
  _MyTripScheduleScreenState createState() => _MyTripScheduleScreenState();
}

class _MyTripScheduleScreenState extends State<MyTripScheduleScreen> {
  late Map<String, String> scheduleInfo;
  bool _isLoading = true;
  bool _loginState = false;
  MyTravelListResponseModel? _pastTravelInfo;
  MyTravelListResponseModel? _presentTravelInfo;
  MyTravelListResponseModel? _futureTravelInfo;

  @override
  void initState() {
    super.initState();
    _loginState = widget.currentLoginState;
    _getMyTravelList();
    // _getMyPastTravelList();
    // _getMyPresentTravelList();
    // _getMyFutureTravelList();
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

  Future<void> _getMyTravelList() async {
    try {
      final pastResult = await UserService.getPastTravelList();
      final presentResult = await UserService.getPresentTravelList();
      final futureResult = await UserService.getFutureTravelList();
      if (pastResult.value?.status == 200 && presentResult.value?.status == 200 && futureResult.value?.status == 200) {
        setState(() {
          _pastTravelInfo = pastResult.value;
          _presentTravelInfo = presentResult.value;
          _futureTravelInfo = futureResult.value;
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

  // Future<void> _getMyPastTravelList() async {
  //   try {
  //     final pastResult = await UserService.getPastTravelList();
  //     if (pastResult.value?.status == 200) {
  //       setState(() {
  //         _pastTravelInfo = pastResult.value;
  //         _isLoading = false;
  //       });
  //     } else {
  //       setState(() {
  //         _isLoading = false;
  //       });
  //     }
  //   } catch (e) {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //     showCustomSnackBar(context, '문제가 발생했습니다. 잠시 후 다시 시도해주세요.');
  //   }
  // }
  //
  // Future<void> _getMyPresentTravelList() async {
  //   try {
  //     final presentResult = await UserService.getPresentTravelList();
  //     if (presentResult.value?.status == 200) {
  //       setState(() {
  //         _presentTravelInfo = presentResult.value;
  //         _isLoading = false;
  //       });
  //     } else {
  //       setState(() {
  //         _isLoading = false;
  //       });
  //     }
  //   } catch (e) {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //     showCustomSnackBar(context, '문제가 발생했습니다. 잠시 후 다시 시도해주세요.');
  //   }
  // }
  //
  // Future<void> _getMyFutureTravelList() async {
  //   try {
  //     final futureResult = await UserService.getFutureTravelList();
  //     if (futureResult.value?.status == 200) {
  //       setState(() {
  //         _futureTravelInfo = futureResult.value;
  //         _isLoading = false;
  //       });
  //     } else {
  //       setState(() {
  //         _isLoading = false;
  //       });
  //     }
  //   } catch (e) {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //     showCustomSnackBar(context, '문제가 발생했습니다. 잠시 후 다시 시도해주세요.');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    print("1");
    if(!_loginState) {
      print("2");
      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _notLoginProfileUI(),
        ),
      );
    }
    else {
      print("3");
      if(_isLoading) {
        print("4");
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _loadingUI(context),
          ),
        );
      }
      else {
        print("5");
        return Scaffold(
          body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Responsive.isNarrowWidth(context)
                  ? _myTripListPageNarrowUI() : _myTripListPageWideUI()
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
    return Container(
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          showTitle('나의 일정'),
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
    if(_presentTravelInfo!.data == null || _presentTravelInfo!.data.isEmpty) {
      return const Column(
        children: [
          SizedBox(height: 100,),
          Center(
            child: Text("해당 데이터가 없습니다.")
          ),
        ],
      );
    }
    else {
      return Container(
        height: 500,
        // decoration: BoxDecoration(
        //   border: Border.all(color: Colors.black, width: 1.0),
        //   borderRadius: BorderRadius.circular(10),
        //   color: Colors.transparent,
        // ),
        child: ListView.builder(
          itemCount: _presentTravelInfo!.data.length,
          itemBuilder: (context, index) {
            return Stack(
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
                          const Text('부산 여행 일정',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 5),
                          Text(
                              changeDateFormat(
                                  _presentTravelInfo!.data[index].startTime),
                              style: const TextStyle(fontSize: 14)),
                          const SizedBox(height: 5),
                          Text(
                              _presentTravelInfo!.data[index].dayAndNights,
                              style: const TextStyle(fontSize: 14)),
                          const SizedBox(height: 5),
                          Text(_presentTravelInfo!.data[index].dday,
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.red)),
                        ],
                      )
                          : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('부산 여행 일정',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                  '일정 시작일: ${changeDateFormat(_presentTravelInfo!.data[index].startTime)}',
                                  style: const TextStyle(fontSize: 14)),
                              const SizedBox(width: 10),
                              Text(_presentTravelInfo!.data[index].dayAndNights,
                                  style: const TextStyle(fontSize: 14)),
                              const SizedBox(height: 10),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(_presentTravelInfo!.data[index].dday,
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.red)),
                        ],
                      ),
                    ],
                  ),
                  onTap: () {
                    showDetailTripDialog(context, GOOGLE_MAP_KEY);
                  },
                ),
                Responsive.isNarrowWidth(context)
                    ? _cardIconNarrowBtn(
                    const Icon(Icons.chat_bubble_outline),
                    const Icon(Icons.delete_outline))
                    : _cardIconWideBtn(
                    const Icon(Icons.chat_bubble_outline),
                    const Icon(Icons.delete_outline))
              ],
            );
          },
        ),
      );
    }
  }



  //다가오는 일정 카드
  Widget _upcomingScheduleCard(BuildContext context) {
    if(_futureTravelInfo!.data == null || _futureTravelInfo!.data.isEmpty) {
      return const Column(
        children: [
          SizedBox(height: 100,),
          Center(
              child: Text("해당 데이터가 없습니다.")
          ),
        ],
      );
    }
    else {
      return Container(
        height: 500,
        // decoration: BoxDecoration(
        //   border: Border.all(color: Colors.black, width: 1.0),
        //   borderRadius: BorderRadius.circular(10),
        //   color: Colors.transparent,
        // ),
        child: ListView.builder(
          itemCount: _futureTravelInfo!.data.length,
          itemBuilder: (context, index) {
            return Stack(
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
                          const Text('부산 여행 일정',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 5),
                          Text(
                              changeDateFormat(
                                  _futureTravelInfo!.data[index].startTime),
                              style: const TextStyle(fontSize: 14)),
                          const SizedBox(height: 5),
                          Text(
                              _futureTravelInfo!.data[index].dayAndNights,
                              style: const TextStyle(fontSize: 14)),
                          const SizedBox(height: 5),
                          Text(_futureTravelInfo!.data[index].dday,
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.red)),
                        ],
                      )
                          : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('부산 여행 일정',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                  '일정 시작일: ${changeDateFormat(_futureTravelInfo!.data[index].startTime)}',
                                  style: const TextStyle(fontSize: 14)),
                              const SizedBox(width: 10),
                              Text(_futureTravelInfo!.data[index].dayAndNights,
                                  style: const TextStyle(fontSize: 14)),
                              const SizedBox(height: 10),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(_futureTravelInfo!.data[index].dday,
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.red)),
                        ],
                      ),
                    ],
                  ),
                  onTap: () {
                    showDetailTripDialog(context, GOOGLE_MAP_KEY);
                  },
                ),
                Responsive.isNarrowWidth(context)
                    ? _cardIconNarrowBtn(
                    const Icon(Icons.chat_bubble_outline),
                    const Icon(Icons.delete_outline))
                    : _cardIconWideBtn(
                    const Icon(Icons.chat_bubble_outline),
                    const Icon(Icons.delete_outline))
              ],
            );
          },
        ),
      );
    }
  }


  //지나간 일정 카드
  Widget _pastScheduleCard(BuildContext context) {
    if(_pastTravelInfo?.data == null || _pastTravelInfo!.data.isEmpty) {
      return const Column(
        children: [
          SizedBox(height: 100,),
          Center(
              child: Text("해당 데이터가 없습니다.")
          ),
        ],
      );
    }
    else {
      return Container(
        height: 500,
        // decoration: BoxDecoration(
        //   border: Border.all(color: Colors.black, width: 1.0),
        //   borderRadius: BorderRadius.circular(10),
        //   color: Colors.transparent,
        // ),
        child: ListView.builder(
          itemCount: _pastTravelInfo!.data.length,
          itemBuilder: (context, index) {
            return Stack(
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
                          const Text('부산 여행 일정',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 5),
                          Text(
                              changeDateFormat(
                                  _pastTravelInfo!.data[index].startTime),
                              style: const TextStyle(fontSize: 14)),
                          const SizedBox(height: 5),
                          Text(
                              _pastTravelInfo!.data[index].dayAndNights,
                              style: const TextStyle(fontSize: 14)),
                          const SizedBox(height: 5),
                          Text(_pastTravelInfo!.data[index].dday,
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.red)),
                        ],
                      )
                          : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('부산 여행 일정',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                  '일정 시작일: ${changeDateFormat(_pastTravelInfo!.data[index].startTime)}',
                                  style: const TextStyle(fontSize: 14)),
                              const SizedBox(width: 10),
                              Text(_pastTravelInfo!.data[index].dayAndNights,
                                  style: const TextStyle(fontSize: 14)),
                              const SizedBox(height: 10),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(_pastTravelInfo!.data[index].dday,
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.red)),
                        ],
                      ),
                    ],
                  ),
                  onTap: () {
                    showDetailTripDialog(context, GOOGLE_MAP_KEY);
                  },
                ),
                Responsive.isNarrowWidth(context)
                    ? _cardIconNarrowBtn(
                    const Icon(Icons.chat_bubble_outline),
                    const Icon(Icons.delete_outline))
                    : _cardIconWideBtn(
                    const Icon(Icons.chat_bubble_outline),
                    const Icon(Icons.delete_outline))
              ],
            );
          },
        ),
      );
    }
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
