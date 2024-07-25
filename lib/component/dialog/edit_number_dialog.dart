import 'package:flutter/material.dart';

import '../snack_bar.dart';

void showEditNumberDialog(BuildContext context) {
  final TextEditingController phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0), // 모서리 둥글기 10으로 설정
            ),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.5, // 화면 가로 사이즈의 1/2로 설정
              decoration: BoxDecoration(
                color: Colors.white, // 배경색 흰색으로 설정
                borderRadius: BorderRadius.circular(10.0), // 모서리 둥글기 10으로 설정
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '전화번호 변경',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '현재 전화번호',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              '01000000000',
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      '변경할 전화번호',
                      style: TextStyle(fontSize: 15),
                    ),
                    SizedBox(height: 5),
                    Form(
                      key: _formKey,
                      child: TextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: '전화번호를 입력하세요.',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '변경할 사항이 입력되지 않았습니다.';
                          }
                          final regex = RegExp(r'^010\d{8}$');
                          if (!regex.hasMatch(value)) {
                            return '올바른 형식이 아닙니다.';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
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
                              if (_formKey.currentState!.validate()) {
                                Navigator.of(context).pop();
                                showCustomSnackBar(context, '전화번호가 변경되었습니다.');
                              }
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
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
