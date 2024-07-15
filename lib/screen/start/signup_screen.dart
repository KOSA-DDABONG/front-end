import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:front/dto/signup/signup_request_model.dart';
import 'package:front/responsive.dart';
import 'package:front/service/user_service.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';

import '../../config.dart';
import '../../constants.dart';
import '../../widget/header.dart';
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
  String? birthDate;
  String? phoneNumber;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: notLoginHeader(
        automaticallyImplyLeading: false,
        context: context,
      ),
        backgroundColor: Color(0xffe4f4ff),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProgressHUD(
              inAsyncCall: isApiCallProcess,
              opacity: 0.3,
              key: UniqueKey(),
              child: Form(
                key: globalFormKey,
                child: Responsive(
                  mobile: _registerUIMobile(context),
                  tablet: _registerUITablet(context),
                  desktop: _registerUIDesktop(context),
                ),
              ),
            ),
          ],
        ),
      )
    );
  }

  Widget _registerUIMobile(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 1.5,
          child: _registerUI(context),
        ),
      ),
    );
  }

  Widget _registerUITablet(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 60),
      child: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 1.6,
          child: _registerUI(context),
        ),
      ),
    );
  }

  Widget _registerUIDesktop(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 80),
          height: MediaQuery.of(context).size.height * 1.8,
          width: MediaQuery.of(context).size.width / 2,
          child: _registerUI(context),
        ),
      ),
    );
  }

  // 로그인 UI
  Widget _registerUI(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 50),
        _buildUsernameField(),
        _buildEmailField(),
        _buildNumberField(),
        _buildBirthField(),
        _buildNicknameField(),
        _buildUserIdField(),
        _buildPasswordField(),
        _buildPasswordCheckField(),
        const SizedBox(height: 50),
        _buildRegisterButton(),
        const SizedBox(height: 50),
        _buildOrText(),
        const SizedBox(height: 30),
        _buildLoginText(),
        const SizedBox(height: 100),
      ],
    );
  }

  //이름 필드
  Widget _buildUsernameField() {
    return Flexible(
      child: Column(
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
          const SizedBox(height: 5), // 제목과 입력 필드 사이의 간격 조절
          TextFormField(
            validator: (val) {
              if (val!.isEmpty) {
                return '사용자 이름이 입력되지 않았습니다.';
              } else if (!isNicknameValid(val)) {
                return '형식을 확인해주세요.';
              }
              return null;
            },
            onChanged: (val) => username = val,
            obscureText: false,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              hintText: "이름을 입력하세요. ex)홍길동",
              hintStyle: TextStyle(color: Colors.grey.withOpacity(0.7)),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: secondaryColor, // Change the color as needed
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 이메일 필드
  Widget _buildEmailField() {
    return Flexible(
      child: Column(
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
          const SizedBox(height: 5), // 제목과 입력 필드 사이의 간격 조절
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  validator: (val) => val!.isEmpty ? '이메일이 입력되지 않았습니다.' : null,
                  onChanged: (val) => email = val,
                  obscureText: false,
                  style: const TextStyle(color: Colors.black),
                  enabled: verifyEmailSuccess != 1,
                  // 이메일 인증 성공 시에만 수정 불가능하도록 설정
                  decoration: InputDecoration(
                    hintText: "이메일을 입력하세요.",
                    hintStyle: TextStyle(color: Colors.grey.withOpacity(0.7)),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: secondaryColor, // Change the color as needed
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Add some spacing between the TextFormField and the button
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
                    backgroundColor: Colors.white,
                    // Set button background color to orange
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      // Set button border radius
                      side: const BorderSide(
                          color: secondaryColor// Set button border color to orange
                      ),
                    ),
                  ),
                  child: const Text(
                    '인증',
                    style: TextStyle(fontSize: 18, color: secondaryColor),
                  ),
                ),
              ),
            ],
          ),
          // if (verifyEmailSuccess == 1)
          //   const Padding(
          //     padding: EdgeInsets.only(top: 8.0),
          //     child: Text(
          //       '이메일 인증이 완료되었습니다.',
          //       style: TextStyle(color: Colors.green),
          //     ),
          //   )
          // else if (verifyEmailSuccess == 2)
          //   const Padding(
          //     padding: EdgeInsets.only(top: 8.0),
          //     child: Text(
          //       '이메일 인증에 실패했습니다.',
          //       style: TextStyle(color: Colors.red),
          //     ),
          //   )
        ],
      ),
    );
  }

  // //인증코드 입력 다이어로그
  // void showVerificationDialog() {
  //   TextEditingController verificationCodeController = TextEditingController();
  //   int timerDuration = 5 * 60;
  //   int currentTimerValue = timerDuration;
  //
  //   StreamController<int> timerStreamController = StreamController<int>();
  //
  //   void resetTimer() {
  //     currentTimerValue = timerDuration;
  //     timerStreamController.add(currentTimerValue);
  //   }
  //
  //   // Start the countdown
  //   Timer.periodic(const Duration(seconds: 1), (timer) {
  //     if (currentTimerValue == 0) {
  //       timer.cancel();
  //       timerStreamController.close();
  //     } else {
  //       timerStreamController.add(currentTimerValue);
  //       currentTimerValue--;
  //     }
  //   });
  //
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Dialog(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(10),
  //         ),
  //         child: Container(
  //           width: 300, // Set the width as per your requirement
  //           padding: const EdgeInsets.all(16),
  //           child: StreamBuilder<int>(
  //             initialData: currentTimerValue, // Start from the full duration
  //             stream: timerStreamController.stream,
  //             builder: (context, snapshot) {
  //               bool isCodeMatched =
  //               (verificationCodeController.text == expectedToken);
  //
  //               return Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   const Text(
  //                     "인증코드를 입력하세요",
  //                     style: TextStyle(
  //                       fontSize: 20,
  //                     ),
  //                   ),
  //                   const SizedBox(height: 10),
  //                   TextField(
  //                     controller: verificationCodeController,
  //                     decoration: const InputDecoration(labelText: '인증코드'),
  //                   ),
  //                   if (!isCodeMatched &&
  //                       verificationCodeController.text.isNotEmpty)
  //                     const Padding(
  //                       padding: EdgeInsets.only(top: 8.0),
  //                       child: Text(
  //                         "인증 코드가 일치하지 않습니다",
  //                         style: TextStyle(color: Colors.red),
  //                       ),
  //                     ),
  //                   const SizedBox(height: 10),
  //                   Text(
  //                     "남은 시간: ${(snapshot.data ?? 0) ~/ 60}:${(snapshot.data ?? 0) % 60}",
  //                     style: const TextStyle(fontSize: 16),
  //                   ),
  //                   const SizedBox(height: 16),
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                     children: [
  //                       TextButton(
  //                         onPressed: () {
  //                           resetTimer();
  //                         },
  //                         child: const Text("재전송"),
  //                       ),
  //                       TextButton(
  //                         onPressed: () async {
  //                           if (isCodeMatched) {
  //                             timerStreamController.close();
  //                             Navigator.of(context).pop();
  //                             try {
  //                               final tokenResponse = await UserService
  //                                   .emailVerifyTokenRequest(
  //                                   verificationCodeController.text);
  //                               if (tokenResponse.statusCode == 200) {
  //                                 setState(() {
  //                                   verifyEmailSuccess = 1;
  //                                 });
  //                               } else {
  //                                 setState(() {
  //                                   verifyEmailSuccess = 2;
  //                                 });
  //                               }
  //                             } catch (e) {
  //                               // 에러가 발생한 경우
  //                               print("Error: $e");
  //                               setState(() {
  //                                 verifyEmailSuccess = 2;
  //                               });
  //                             }
  //                           }
  //                         },
  //                         child: const Text("확인"),
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               );
  //             },
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  //전화번호 필드
  Widget _buildNumberField() {
    return Flexible(
      child: Column(
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
          const SizedBox(height: 5), // 제목과 입력 필드 사이의 간격 조절
          TextFormField(
            validator: (val) {
              if (val!.isEmpty) {
                return '전화번호가 입력되지 않았습니다.';
              } else if (!isValidPhoneNumber(val)) {
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
                  color: secondaryColor,// Change the color as needed
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //생년월일 필드
  Widget _buildBirthField() {
    return Flexible(
      child: Column(
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
              );
              if (pickedDate != null) {
                setState(() {
                  birthDate = "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                  isBirthSelected = true;  // 날짜가 선택되었음을 표시
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
                  hintText: birthDate ?? "생년월일을 선택하세요.",
                  hintStyle: TextStyle(
                    color: isBirthSelected ? Colors.black : Colors.grey.withOpacity(0.7),  // 텍스트 색상 설정
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: secondaryColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //닉네임 필드
  Widget _buildNicknameField() {
    return Flexible(
      child: Column(
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
          const SizedBox(height: 5), // 제목과 입력 필드 사이의 간격 조절
          TextFormField(
            validator: (val) {
              if (val!.isEmpty) {
                return '닉네임이 입력되지 않았습니다.';
              } else if (!isNicknameValid(val)) {
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
                  color: secondaryColor, // Change the color as needed
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //아이디 필드
  Widget _buildUserIdField() {
    return Flexible(
      child: Column(
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
          const SizedBox(height: 5), // 제목과 입력 필드 사이의 간격 조절
          TextFormField(
            validator: (val) {
              if (val!.isEmpty) {
                return '아이디가 입력되지 않았습니다.';
              } else if (!isNicknameValid(val)) {
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
                  color: secondaryColor, // Change the color as needed
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 비밀번호 필드
  Widget _buildPasswordField() {
    return Flexible(
      child: Column(
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
                    : secondaryColor,
                icon: Icon(
                  hidePassword ? Icons.visibility_off : Icons.visibility,
                  color: hidePassword
                      ? Colors.grey.withOpacity(0.7)
                      : secondaryColor,
                ),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: secondaryColor, // Change the color as needed
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 비밀번호 확인 필드
  Widget _buildPasswordCheckField() {
    return Flexible(
      child: Column(
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
                  color: secondaryColor, // Change the color as needed
                ),
              ),
              // focusedBorder: OutlineInputBorder(
              //   borderRadius: BorderRadius.circular(10),
              //   borderSide: BorderSide(
              //     color: Color(0xffd86a04), // 클릭 시 테두리 색상 변경
              //   ),
              // ),
            ),
          ),
        ],
      ),
    );
  }

  // 회원가입 버튼
  Widget _buildRegisterButton() {
    double screenWidth = MediaQuery.of(context).size.width;

    return InkWell(
      child: Container(
        width: screenWidth, // 원하는 너비 설정
        height: 50, // 원하는 높이 설정
        decoration: BoxDecoration(
          color: secondaryColor, // 버튼 배경색 설정
          borderRadius: BorderRadius.circular(10.0), // 원하는 모양 설정
        ),
        child: const Center(
          child: Text(
            "등록하기",
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

          SignupRequestModel model = SignupRequestModel(
            username: username,
            nickname: nickname,
            userId: userId,
            password: password,
            email: email,
            phoneNumber: phoneNumber,
            birth: birthDate
          );

          UserService.register(model).then(
                (result) {
              setState(() {
                isApiCallProcess = false;
              });

              if (result.value != null) {
                // FormHelper.showSimpleAlertDialog(
                //   context,
                //   Config.appName,
                //   "가입이 완료되었습니다.",
                //   "확인",
                //       () {
                //     Future.delayed(const Duration(seconds: 1), () {
                //       Navigator.of(context).pop(); // Dismiss the dialog after a delay
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(builder: (context) => LoginScreen()),
                //       );
                //     });
                //   },
                // );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('가입이 완료되었습니다.'),
                  ),
                );
              } else {
                FormHelper.showSimpleAlertDialog(
                  context,
                  Config.appName,
                  "회원가입에 실패하였습니다. 입력하신 정보를 다시 확인해주세요.",
                  "확인",
                      () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                );
              }
            },
          );
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

  // 로그인 텍스트
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
                  color: secondaryColor,
                  fontWeight: FontWeight.bold,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    // Navigator.pushNamed(context, '/user/login');
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
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

  bool isValidPhoneNumber(String input) {
    final RegExp regex = RegExp(r'^010\d{8}$');
    return regex.hasMatch(input);
  }

  bool isNicknameValid(String nickname) {
    // return nickname.isNotEmpty && nickname.length <= 20;
    final RegExp validCharacters = RegExp(r'^[a-zA-Z가-힣0-9]+$');
    return nickname.isNotEmpty &&
        nickname.length <= 20 &&
        validCharacters.hasMatch(nickname);
  }
}
