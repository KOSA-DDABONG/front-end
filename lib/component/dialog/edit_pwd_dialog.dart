import 'package:flutter/material.dart';

import '../snack_bar.dart';

void showEditPasswordDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // 모서리 둥글기
        ),
        child: Container(
          width: MediaQuery.of(context).size.width / 3, // 다이얼로그 넓이 설정
          decoration: BoxDecoration(
            color: Colors.white, // 배경색 흰색으로 설정
            borderRadius: BorderRadius.circular(10), // 컨테이너의 모서리 둥글기 설정
          ),
          child: _EditPasswordDialogContent(),
        ),
      );
    },
  );
}

class _EditPasswordDialogContent extends StatefulWidget {
  @override
  _EditPasswordDialogContentState createState() => _EditPasswordDialogContentState();
}

class _EditPasswordDialogContentState extends State<_EditPasswordDialogContent> {
  bool hidePrevPassword = true;
  bool hideNewPassword = true;
  bool hideConfirmPassword = true;
  String? currentPassword;
  String? newPassword;
  String? confirmPassword;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min, // 내용의 크기에 맞게 다이얼로그 높이 조정
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            '비밀번호 변경',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        _buildPasswordField(
          label: '현재 비밀번호',
          hint: '현재 비밀번호를 입력하세요',
          obscureText: hidePrevPassword,
          onChanged: (val) => currentPassword = val,
          toggleVisibility: () {
            setState(() {
              hidePrevPassword = !hidePrevPassword;
            });
          },
        ),
        SizedBox(height: 16),
        _buildPasswordField(
          label: '새 비밀번호',
          hint: '사용하실 비밀번호를 입력하세요',
          obscureText: hideNewPassword,
          onChanged: (val) => newPassword = val,
          toggleVisibility: () {
            setState(() {
              hideNewPassword = !hideNewPassword;
            });
          },
        ),
        SizedBox(height: 16),
        _buildPasswordField(
          label: '비밀번호 확인',
          hint: '비밀번호를 한번 더 입력하세요',
          obscureText: hideConfirmPassword,
          onChanged: (val) => confirmPassword = val,
          toggleVisibility: () {
            setState(() {
              hideConfirmPassword = !hideConfirmPassword;
            });
          },
        ),
        SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: Colors.blue, width: 1.0),
                    ),
                  ),
                  child: Text(
                    '취소',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    showCustomSnackBar(context, '비밀번호가 변경되었습니다.');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: Colors.blue, width: 1.0),
                    ),
                  ),
                  child: Text(
                    '변경',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildPasswordField({
    required String label,
    required String hint,
    required bool obscureText,
    required Function(String) onChanged,
    required VoidCallback toggleVisibility,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 5),
          TextFormField(
            onChanged: onChanged,
            obscureText: obscureText,
            decoration: InputDecoration(
              hintText: hint,
              suffixIcon: IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                  color: obscureText ? Colors.grey.withOpacity(0.7) : Color(0xFF003680),
                ),
                onPressed: toggleVisibility,
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF003680)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
