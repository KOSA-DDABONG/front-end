import 'package:flutter/material.dart';
import 'package:front/screen/my/my_info_edit_screen.dart';
import 'package:front/screen/my/my_info_screen.dart';
import 'package:front/screen/my/my_likes_list_screen.dart';
import 'package:front/screen/my/my_review_list_screen.dart';
import 'package:front/screen/my/my_trip_schedule_screen.dart';
import 'package:provider/provider.dart';

import '../header/header.dart';
import '../../controller/my_menu_controller.dart';
import '../../responsive.dart';
import 'my_side_menu.dart';

class MyMenuScreen extends StatelessWidget {
  final Map<String, Widget> _screens = {
    'myEdit': MyInfoEditScreen(),
    'myInfo': MyInfoScreen(),
    'mySchedule': MyTripScheduleScreen(),
    'myReview': MyReviewListScreen(),
    'myLikes': MyLikesListScreen(),
  };

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AfterLoginHeader(
          automaticallyImplyLeading: false,
          context: context,
        ),
      ),
      // key: context.read<MenuAppController>().scaffoldKey,
      // drawer: SideMenu(),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/banner.png',
              width: screenWidth,
              height: screenHeight * 1 / 5,
              fit: BoxFit.fill,
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (Responsive.isDesktop(context))
                    Expanded(
                      child: SideMenu(),
                    ),
                  Expanded(
                    // It takes 5/6 part of the screen
                    flex: 5,
                    //MenuAppController에서 시작페이지 변경 가능
                    child: _screens[
                    context.watch<MyMenuController>().selectedScreen] ??
                        Container(),
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
