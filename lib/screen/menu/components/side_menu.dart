import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:front/constants.dart';
import 'package:provider/provider.dart';

import '../../../controller/menu_app_controller.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedScreen = context.watch<MenuAppController>().selectedScreen;
    final showSubMenu = context.watch<MenuAppController>().showSubMenu;

    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        children: [
          const DrawerHeader(
            // child: Image.asset("assets/images/logo.png", height: 20, width: 20,),
              child: Text(
                '마이페이지',
                style: TextStyle(fontSize: 20, color: secondaryColor),
              ),
          ),
          DrawerListTile(
            title: "개인 정보",
            svgSrc: "../assets/icons/menu_dashboard.svg",
            press: () {
              context.read<MenuAppController>().toggleSubMenu();
              context.read<MenuAppController>().setSelectedScreen('myInfo');
            },
            selected: showSubMenu,
            children: showSubMenu
                ? [
                    DrawerSubListTile(
                      title: "내 프로필",
                      selected: selectedScreen == 'myInfo',
                      press: () {
                        context.read<MenuAppController>().setSelectedScreen('myInfo');
                      },
                    ),
                    DrawerSubListTile(
                      title: "내 정보 수정",
                      selected: selectedScreen == 'myEdit',
                      press: () {
                        context.read<MenuAppController>().setSelectedScreen('myEdit');
                      },
                    ),
                  ]
                : [],
          ),
          DrawerListTile(
            title: "나의 일정",
            svgSrc: "../assets/icons/menu_tran.svg",
            press: () {
              context.read<MenuAppController>().setSelectedScreen('mySchedule');
            },
            selected: selectedScreen == 'mySchedule',
          ),
          DrawerListTile(
            title: "나의 후기",
            svgSrc: "../assets/icons/menu_doc.svg",
            press: () {
              context.read<MenuAppController>().setSelectedScreen('myReview');
            },
            selected: selectedScreen == 'myReview',
          ),
          DrawerListTile(
            title: "나의 좋아요",
            svgSrc: "../assets/icons/menu_task.svg",
            press: () {
              context.read<MenuAppController>().setSelectedScreen('myLikes');
            },
            selected: selectedScreen == 'myLikes',
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    required this.title,
    required this.svgSrc,
    required this.press,
    required this.selected,
    this.children = const [],
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;
  final bool selected;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.green),
        ),
        color: selected ? Colors.green : Colors.transparent,
      ),
      child: Column(
        children: [
          ListTile(
            onTap: press,
            horizontalTitleGap: 0.0,
            leading: SvgPicture.asset(
              svgSrc,
              colorFilter: ColorFilter.mode(
                  selected ? Colors.white : Colors.green, BlendMode.srcIn),
              height: 16,
            ),
            title: Text(
              title,
              style: TextStyle(
                  color: selected ? Colors.white : Colors.grey,
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal),
            ),
          ),
          // if (selected) ...children,
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: Column(
              children: selected ? children : [],
            ),
          ),
        ],
      ),
    );
  }
}


class DrawerSubListTile extends StatelessWidget {
  const DrawerSubListTile({
    Key? key,
    required this.title,
    required this.selected,
    required this.press,
  }) : super(key: key);

  final String title;
  final bool selected;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: 32.0), // add indent
      child: ListTile(
        onTap: press,
        horizontalTitleGap: 0.0,
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14, // make text smaller
            color: selected ? Colors.green : Colors.grey,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
