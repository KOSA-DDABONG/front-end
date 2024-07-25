import 'package:flutter/material.dart';
import 'package:front/component/sub_list_tile.dart';
import 'package:provider/provider.dart';

import '../controller/my_menu_controller.dart';
import 'my_list_tile.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedScreen = context.watch<MyMenuController>().selectedScreen;
    final showSubMenu = context.watch<MyMenuController>().showSubMenu;

    return Drawer(
      backgroundColor: Colors.transparent,
      child: ListView(
        children: [
          Container(
            height: 50, // 원하는 높이로 설정
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
              child:
                SizedBox(),
            ),
          ),
          DrawerListTile(
            title: "개인 정보",
            svgSrc: "../assets/icons/menu_dashboard.svg",
            press: () {
              context.read<MyMenuController>().toggleSubMenu();
              context.read<MyMenuController>().setSelectedScreen('myInfo');
            },
            selected: showSubMenu,
            children: showSubMenu
                ? [
                    DrawerSubListTile(
                      title: "내 프로필",
                      selected: selectedScreen == 'myInfo',
                      press: () {
                        context.read<MyMenuController>().setSelectedScreen('myInfo');
                      },
                    ),
                    DrawerSubListTile(
                      title: "내 정보 수정",
                      selected: selectedScreen == 'myEdit',
                      press: () {
                        context.read<MyMenuController>().setSelectedScreen('myEdit');
                      },
                    ),
                  ]
                : [],
          ),
          DrawerListTile(
            title: "나의 일정",
            svgSrc: "../assets/icons/menu_tran.svg",
            press: () {
              context.read<MyMenuController>().setSelectedScreen('mySchedule');
            },
            selected: selectedScreen == 'mySchedule',
          ),
          DrawerListTile(
            title: "나의 후기",
            svgSrc: "../assets/icons/menu_doc.svg",
            press: () {
              context.read<MyMenuController>().setSelectedScreen('myReview');
            },
            selected: selectedScreen == 'myReview',
          ),
          DrawerListTile(
            title: "나의 좋아요",
            svgSrc: "../assets/icons/menu_task.svg",
            press: () {
              context.read<MyMenuController>().setSelectedScreen('myLikes');
            },
            selected: selectedScreen == 'myLikes',
          ),
        ],
      ),
    );
  }
}