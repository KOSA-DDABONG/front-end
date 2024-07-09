import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';

import '../../controller/menu_app_controller.dart';

class MyInfoEditScreen extends StatefulWidget {
  const MyInfoEditScreen({Key? key}) : super(key: key);

  @override
  _MyInfoEditScreenState createState() => _MyInfoEditScreenState();
}

class _MyInfoEditScreenState extends State<MyInfoEditScreen> {
  bool isApiCallProcess = false;
  bool hidePassword = true;
  final GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();

  bool isEmailVerified = false;
  String? expectedToken;
  int verifyEmailSucess = 0;
  // StreamController<int> verifyEmailStreamController = StreamController<int>();

  String? email;
  String? password;
  String? checkpassword;
  String? nickname;
  String? phoneNumber;

  @override
  void initState() {
    super.initState();
    // Set the selected screen to 'myInfo' when this screen is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MenuAppController>().setSelectedScreen('myEdit');
    });
  }

  File? _image;

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery); // 갤러리에서 이미지 선택

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
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
        child: Expanded(
          flex: 4,
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
      ),
    );
  }

  Widget profileEditUI(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '내 프로필',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[200],
                  child: Icon(Icons.person, size: 50),
                ),
                SizedBox(height: 10),
                //Error
                _image == null
                    ? Text('이미지를 선택해주세요.')
                    : Image.file(_image!), // 선택된 이미지 보여주기
                ElevatedButton(
                  onPressed: _getImage,
                  child: Text('이미지 변경'),
                ),

                SizedBox(height: 5),
                Text(
                  '프로필 이미지 참고사항\n최소한 400 x 400px 이상 / 파일 크기 2MB 미만',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
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
            // validationMessage: '중복된 닉네임 입니다.',
          ),
          SizedBox(height: 20),
          ProfileEditFormField(
            label: '전화번호',
            hint: '{010-0000-0000} 전화번호만 변경가능',
            // validationMessage: '사번 확인 완료',
            // validationColor: Colors.green,
          ),
          SizedBox(height: 20),
          ProfileFormField(
            label: '생년월일',
            // validationMessage: '사번 확인 완료',
            // validationColor: Colors.green,
          ),
          SizedBox(height: 20),
          ProfileFormField(
            label: '닉네임',
            // validationMessage: '사번 확인 완료',
            // validationColor: Colors.green,
          ),
          SizedBox(height: 20),
          ProfileFormField(
            label: '아이디',
            // validationMessage: '사번 확인 완료',
            // validationColor: Colors.green,
          ),
          SizedBox(height: 40),
          Text(
            '비밀번호 변경',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          ProfileEditFormField(
            label: '현재 비밀번호',
            hint: '현재 비밀번호',
          ),
          ProfileEditFormField(
            label: '변경 비밀번호',
            hint: '변경 비밀번호',
            validationMessage: '대소문자, 숫자, 특수문자, 9자 이상',
            validationColor: Colors.green,
          ),
          ProfileEditFormField(
            label: '변경 비밀번호 확인',
            hint: '변경 비밀번호 확인',
          ),
          SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () {},
              child: Text('수정 완료'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
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
        // TextField(
        //   decoration: InputDecoration(
        //     hintText: hint,
        //     border: UnderlineInputBorder(),
        //   ),
        // ),
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
