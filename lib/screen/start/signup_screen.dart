import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:front/service/user_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';

import '../../component/backgroundImg/login_signup_background.dart';
import '../../component/header/header.dart';
import '../../component/header/header_drawer.dart';
import '../../component/snack_bar.dart';
import '../../component/validate/check_id_validate.dart';
import '../../component/validate/check_input_validate.dart';
import '../../component/validate/check_name_validate.dart';
import '../../component/validate/check_nickname_validate.dart';
import '../../component/validate/check_number_validate.dart';
import '../../constants.dart';
import '../../dto/user/signup/signup_request_model.dart';
import '../../responsive.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool isApiCallProcess = false;
  bool hidePassword = true;
  final GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();

  bool isBirthSelected = false;
  bool isEmailVerified = false;
  String? expectedToken;
  int verifyEmailSuccess = 0;
  StreamController<int> verifyEmailStreamController = StreamController<int>();

  String? username;
  String? email;
  String? userId;
  String? password;
  String? checkpassword;
  String? nickname;
  String? birth;
  String? birthDateText;
  String? phoneNumber;

  @override
  void initState() {
    super.initState();
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
                  ? _registerNarrowUI()
                  : _registerWideUI()
              )
            )
          ),
        ],
      ),
    );
  }

  //회원가입 페이지 UI(화면 좁을 때)
  Widget _registerNarrowUI() {
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
              _buildUsernameField(),
              const SizedBox(height: 35),
              _buildEmailField(),
              const SizedBox(height: 35),
              _buildNumberField(),
              const SizedBox(height: 35),
              _buildBirthField(),
              const SizedBox(height: 35),
              _buildNicknameField(),
              const SizedBox(height: 35),
              _buildUserIdField(),
              const SizedBox(height: 35),
              _buildPasswordField(),
              _buildPasswordCheckField(),
              const SizedBox(height: 60),
              _buildRegisterButton(),
              const SizedBox(height: 35),
              _buildOrText(),
              const SizedBox(height: 35),
              _buildLoginText(),
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

  //회원가입 페이지 UI(화면 넓을 때)
  Widget _registerWideUI() {
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
              _buildUsernameField(),
              const SizedBox(height: 35),
              _buildEmailField(),
              const SizedBox(height: 35),
              _buildNumberField(),
              const SizedBox(height: 35),
              _buildBirthField(),
              const SizedBox(height: 35),
              _buildNicknameField(),
              const SizedBox(height: 35),
              _buildUserIdField(),
              const SizedBox(height: 35),
              _buildPasswordField(),
              _buildPasswordCheckField(),
              const SizedBox(height: 60),
              _buildRegisterButton(),
              const SizedBox(height: 35),
              _buildOrText(),
              const SizedBox(height: 35),
              _buildLoginText(),
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

  //이름 입력란
  Widget _buildUsernameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "이름",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 5),
        TextFormField(
          validator: (val) {
            if (val!.isEmpty) {
              return '사용자 이름이 입력되지 않았습니다.';
            } else if (!checkNameValidate(val, globalFormKey)) {
              return '형식을 확인해주세요.';
            }
            return null;
          },
          onChanged: (val) => username = val,
          obscureText: false,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            hintText: "이름을 입력하세요. (한글/영어) ex)홍길동",
            hintStyle: TextStyle(color: Colors.grey.withOpacity(0.7)),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: pointColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  //이메일 입력란
  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "이메일",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                validator: (val) => val!.isEmpty ? '이메일이 입력되지 않았습니다.' : null,
                onChanged: (val) => email = val,
                obscureText: false,
                style: const TextStyle(color: Colors.black),
                enabled: verifyEmailSuccess != 1,
                decoration: InputDecoration(
                  hintText: "이메일을 입력하세요.",
                  hintStyle: TextStyle(color: Colors.grey.withOpacity(0.7)),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: pointColor,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Container(
              height: 40,
              child: ElevatedButton(
                onPressed: () async {
                //   try {
                //     final response =
                //     await UserService.emailVerifyRequest(email!);
                //     if (response.statusCode == 200) {
                //       expectedToken = response.data['token'];
                //       showVerificationDialog();
                //       print("TokenToken : $response");
                //     } else {
                //       print("TokenToken : $response");
                //       FormHelper.showSimpleAlertDialog(
                //         context,
                //         Config.appName,
                //         "인증코드 요청에 실패했습니다. 이미 등록된 이메일인지 확인해주세요.",
                //         "확인",
                //             () {
                //           Navigator.of(context, rootNavigator: true).pop();
                //         },
                //       );
                //     }
                //   } catch (e) {
                //     print("Error: $e");
                //     FormHelper.showSimpleAlertDialog(
                //       context,
                //       Config.appName,
                //       "인증코드 요청에 실패했습니다. 이미 등록된 이메일인지 확인해주세요.",
                //       "확인",
                //           () {
                //         Navigator.of(context, rootNavigator: true).pop();
                //       },
                //     );
                //   }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: const BorderSide(
                        color: pointColor
                    ),
                  ),
                ),
                child: const Text(
                  '인증',
                  style: TextStyle(fontSize: 15, color: pointColor),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  //전화번호 입력란
  Widget _buildNumberField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "전화번호",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 5),
        TextFormField(
          validator: (val) {
            if (val!.isEmpty) {
              return '전화번호가 입력되지 않았습니다.';
            } else if (!checkNumberValidate(val, globalFormKey)) {
              return '전화번호 형식을 확인해주세요. ex) 01011112222';
            }
            return null;
          },
          onChanged: (val) => phoneNumber = val,
          obscureText: false,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            hintText: "전화번호를 입력하세요. ('-' 없이 입력하세요.)",
            hintStyle: TextStyle(color: Colors.grey.withOpacity(0.7)),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: pointColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  //생년월일 입력란
  Widget _buildBirthField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "생년월일",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 5),
        GestureDetector(
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.light(
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
                birthDateText = "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                //두자리수 월
                if (pickedDate.month == 10 || pickedDate.month == 11 || pickedDate.month == 12) {
                  if(1<=pickedDate.day && pickedDate.day<=9) {
                    birth = "${pickedDate.year}${pickedDate.month}0${pickedDate.day}";
                  }
                  else {
                    birth = "${pickedDate.year}${pickedDate.month}${pickedDate.day}";
                  }
                }
                //한자리수 월
                else {
                  if(1<=pickedDate.day && pickedDate.day<=9) {
                    birth = "${pickedDate.year}0${pickedDate.month}0${pickedDate.day}";
                  }
                  else {
                    birth = "${pickedDate.year}0${pickedDate.month}${pickedDate.day}";
                  }
                }
                isBirthSelected = true;
              });
            }
          },
          child: AbsorbPointer(
            child: TextFormField(
              validator: (val) {
                if (!isBirthSelected) {
                  return '생년월일이 선택되지 않았습니다.';
                }
                return null;
              },
              decoration: InputDecoration(
                hintText: birthDateText ?? "생년월일을 선택하세요.",
                hintStyle: TextStyle(
                  color: isBirthSelected ? Colors.black : Colors.grey.withOpacity(0.7),  // 텍스트 색상 설정
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

  //닉네임 입력란
  Widget _buildNicknameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "닉네임",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 5),
        TextFormField(
          validator: (val) {
            if (val!.isEmpty) {
              return '닉네임이 입력되지 않았습니다.';
            } else if (!checkNicknameValidate(val, globalFormKey)) {
              return '닉네임 형식을 확인하세요.';
            }
            return null;
          },
          onChanged: (val) => nickname = val,
          obscureText: false,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            hintText: "사용하실 닉네임을 입력하세요. (한글, 영어, 숫자 조합)",
            hintStyle: TextStyle(color: Colors.grey.withOpacity(0.7)),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: pointColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  //아이디 입력란
  Widget _buildUserIdField() {
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
        TextFormField(
          validator: (val) {
            if (val!.isEmpty) {
              return '아이디가 입력되지 않았습니다.';
            } else if (!checkIdValidate(val, globalFormKey)) {
              return '아이디 형식을 확인해주세요.';
            }
            return null;
          },
          onChanged: (val) => userId = val,
          obscureText: false,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            hintText: "사용하실 아이디를 입력하세요. (영어, 숫자 조합)",
            hintStyle: TextStyle(color: Colors.grey.withOpacity(0.7)),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: pointColor,
              ),
            ),
          ),
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
          "비밀번호 입력",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 5),
        TextFormField(
          onChanged: (val) => password = val,
          validator: (val) => val!.isEmpty ? '비밀번호가 입력되지 않았습니다.' : null,
          obscureText: hidePassword,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            hintText: "비밀번호를 입력하세요.",
            hintStyle: TextStyle(color: Colors.grey.withOpacity(0.7)),
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  hidePassword = !hidePassword;
                });
              },
              color: hidePassword
                  ? Colors.grey.withOpacity(0.7)
                  : pointColor,
              icon: Icon(
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
      ],
    );
  }

  //비밀번호 확인 입력란
  Widget _buildPasswordCheckField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          onChanged: (val) => checkpassword = val,
          validator: (val) {
            if (val!.isEmpty) {
              return '비밀번호가 입력되지 않았습니다.';
            } else if (val != password) {
              return '비밀번호가 일치하지 않습니다.';
            }
            return null;
          },
          obscureText: hidePassword,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            hintText: "비밀번호를 한번 더 입력하세요.",
            hintStyle: TextStyle(color: Colors.grey.withOpacity(0.7)),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: pointColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  //등록 버튼
  Widget _buildRegisterButton() {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth,
      child: ElevatedButton(
        onPressed: () async {
          if (checkInputValidate(globalFormKey)) {
            setState(() {
              isApiCallProcess = true;
            });

            SignupRequestModel model = SignupRequestModel(
              username: username ?? '',
              nickname: nickname ?? '',
              userId: userId ?? '',
              password: password ?? '',
              email: email ?? '',
              phoneNumber: phoneNumber ?? '',
              birth: birth ?? ''
            );

            UserService.register(model).then(
                  (result) {
                setState(() {
                  isApiCallProcess = false;
                });

                // if (result.value != null) {
                if (result.value == "Success") {
                  showCustomSnackBar(context, '가입이 완료되었습니다.');
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                } else {
                  showCustomSnackBar(context, '회원가입에 실패하였습니다. 잠시 후 다시 시도해주세요.');
                }
              },
            );
          }
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          backgroundColor: Colors.blue,
        ),
        child: Text(
          '등록하기',
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

  //로그인 텍스트
  Widget _buildLoginText() {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.black, fontSize: 14.0),
            children: <TextSpan>[
              const TextSpan(text: '이미 등록된 계정이 있으신가요? '),
              TextSpan(
                text: '로그인 하기',
                style: const TextStyle(
                  color: pointColor,
                  fontWeight: FontWeight.bold,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
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