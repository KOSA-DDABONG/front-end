import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controller/my_menu_controller.dart';


class MyTripScheduleScreen extends StatefulWidget {
  const MyTripScheduleScreen({Key? key}) : super(key: key);

  @override
  _MyTripScheduleScreenState createState() => _MyTripScheduleScreenState();
}

class _MyTripScheduleScreenState extends State<MyTripScheduleScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MyMenuController>().setSelectedScreen('mySchedule');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _myScheduleUI(context),
      ),
    );
  }

  Widget _myScheduleUI(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '나의 일정',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _myScheduleUIMobile(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: _myScheduleUI(context),
    );
  }

  Widget _myScheduleUITablet(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 60),
      child: _myScheduleUI(context),
    );
  }

  Widget _myScheduleUIDesktop(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 80),
        width: MediaQuery.of(context).size.width / 2,
        child: _myScheduleUI(context),
      ),
    );
  }

}