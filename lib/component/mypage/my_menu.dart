import 'package:flutter/material.dart';
import 'package:front/screen/my/my_info_edit_screen.dart';
import 'package:front/screen/my/my_info_screen.dart';
import 'package:front/screen/my/my_likes_list_screen.dart';
import 'package:front/screen/my/my_review_list_screen.dart';
import 'package:front/screen/my/my_trip_schedule_screen.dart';
import 'package:provider/provider.dart';

import '../../controller/login_state_for_header.dart';
import '../header/header.dart';
import '../../controller/my_menu_controller.dart';
import '../../responsive.dart';
import '../header/header_drawer.dart';
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

    return CheckLoginStateWidget(
        builder: (context, isLoggedIn) {
          PreferredSizeWidget currentAppBar;
          Widget? currentDrawer;
          if (isLoggedIn) {
            currentAppBar = Responsive.isNarrowWidth(context)
                ? ShortHeader(automaticallyImplyLeading: false)
                : AfterLoginHeader(automaticallyImplyLeading: false, context: context);
            currentDrawer = Responsive.isNarrowWidth(context)
                ? AfterLoginHeaderDrawer()
                : null;
          }
          else {
            currentAppBar = Responsive.isNarrowWidth(context)
                ? ShortHeader(automaticallyImplyLeading: false)
                : NotLoginHeader(automaticallyImplyLeading: false, context: context);
            currentDrawer = Responsive.isNarrowWidth(context)
                ? NotLoginHeaderDrawer()
                : null;
          }

          return Scaffold(
            appBar: currentAppBar,
            drawer: currentDrawer,
            body: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/banner.png',
                    width: screenWidth,
                    height: screenHeight * 1 / 6,
                    fit: BoxFit.fill,
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (Responsive.isWideWidth(context))
                          Expanded(
                            child: SideMenu(),
                          ),
                        Expanded(
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
    );
  }
}
