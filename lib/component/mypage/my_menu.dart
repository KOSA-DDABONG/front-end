import 'package:flutter/material.dart';
import 'package:front/screen/my/my_info_edit_screen.dart';
import 'package:front/screen/my/my_info_screen.dart';
import 'package:front/screen/my/my_likes_list_screen.dart';
import 'package:front/screen/my/my_review_list_screen.dart';
import 'package:front/screen/my/my_trip_schedule_screen.dart';
import 'package:provider/provider.dart';

import '../../controller/check_login_state.dart';
import '../header/header.dart';
import '../../controller/my_menu_controller.dart';
import '../../responsive.dart';
import '../header/header_drawer.dart';
import 'my_side_menu.dart';

class MyMenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return FutureBuilder<bool>(
      future: checkLoginState(context),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        bool isLoggedIn = snapshot.data ?? false;

        final Map<String, Widget> _screens = {
          'myEdit': MyInfoEditScreen(currentLoginState: isLoggedIn),
          'myInfo': MyInfoScreen(currentLoginState: isLoggedIn),
          'mySchedule': MyTripScheduleScreen(currentLoginState: isLoggedIn),
          'myReview': MyReviewListScreen(currentLoginState: isLoggedIn),
          'myLikes': MyLikesListScreen(currentLoginState: isLoggedIn),
        };

        PreferredSizeWidget currentAppBar;
        Widget? currentDrawer;
        if (isLoggedIn) {
          currentAppBar = Responsive.isNarrowWidth(context)
              ? ShortHeader(automaticallyImplyLeading: false)
              : AfterLoginHeader(automaticallyImplyLeading: false, context: context);
          currentDrawer = Responsive.isNarrowWidth(context)
              ? AfterLoginHeaderDrawer()
              : null;
        } else {
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
          body: (!isLoggedIn)
            ? SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                      flex: 2,
                      child: Container()
                  ),
                  const Expanded(
                      flex: 1,
                      child: Text('페이지에 접근할 수 없습니다.')
                  ),
                  Expanded(
                      flex: 2,
                      child: Container()
                  ),
                ],
              ),
            )
          : SafeArea(
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
                        const Expanded(
                          child: SideMenu(),
                        )
                      else
                        const SizedBox.shrink(),
                      Expanded(
                        flex: 5,
                        child: _screens[
                        context.watch<MyMenuController>().selectedScreen] ?? Container(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        );
      },
    );
  }
}

