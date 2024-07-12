import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:front/screen/menu/my_menu_screen.dart';
import 'package:front/screen/start/signup_screen.dart';
import 'package:front/service/session_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';

import '../../constants.dart';
import '../../dto/login/login_request_model.dart';
import '../../responsive.dart';
import '../../service/user_service.dart';


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

    // Load the checkbox state
    setState(() {
      rememberId = prefs.getBool('rememberId') ?? false;
    });

    // Load the email field text if the checkbox is checked
    if (rememberId) {
      setState(() {
        userId = prefs.getString('userId') ?? '';
        idController.text = userId ?? '';
      });
    }
  }

  void savePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Save the checkbox state
    prefs.setBool('rememberId', rememberId);

    // Save the email field text if the checkbox is checked
    if (rememberId) {
      prefs.setString('userId', userId ?? '');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          title: const Text(
            '로그인',
            style: TextStyle(color: secondaryColor),
          ),
          backgroundColor: Colors.white,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4.0),
            child: Container(
              color: Colors.black,
              height: 1.0,
            ),
          ),
        ),
      ),
      // appBar: AppBar(
      //   title: const Text('로그인', style: TextStyle(color: Colors.white),),
      //   backgroundColor: secondaryColor,
      // ),
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProgressHUD(
              inAsyncCall: isApiCallProcess,
              opacity: 0.3,
              key: UniqueKey(),
              child: Form(
                key: globalFormKey,
                // child: _loginUI(context),
                child: Responsive(
                  mobile: _loginUIMobile(context),
                  tablet: _loginUITablet(context),
                  desktop: _loginUIDesktop(context),
                ),
              )
            )
          ],
        ),
      ),
    );
  }

  Widget _loginUIMobile(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: _loginUI(context),
    );
  }

  Widget _loginUITablet(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 60),
      child: _loginUI(context),
    );
  }

  Widget _loginUIDesktop(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 80),
        width: MediaQuery.of(context).size.width / 2,
        child: _loginUI(context),
      ),
    );
  }


  // 로그인 UI
  Widget _loginUI(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 100),
        _buildIdField(),
        const SizedBox(height: 30),
        _buildPasswordField(),
        const SizedBox(height: 30),
        _checkboxRememberEmail(),
        const SizedBox(height: 80),
        _buildLoginButton(context),
        const SizedBox(height: 50),
        _buildOrText(),
        const SizedBox(height: 30),
        _buildSignupText(),
        const SizedBox(height: 100),
      ],
    );
  }

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
                hasFocus ? Colors.black : Colors.grey.withOpacity(0.7);
              });
            },
            child: Container(
              height: 60,
              child: TextFormField(
                controller: idController,
                // initialValue: email,
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
                      color: Colors.black, // Change the color as needed
                    ),
                  ),
                ),
              ),
            )),
      ],
    );
  }

// Update _buildPasswordField method
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
              hasFocus ? Colors.black : Colors.grey.withOpacity(0.7);
            });
          },
          child: Container(
            height: 60,
            child: TextFormField(
              // initialValue: '1234',
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
                        : Colors.black,
                  ),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black, // Change the color as needed
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _checkboxRememberEmail() {
    return Row(
      children: [
        Checkbox(
          value: rememberId,
          onChanged: (value) {
            setState(() {
              rememberId = value!;
            });
          },
          activeColor: Colors.black,
        ),
        const Text("아이디 기억하기"),
      ],
    );
  }

//  로그인 버튼
  Widget _buildLoginButton(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return InkWell(
      child: Container(
        width: screenWidth, // 원하는 너비 설정
        height: 50, // 원하는 높이 설정
        decoration: BoxDecoration(
          color: secondaryColor, // 버튼 배경색 설정
          borderRadius: BorderRadius.circular(5.0), // 원하는 모양 설정
        ),
        child: const Center(
          child: Text(
            "로그인",
            style: TextStyle(
              color: Colors.white, // 텍스트 색상 설정
              fontSize: 18, // 텍스트 크기 설정
            ),
          ),
        ),
      ),
      onTap: () async {
        if (validateAndSave()) {
          setState(() {
            isApiCallProcess = true;
          });
          try {
            // 로그인 API 호출
            final model = LoginRequestModel(userid: userId, password: password);
            final result = await SessionService.login(model);

            if (result.value != null) {
              savePreferences();
              final userProfileResult = await UserService.getUserProfile();
              print("Here is LoginPage : ${userProfileResult.value}");
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyMenuScreen(),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('로그인에 실패하였습니다. 이메일과 비밀번호를 다시 확인해주세요.'),
                ),
              );
            }
          } finally {
            setState(() {
              isApiCallProcess = false;
            });
          }
        }
      },
    );
  }

  // OR 텍스트
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
                  color: secondaryColor,
                  fontWeight: FontWeight.bold,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    // Navigator.pushNamed(context, '/user/login');
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignupScreen()),
                    );
                  },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 입력 유효성 검사
  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}