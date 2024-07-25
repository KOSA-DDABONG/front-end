import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import '../../component/dialog/edit_number_dialog.dart';
import '../../component/dialog/edit_pwd_dialog.dart';
import '../../controller/my_menu_controller.dart';

class MyInfoEditScreen extends StatefulWidget {
  const MyInfoEditScreen({Key? key}) : super(key: key);

  @override
  _MyInfoEditScreenState createState() => _MyInfoEditScreenState();
}

class _MyInfoEditScreenState extends State<MyInfoEditScreen> {
  bool isApiCallProcess = false;
  bool hidePrevPassword = true;
  bool hidePassword = true;
  final GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  String? _imageUrl;  // 웹 플랫폼용 이미지 URL
  File? _image;      // 모바일/데스크톱 플랫폼용 이미지 파일
  String? password;
  String? checkpassword;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MyMenuController>().setSelectedScreen('myEdit');
    });
  }

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        if (kIsWeb) {
          _imageUrl = pickedFile.path;  // 웹 플랫폼에서는 URL 사용
        } else {
          _image = File(pickedFile.path);  // 모바일/데스크톱 플랫폼에서는 파일 사용
        }
      } else {
        print('이미지 선택이 취소되었습니다.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ProgressHUD(
          child: Form(
            key: globalFormKey,
            child: profileEditUI(context),
          ),
          inAsyncCall: isApiCallProcess,
          opacity: 0.3,
          key: UniqueKey(),
        ),
      ),
    );
  }

  Widget profileEditUI(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '내 정보 수정',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Center(
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: _image == null && _imageUrl == null
                          ? null
                          : kIsWeb
                          ? NetworkImage(_imageUrl!)
                          : FileImage(_image!) as ImageProvider,
                      child: _image == null && _imageUrl == null
                          ? Icon(Icons.person, size: 50)
                          : null,
                    ),
                    const SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ElevatedButton(
                          onPressed: _getImage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue, // Background color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                          ),
                          child: Text(
                            '이미지 변경',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        SizedBox(height: 10,),
                        Text(
                          '* 프로필 이미지 참고사항\n최소한 400 x 400px 이상 / 파일 크기 2MB 미만',
                          textAlign: TextAlign.left,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 40),
          ProfileFormField(
            label: '이름',
          ),
          SizedBox(height: 20),
          ProfileFormField(
            label: '이메일',
          ),
          SizedBox(height: 20),
          Row(
            children: [
              ProfileFormField(
                label: '전화번호',
              ),
              IconButton(
                onPressed: () {
                  showEditNumberDialog(context);
                },
                icon: Icon(
                  Icons.edit,         // 연필 모양 아이콘
                  color: Colors.grey, // 회색으로 설정
                ),
              )
            ],
          ),
          SizedBox(height: 20),
          ProfileFormField(
            label: '생년월일',
          ),
          SizedBox(height: 20),
          ProfileFormField(
            label: '닉네임',
          ),
          SizedBox(height: 20),
          ProfileFormField(
            label: '아이디',
          ),
          SizedBox(height: 20),
          Divider(
            color: Colors.grey[300],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Text(
                '비밀번호 변경',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () {
                  showEditPasswordDialog(context);
                },
                icon: Icon(
                  Icons.edit,         // 연필 모양 아이콘
                  color: Colors.grey, // 회색으로 설정
                ),
              )
            ],
          ),
          SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _buildPrevPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "현재 비밀번호",
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
          obscureText: hidePrevPassword,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            hintText: "비밀번호를 입력하세요.",
            hintStyle: TextStyle(color: Colors.grey.withOpacity(0.7)),
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  hidePrevPassword = !hidePrevPassword;
                });
              },
              color: hidePrevPassword
                  ? Colors.grey.withOpacity(0.7)
                  : Color(0xFF003680),
              icon: Icon(
                hidePrevPassword ? Icons.visibility_off : Icons.visibility,
                color: hidePrevPassword
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
      ],
    );
  }

  // 비밀번호 필드
  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "변경 비밀번호",
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
                  : Color(0xFF003680),
              icon: Icon(
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
      ],
    );
  }

  // 비밀번호 확인 필드
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
                color: Color(0xFF003680), // Change the color as needed
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ProfileFormField extends StatelessWidget {
  final String label;

  ProfileFormField({
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          '{'+label+'}',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}

class ProfileEditFormField extends StatelessWidget {
  final String label;
  final String hint;
  final String? validationMessage;
  final Color validationColor;

  ProfileEditFormField({
    required this.label,
    required this.hint,
    this.validationMessage,
    this.validationColor = Colors.red,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        TextField(
          decoration: InputDecoration(
            hintText: hint,
            border: UnderlineInputBorder(),
          ),
        ),
        if (validationMessage != null)
          Text(
            validationMessage!,
            style: TextStyle(color: validationColor),
          ),
      ],
    );
  }
}
