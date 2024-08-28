import 'package:flutter/material.dart';
import 'package:front/component/snack_bar.dart';
import 'package:front/screen/start/landing_screen.dart';
import 'package:front/service/chat_service.dart';

import '../../component/header/header.dart';
import '../../component/header/header_drawer.dart';
import '../../constants.dart';
import '../../controller/check_login_state.dart';
import '../../controller/login_state_for_header.dart';
import '../../responsive.dart';
import 'create_trip_screen.dart';

class CheckStartTripDateScreen extends StatefulWidget {
  @override
  _CheckStartTripDateScreenState createState() =>
      _CheckStartTripDateScreenState();
}

class _CheckStartTripDateScreenState extends State<CheckStartTripDateScreen> {
  final TextEditingController _controller = TextEditingController();
  String? tripDateText;
  bool isTripDateSelected = false;
  String sendDate = "";
  bool _isLoading = true;
  bool _loginState = false;

  @override
  void initState() {
    super.initState();
    _loadLoginState();
    _startLoadingTimeout();
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

  Future<void> _loadLoginState() async {
    bool isLoggedIn = await checkLoginState(context);
    if(isLoggedIn) {
      setState(() {
        _loginState = isLoggedIn;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if(_loginState) { //로그인 상태라면
      return Scaffold(
          appBar: Responsive.isNarrowWidth(context)
              ? ShortHeader(automaticallyImplyLeading: false)
              : AfterLoginHeader(automaticallyImplyLeading: false, context: context),
          drawer: Responsive.isNarrowWidth(context)
              ? AfterLoginHeaderDrawer()
              : null,
          backgroundColor: subBackgroundColor,
          body:_selectTripDateUI()
      );
    }
    else {
      return CheckLoginStateWidget(
          builder: (context, isLoggedIn) {
            PreferredSizeWidget currentAppBar;
            Widget? currentDrawer;
            currentAppBar = Responsive.isNarrowWidth(context)
                ? ShortHeader(automaticallyImplyLeading: false)
                : NotLoginHeader(automaticallyImplyLeading: false, context: context);
            currentDrawer = Responsive.isNarrowWidth(context)
                ? NotLoginHeaderDrawer()
                : null;
            return Scaffold(
                appBar: currentAppBar,
                drawer: currentDrawer,
                body: _notLoginUI()
            );
          }
      );
    }
  }

  Widget _selectTripDateUI() {
    return Center(
      child: Container(
        width: (Responsive.isNarrowWidth(context))
            ? MediaQuery.of(context).size.width*(0.9)
            : MediaQuery.of(context).size.width/3,
        height: MediaQuery.of(context).size.height/3,
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _titleText(),
            const Spacer(),
            _calendarUI(),
            const Spacer(),
            _btnsField(),
          ],
        ),
      ),
    );
  }

  Widget _notLoginUI() {
    return Container(
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Container(),
          ),
          const Expanded(
              flex: 1,
              child: Center(
                child: Text("페이지에 접근할 수 없습니다.")
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

  Widget _titleText() {
    return Text(
      "여행 시작일 설정",
      style: TextStyle(
        color: pointColor,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _calendarUI() {
    return GestureDetector(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(), // 오늘 날짜부터 선택 가능
          lastDate: DateTime.now().add(const Duration(days: 365 * 2)), // 5년 후까지 선택 가능
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: Colors.blue,
                  onPrimary: Colors.black,
                  onSurface: Colors.blue,
                ),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blueGrey,
                  ),
                ),
                dialogTheme: DialogTheme(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              child: child!,
            );
          },
        );
        if (pickedDate != null) {
          setState(() {
            tripDateText = "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
            if (pickedDate.month == 10 || pickedDate.month == 11 || pickedDate.month == 12) {
              if(1<=pickedDate.day && pickedDate.day<=9) {
                sendDate = "${pickedDate.year}${pickedDate.month}0${pickedDate.day}";
              }
              else {
                sendDate = "${pickedDate.year}${pickedDate.month}${pickedDate.day}";
              }
            }
            //한자리수 월
            else {
              if(1<=pickedDate.day && pickedDate.day<=9) {
                sendDate = "${pickedDate.year}0${pickedDate.month}0${pickedDate.day}";
              }
              else {
                sendDate = "${pickedDate.year}0${pickedDate.month}${pickedDate.day}";
              }
            }
            isTripDateSelected = true;
          });
        }
      },
      child: AbsorbPointer(
        child: TextFormField(
          controller: _controller,
          validator: (val) {
            if (!isTripDateSelected) {
              return '여행 시작일이 선택되지 않았습니다.';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: tripDateText ?? "여행 시작일을 선택하세요.",
            hintStyle: TextStyle(
              color: isTripDateSelected
                  ? Colors.black
                  : Colors.grey.withOpacity(0.7),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: pointColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _btnsField(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _cancelBtn(),
        Container(width: 10),
        _confirmBtn(),
      ],
    );
  }

  Widget _cancelBtn() {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LandingScreen()),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0), // 모서리 둥글게
          side: const BorderSide(
            color: secondaryColor, // 테두리 색상 설정
            width: 1.0, // 테두리 두께 설정
          ),
        ),
      ),
      child: const Text(
        "취소",
        style: TextStyle(color: secondaryColor),
      ),
    );
  }
  Widget _confirmBtn() {
    return ElevatedButton(
      onPressed: () async {
        try {
          final response = await ChatService.isChatStart(sendDate);
          if(response.isSuccess && response.value?.status == 200){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CreateTripScreen()),
            );
          }
          else {
            showCustomSnackBar(context, "채팅을 시작할 수 없습니다. 잠시 후 다시 시도해주세요.");
          }
        }
        catch(e) {
          showCustomSnackBar(context, "오류가 발생하였습니다. 잠시 후 다시 시도해주세요.");
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: secondaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0), // 모서리 둥글게
          side: const BorderSide(
            color: secondaryColor, // 테두리 색상 설정
            width: 1.0, // 테두리 두께 설정
          ),
        ),
      ),
      child: const Text(
        "확인",
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
