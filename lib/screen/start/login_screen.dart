import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:front/screen/start/landing_screen.dart';
import 'package:front/screen/start/signup_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';

import '../../component/backgroundImg/login_signup_background.dart';
import '../../component/header/header_drawer.dart';
import '../../component/validate/check_input_validate.dart';
import '../../constants.dart';
import '../../dto/user/login/login_request_model.dart';
import '../../responsive.dart';
import '../../service/user_service.dart';
import '../../component/header/header.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isApiCallProcess = false;
  bool hidePassword = true;
  final GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  String? userId;
  String? password;

  FocusNode idFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  Color idIconColor = Colors.grey.withOpacity(0.7);
  Color passwordIconColor = Colors.grey.withOpacity(0.7);

  bool rememberId = false;

  TextEditingController idController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadPreferences();
  }

  void loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      rememberId = prefs.getBool('rememberId') ?? false;
    });

    if (rememberId) {
      setState(() {
        userId = prefs.getString('userId') ?? '';
        idController.text = userId ?? '';
      });
    }
  }

  void savePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('rememberId', rememberId);

    if (rememberId) {
      prefs.setString('userId', userId ?? '');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Responsive.isNarrowWidth(context)
          ? ShortHeader(
              automaticallyImplyLeading: false
          )
          : NotLoginHeader(
              automaticallyImplyLeading: false,
              context: context,
            ),
      drawer: Responsive.isNarrowWidth(context)
          ? NotLoginHeaderDrawer()
          : null,
      backgroundColor: subBackgroundColor,
      body: Stack(
        children: [
          showLoginSignupBackgroungImg(context),
          ProgressHUD(
            inAsyncCall: isApiCallProcess,
            opacity: 0.3,
            key: UniqueKey(),
            child: Form(
              key: globalFormKey,
              child: SingleChildScrollView(
                child: Responsive.isNarrowWidth(context)
                  ? _loginNarrowUI()
                  : _loginWideUI()
              )
            )
          )
        ],
      ),
    );
  }
  
  //로그인 페이지 UI(화면 좁을 때)
  Widget _loginNarrowUI() {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Container(),
        ),
        Expanded(
          flex: 13,
          child: Column(
            children: <Widget>[
              const SizedBox(height: 100),
              _buildIdField(),
              const SizedBox(height: 30),
              _buildPasswordField(),
              const SizedBox(height: 20),
              _checkboxRememberId(),
              const SizedBox(height: 60),
              _buildLoginButton(),
              const SizedBox(height: 30),
              _buildOrText(),
              const SizedBox(height: 30),
              _buildSignupText(),
              const SizedBox(height: 100),
            ],
          ),
        ),
        Expanded(
          flex: 4,
          child: Container(),
        ),
      ],
    );
  }

  //로그인 페이지 UI(화면 넓을 때)
  Widget _loginWideUI() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(),
        ),
        Expanded(
          flex: 3,
          child: Column(
            children: <Widget>[
              const SizedBox(height: 60),
              _titleUI(),
              const SizedBox(height: 50),
              _buildIdField(),
              const SizedBox(height: 30),
              _buildPasswordField(),
              const SizedBox(height: 20),
              _checkboxRememberId(),
              const SizedBox(height: 60),
              _buildLoginButton(),
              const SizedBox(height: 30),
              _buildOrText(),
              const SizedBox(height: 30),
              _buildSignupText(),
              const SizedBox(height: 100),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(),
        ),
      ],
    );
  }

  //타이틀
  Widget _titleUI() {
    return Center(
      child: Text(
        'TripFlow',
        style: GoogleFonts.indieFlower(
          fontSize: 50,
          fontWeight: FontWeight.bold,
          color: pointColor,
        ),
      ),
    );
  }

  //아이디 입력란
  Widget _buildIdField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "아이디",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 5),
        Focus(
          onFocusChange: (hasFocus) {
            setState(() {
              idIconColor =
              hasFocus ? pointColor : Colors.grey.withOpacity(0.7);
            });
          },
          child: Container(
            height: 60,
            child: TextFormField(
              controller: idController,
              focusNode: idFocusNode,
              validator: (val) => val!.isEmpty ? '아이디가 입력되지 않았습니다.' : null,
              onChanged: (val) => userId = val,
              obscureText: false,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                hintText: "아이디를 입력하세요.",
                hintStyle: TextStyle(color: Colors.grey.withOpacity(0.7)),
                prefixIcon: Icon(
                  Icons.person,
                  color: idIconColor,
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: pointColor,
                  ),
                ),
              ),
            ),
          )
        ),
      ],
    );
  }

  //비밀번호 입력란
  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "비밀번호",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 5),
        Focus(
          onFocusChange: (hasFocus) {
            setState(() {
              passwordIconColor =
              hasFocus ? pointColor : Colors.grey.withOpacity(0.7);
            });
          },
          child: Container(
            height: 60,
            child: TextFormField(
              focusNode: passwordFocusNode,
              validator: (val) => val!.isEmpty ? '비밀번호가 입력되지 않았습니다.' : null,
              onChanged: (val) => password = val,
              obscureText: hidePassword,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                hintText: "비밀번호를 입력하세요.",
                hintStyle: TextStyle(color: Colors.grey.withOpacity(0.7)),
                prefixIcon: Icon(
                  Icons.lock,
                  color: passwordIconColor,
                ),
                suffixIcon: InkWell(
                  onTap: () {
                    setState(() {
                      hidePassword = !hidePassword;
                    });
                  },
                  child: Icon(
                    hidePassword ? Icons.visibility_off : Icons.visibility,
                    color: hidePassword
                        ? Colors.grey.withOpacity(0.7)
                        : pointColor,
                  ),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: pointColor,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  //아이디 기억하기
  Widget _checkboxRememberId() {
    return Row(
      children: [
        Checkbox(
          value: rememberId,
          onChanged: (value) {
            setState(() {
              rememberId = value!;
            });
          },
          activeColor: pointColor,
        ),
        const Text("아이디 기억하기"),
      ],
    );
  }

  //로그인 버튼
  Widget _buildLoginButton() {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth,
      child: ElevatedButton(
        onPressed: () async {
          if (checkInputValidate(globalFormKey)) {
            setState(() {
              isApiCallProcess = true;
            });
            try {
              final model = LoginRequestModel(userId: userId, password: password);
              final result = await UserService.login(model);

              if (result.value != null) {
                savePreferences();
                // final userProfileResult = await UserService.getUserProfile();

                setState(() {
                  isApiCallProcess = false;
                });

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LandingScreen()),
                );

              } else {
                setState(() {
                  isApiCallProcess = false;
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('로그인에 실패하였습니다. 아이디와 비밀번호를 다시 확인해주세요.'),
                  ),
                );
              }
            } catch (e) {
              setState(() {
                isApiCallProcess = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('에러가 발생했습니다: $e'),
                ),
              );
            }
          }
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          backgroundColor: Colors.blue,
        ),
        child: Text(
          '로그인하기',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  //OR 텍스트
  Widget _buildOrText() {
    return const Center(
      child: Text(
        "OR",
        style: TextStyle(
          fontSize: 15,
          color: Colors.black,
        ),
      ),
    );
  }

  //회원가입 텍스트
  Widget _buildSignupText() {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.black, fontSize: 14.0),
            children: <TextSpan>[
              const TextSpan(text: '등록된 계정이 없으신가요? '),
              TextSpan(
                text: '회원가입 하기',
                style: const TextStyle(
                  color: pointColor,
                  fontWeight: FontWeight.bold,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignupScreen()),
                    );
                  },
              ),
            ],
          ),
        ),
      ),
    );
  }
}