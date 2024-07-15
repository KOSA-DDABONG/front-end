import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:front/screen/menu/my_menu_screen.dart';
import 'package:front/screen/start/signup_screen.dart';
import 'package:front/service/session_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';

import '../../constants.dart';
import '../../dto/login/login_request_model.dart';
import '../../responsive.dart';
import '../../service/user_service.dart';
import '../../widget/header.dart';


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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: notLoginHeader(
        automaticallyImplyLeading: false,
        context: context,
      ),
      backgroundColor: Color(0xffe4f4ff),
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            top: 0,
            child: Opacity(
              opacity: 0.15, // 이미지를 연하게 설정
              child: Image.asset(
                '../assets/images/login_background.png',
                width: screenWidth/2,
                height: screenHeight * 2/3,
                fit: BoxFit.fill,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                ProgressHUD(
                  inAsyncCall: isApiCallProcess,
                  opacity: 0.3,
                  key: UniqueKey(),
                  child: Form(
                    key: globalFormKey,
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
        ],
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
        const SizedBox(height: 60),
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
        Center(
          child: Text(
            'TripFlow',
            style: GoogleFonts.indieFlower(
              fontSize: 50,
              fontWeight: FontWeight.bold,
              color: Color(0xFF003680),
            ),
          ),
        ),
        const SizedBox(height: 50),
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
                hasFocus ? Color(0xFF003680) : Colors.grey.withOpacity(0.7);
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
                      color: Color(0xFF003680), // Change the color as needed
                    ),
                  ),
                ),
              ),
            )),
      ],
    );
  }

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
              hasFocus ? Color(0xFF003680) : Colors.grey.withOpacity(0.7);
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
                        : Color(0xFF003680),
                  ),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFF003680), // Change the color as needed
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
          activeColor: Color(0xFF003680),
        ),
        const Text("아이디 기억하기"),
      ],
    );
  }

  // 로그인 버튼
  Widget _buildLoginButton(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;


    return Container(
      width: screenWidth,
      child: ElevatedButton(
        onPressed: () async {
          if (validateAndSave()) {
            setState(() {
              isApiCallProcess = true;
            });
            try {
              final model = LoginRequestModel(userid: userId, password: password);
              final result = await SessionService.login(model);

              if (result.value != null) {
                savePreferences();
                final userProfileResult = await UserService.getUserProfile();
                print("Here is LoginPage : ${userProfileResult.value}");

                setState(() {
                  isApiCallProcess = false;
                });

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyMenuScreen(),
                  ),
                );

              } else {
                setState(() {
                  isApiCallProcess = false;
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('로그인에 실패하였습니다. 이메일과 비밀번호를 다시 확인해주세요.'),
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
            //   finally {
            //   setState(() {
            //     isApiCallProcess = false;
            //   });
            // }
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
                  color: Color(0xFF003680),
                  fontWeight: FontWeight.bold,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
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