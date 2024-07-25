import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../component/header.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: afterLoginHeader(
        automaticallyImplyLeading: false,
        context: context,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 120),
              child: Text(
                '문의하기',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 120),
              child: Column(
                children: [
                  ContactFormField(hintText: '사용자 이름'),
                  ContactFormField(hintText: '사용자 이메일'),
                  ContactFormField(hintText: '제목'),
                  ContactFormField(hintText: '문의 내용', maxLines: 5),
                  SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        // Add your action here
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Color(0xFF005AA7), // Text color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // Button corner radius
                        ),
                        elevation: 0,
                      ),
                      child: Text('보내기'),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 120),
              child: Text(
                '찾아오시는 길',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 120),
              child: Text(
                '서울특별시 종로구 창경궁로 254',
                style: TextStyle(fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SNS',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.camera_alt),
                        onPressed: () {
                          // 인스타그램 URL 열기
                        },
                      ),
                      Text('https://instagram.com/yourprofile'),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.facebook),
                        onPressed: () {
                          // 페이스북 URL 열기
                        },
                      ),
                      Text('https://facebook.com/yourprofile'),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.alternate_email),
                        onPressed: () {
                          // 트위터 URL 열기
                        },
                      ),
                      Text('https://twitter.com/yourprofile'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ContactFormField extends StatelessWidget {
  final String hintText;
  final int maxLines;

  const ContactFormField({
    Key? key,
    required this.hintText,
    this.maxLines = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
