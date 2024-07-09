import 'package:flutter/material.dart';
import 'package:front/constants.dart';
import 'package:front/screen/my/my_info_edit_screen.dart';
import 'package:front/screen/my/my_info_screen.dart';
import 'package:front/screen/my/my_likes_list_screen.dart';
import 'package:front/screen/my/my_review_list_screen.dart';
import 'package:front/screen/my/my_trip_schedule_screen.dart';
import 'package:provider/provider.dart';

import '../../controller/menu_app_controller.dart';
import '../../responsive.dart';
import 'components/side_menu.dart';


class MyMenuScreen extends StatelessWidget {
  final Map<String, Widget> _screens = {
    'myEdit' : MyInfoEditScreen(),
    'myInfo' : MyInfoScreen(),
    'mySchedule' : MyTripScheduleScreen(),
    'myReview' : MyReviewListScreen(),
    'myLikes' : MyLikesListScreen(),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          title: const Text(
            '마이페이지',
            style: TextStyle(color: secondaryColor),
          ),
          backgroundColor: Colors.white,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4.0),
            child: Container(
              color: Colors.black,
              height: 1.0,
            ),
          ),
        ),
      ),
      // key: context.read<MenuAppController>().scaffoldKey,
      // drawer: SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screen
            if (Responsive.isDesktop(context))
              Expanded(
                child: SideMenu(),
              ),
            Expanded(
              // It takes 5/6 part of the screen
              flex: 5,
              //MenuAppController에서 시작페이지 변경 가능
              child:
              _screens[context.watch<MenuAppController>().selectedScreen] ??
                  Container(),
            ),
          ],
        ),
      ),
    );
  }
}