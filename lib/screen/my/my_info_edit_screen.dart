import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:front/component/dialog/delete_account_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import '../../component/dialog/edit_number_dialog.dart';
import '../../component/dialog/edit_pwd_dialog.dart';
import '../../component/mypage/my_title.dart';
import '../../component/mypage/profile_form_field.dart';
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
  String? _imageUrl; //웹 플랫폼용 이미지 URL
  File? _image; //모바일or데스크톱 플랫폼용 이미지 파일
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
          _imageUrl = pickedFile.path; //웹 플랫폼에서는 URL 사용
        } else {
          _image = File(pickedFile.path); //모바일or데스크톱 플랫폼에서는 파일 사용
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
          inAsyncCall: isApiCallProcess,
          opacity: 0.3,
          key: UniqueKey(),
          child: Form(
            key: globalFormKey,
            child: profileEditUI(context),
          ),
        ),
      ),
    );
  }

  //프로필 수정 페이지 UI
  Widget profileEditUI(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          showTitle('내 정보 수정'),
          const SizedBox(height: 20),
          Row(
            children: [
              _profileImgUI(),
              const SizedBox(width: 20),
              _profileImgField(),
            ],
          ),
          const SizedBox(height: 40),
          Divider(color: Colors.grey[300],),
          const SizedBox(height: 20),
          _subTitleTextUI('회원 정보'),
          const SizedBox(height: 20),
          Divider(color: Colors.grey[300],),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ProfileFormField(
                  label: '이름',
                  value: '{이름}', // 실제 값으로 대체
                ),
              ),
              const SizedBox(width: 50),
              Expanded(
                child: ProfileFormField(
                  label: '이메일',
                  value: '{이메일}', // 실제 값으로 대체
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ProfileFormField(
                  label: '전화번호',
                  value: '{전화번호}', // 실제 값으로 대체
                  withEditButton: true,
                  onEdit: () => showEditNumberDialog(context),
                ),
              ),
              const SizedBox(width: 50),
              Expanded(
                child: ProfileFormField(
                  label: '생년월일',
                  value: '{생년월일}', // 실제 값으로 대체
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ProfileFormField(
                  label: '닉네임',
                  value: '{닉네임}', // 실제 값으로 대체
                ),
              ),
              const SizedBox(width: 50),
              Expanded(
                child: ProfileFormField(
                  label: '아이디',
                  value: '{아이디}', // 실제 값으로 대체
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Divider(color: Colors.grey[300],),
          const SizedBox(height: 20),
          _changePasswordField(),
          const SizedBox(height: 20),
          Divider(color: Colors.grey[300],),
          const SizedBox(height: 20),
          _deleteInfo(),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  //프로필 이미지
  Widget _profileImgUI() {
    return CircleAvatar(
      radius: 50,
      backgroundColor: Colors.grey[200],
      backgroundImage: _image == null && _imageUrl == null
          ? null
          : kIsWeb
          ? NetworkImage(_imageUrl!)
          : FileImage(_image!) as ImageProvider,
      child: _image == null && _imageUrl == null
          ? const Icon(Icons.person, size: 50)
          : null,
    );
  }

  //이미지 변경 필드
  Widget _profileImgField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _imgChangeBtn(),
        const SizedBox(height: 10,),
        _imgConditionText(),
      ],
    );
  }

  //이미지 변경 버튼
  Widget _imgChangeBtn() {
    return ElevatedButton(
      onPressed: _getImage,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
      ),
      child: const Text(
        '이미지 변경',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  //변경 이미지 조건 텍스트
  Widget _imgConditionText() {
    return const Text(
      '* 프로필 이미지 참고사항\n최소한 400 x 400px 이상 / 파일 크기 2MB 미만',
      textAlign: TextAlign.left,
      style: TextStyle(color: Colors.grey),
    );
  }

  //서브 타이틀 텍스트 UI
  Widget _subTitleTextUI(String subtitle) {
    return Text(
      subtitle,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  //비밀번호 변경 필드
  Widget _changePasswordField() {
    return Row(
      children: [
        _subTitleTextUI('비밀번호 변경'),
        IconButton(
          onPressed: () {
            showEditPasswordDialog(context);
          },
          icon: const Icon(
            Icons.edit,
            color: Colors.grey,
          ),
        )
      ],
    );
  }

  //회원탈퇴 필드
  Widget _deleteInfo() {
    return Row(
      children: [
        _subTitleTextUI('회원 탈퇴하기'),
        IconButton(
          onPressed: () {
            showDeleteAccountDialog(context);
          },
          icon: const Icon(
            Icons.delete_outline,
            color: Colors.grey,
          ),
        )
      ],
    );
  }
}