import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
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
  String? _imageUrl;  // 웹 플랫폼용 이미지 URL
  File? _image;      // 모바일/데스크톱 플랫폼용 이미지 파일

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MenuAppController>().setSelectedScreen('myEdit');
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
                      children: [
                        ElevatedButton(
                          onPressed: _getImage,
                          child: Text('이미지 변경'),
                        ),
                        Text(
                          '프로필 이미지 참고사항\n최소한 400 x 400px 이상 / 파일 크기 2MB 미만',
                          textAlign: TextAlign.center,
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
          ProfileEditFormField(
            label: '전화번호',
            hint: '{010-0000-0000} 전화번호만 변경가능',
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
