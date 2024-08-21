import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:front/component/dialog/delete_account_dialog.dart';
import 'package:front/responsive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import '../../component/dialog/edit_number_dialog.dart';
import '../../component/dialog/edit_pwd_dialog.dart';
import '../../component/mypage/date_format.dart';
import '../../component/mypage/my_title.dart';
import '../../component/mypage/phone_number_format.dart';
import '../../component/mypage/profile_form_field.dart';
import '../../component/snack_bar.dart';
import '../../controller/check_login_state.dart';
import '../../controller/my_menu_controller.dart';
import '../../dto/user/login/login_response_model.dart';
import '../../service/session_service.dart';

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
  File? _image; //모바일 or 데스크톱 플랫폼용 이미지 파일
  String? password;
  String? checkpassword;

  bool _isLoading = true;
  bool _loginState = false;
  LoginResponseModel? _userinfo = null;

  @override
  void initState() {
    super.initState();
    _checkLoginUserInfo();
    _startLoadingTimeout();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MyMenuController>().setSelectedScreen('myEdit');
    });
  }

  void _startLoadingTimeout() {
    Future.delayed(const Duration(seconds: 5), () {
      if (_isLoading) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  Future<void> _checkLoginUserInfo() async {
    bool isLoggedIn = await checkLoginState(context);
    if (isLoggedIn) {
      setState(() {
        _loginState = isLoggedIn;
      });

      try {
        final usermodel = await SessionService.loginDetails();
        if (usermodel!=null) { //유저정보 로드 성공
          setState(() {
            _userinfo = usermodel;
            _isLoading = false;
          });
        }
        else {
          setState(() {
            _isLoading = false;
          });
        }
      }
      catch (e) {
        setState(() {
          _isLoading = false;
        });
        showCustomSnackBar(context, '문제가 발생했습니다. 잠시 후 다시 시도해주세요.');
      }
    }
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
    if(_loginState) {
      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ProgressHUD(
            inAsyncCall: isApiCallProcess,
            opacity: 0.3,
            key: UniqueKey(),
            child: Form(
              key: globalFormKey,
              child: Responsive.isNarrowWidth(context)
                  ? profileEditNarrowUI(context)
                  : profileEditWideUI(context),
            ),
          ),
        ),
      );
    }
    else {
      if (_isLoading) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          ),
        );
      }
      else{
        return Scaffold(
          body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _notLoginEditUI()
          ),
        );
      }
    }
  }

  //로그인X
  Widget _notLoginEditUI() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          showTitle('내 정보 수정'),
          const SizedBox(height: 200),
          const Center(
            child: Text(
              '데이터를 불러올 수 없습니다.',
            ),
          ),
          const SizedBox(height: 200),
        ],
      ),
    );
  }

  //프로필 수정 페이지 UI(좁은 화면)
  Widget profileEditNarrowUI(BuildContext context) {
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
                child: ProfileFormNarrowField(
                  label: '이름',
                  value: '${_userinfo?.username}',
                ),
              ),
              const SizedBox(width: 50),
              Expanded(
                child: ProfileFormNarrowField(
                  label: '이메일',
                  value: '${_userinfo?.email}',
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ProfileFormNarrowField(
                  label: '전화번호',
                  value: formatPhoneNumber('${_userinfo?.phoneNumber}'),
                  withEditButton: true,
                  onEdit: () => showEditNumberDialog(context, formatPhoneNumber('${_userinfo?.phoneNumber}')),
                ),
              ),
              const SizedBox(width: 50),
              Expanded(
                child: ProfileFormNarrowField(
                  label: '생년월일',
                  value: changeDateFormat('${_userinfo?.birth}'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ProfileFormNarrowField(
                  label: '닉네임',
                  value: '${_userinfo?.nickname}',
                ),
              ),
              const SizedBox(width: 50),
              Expanded(
                child: ProfileFormNarrowField(
                  label: '아이디',
                  value: '${_userinfo?.userId}',
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

  //프로필 수정 페이지 UI(넓은 화면)
  Widget profileEditWideUI(BuildContext context) {
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
                child: ProfileFormWideField(
                  label: '이름',
                  value: '${_userinfo?.username}',
                ),
              ),
              const SizedBox(width: 50),
              Expanded(
                child: ProfileFormWideField(
                  label: '이메일',
                  value: '${_userinfo?.email}',
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ProfileFormWideField(
                  label: '전화번호',
                  value: formatPhoneNumber('${_userinfo?.phoneNumber}'),
                  withEditButton: true,
                  onEdit: () => showEditNumberDialog(context, formatPhoneNumber('${_userinfo?.phoneNumber}')),
                ),
              ),
              const SizedBox(width: 50),
              Expanded(
                child: ProfileFormWideField(
                  label: '생년월일',
                  value: changeDateFormat('${_userinfo?.birth}'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ProfileFormWideField(
                  label: '닉네임',
                  value: '${_userinfo?.nickname}',
                ),
              ),
              const SizedBox(width: 50),
              Expanded(
                child: ProfileFormWideField(
                  label: '아이디',
                  value: '${_userinfo?.userId}',
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
      '* 프로필 이미지 참고사항\n* 파일 크기 2MB 미만',
      textAlign: TextAlign.left,
      style: TextStyle(color: Colors.grey),
    );
  }

  //서브 타이틀 텍스트 UI
  Widget _subTitleTextUI(String subtitle) {
    return Text(
      subtitle,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
            size: 20,
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
            size: 20,
          ),
        )
      ],
    );
  }
}