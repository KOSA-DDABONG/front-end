import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:front/dto/signup/signup_request_model.dart';
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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0), // Default height
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth <= 800) {
              return ShortHeader(
                automaticallyImplyLeading: false,
              );
            } else {
              return NotLoginHeader(
                automaticallyImplyLeading: false,
                context: context,
              );
            }
          },
        ),
      ),
      drawer: NotLoginHeaderDrawer(),
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
                child:  _registerUI(context),
              )
            )
          ),
        ],
      ),
    );
  }

  //회원가입 페이지 UI
  Widget _registerUI(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 200, vertical: 30),
      child: Column(
        children: <Widget>[
          const SizedBox(height: 60),
          _titleUI(),
          const SizedBox(height: 50),
          _buildUsernameField(),
          const SizedBox(height: 30),
          _buildEmailField(),
          const SizedBox(height: 30),
          _buildNumberField(),
          const SizedBox(height: 30),
          _buildBirthField(),
          const SizedBox(height: 30),
          _buildNicknameField(),
          const SizedBox(height: 30),
          _buildUserIdField(),
          const SizedBox(height: 30),
          _buildPasswordField(),
          _buildPasswordCheckField(),
          const SizedBox(height: 80),
          _buildRegisterButton(),
          const SizedBox(height: 50),
          _buildOrText(),
          const SizedBox(height: 30),
          _buildLoginText(),
          const SizedBox(height: 100),
        ],
      ),
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
                birthDate = "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
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
                hintText: birthDate ?? "생년월일을 선택하세요.",
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

                // if (result.value != null) {
                if (result.value == "Success") {
                  showCustomSnackBar(context, '가입이 완료되었습니다.');
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                } else {
                  showCustomSnackBar(context, '회원가입에 실패하였습니다. 다시 시도해주세요.');
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