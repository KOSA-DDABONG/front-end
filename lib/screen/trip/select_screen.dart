import 'package:flutter/material.dart';

import '../../component/header/header.dart';

class SelectScreen extends StatefulWidget {
  const SelectScreen({Key? key}) : super(key: key);

  @override
  _SelectScreenState createState() => _SelectScreenState();
}

class _SelectScreenState extends State<SelectScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AfterLoginHeader(
        automaticallyImplyLeading: false,
        context: context,
      ),
      body: Text('여행 선택지 페이지')
    );
  }
}