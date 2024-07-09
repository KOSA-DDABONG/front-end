import 'package:flutter/material.dart';

import '../../constants.dart';


class MyLikesListScreen extends StatefulWidget {
  const MyLikesListScreen({Key? key}) : super(key: key);

  @override
  _MyLikesListScreenState createState() => _MyLikesListScreenState();
}

class _MyLikesListScreenState extends State<MyLikesListScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Login', style: TextStyle(color: Colors.white),),
      //   backgroundColor: secondaryColor,
      // ),
      backgroundColor: bgColor,
      body: _myInfoUIMobile(context),
    );
  }

  Widget _myInfoUIMobile(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: _MyInfoUI(context),
    );
  }

  Widget _myInfoUITablet(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 60),
      child: _MyInfoUI(context),
    );
  }

  Widget _myInfoUIDesktop(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 80),
        width: MediaQuery.of(context).size.width / 2,
        child: _MyInfoUI(context),
      ),
    );
  }


  // 로그인 UI
  Widget _MyInfoUI(BuildContext context) {
    return Column(
      children: <Widget>[
        Text('my likes list'),
        const SizedBox(height: 100),
        // _buildInfoField(),
      ],
    );
  }

}