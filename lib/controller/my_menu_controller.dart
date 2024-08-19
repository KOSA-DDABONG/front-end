import 'package:flutter/material.dart';

class MyMenuController extends ChangeNotifier {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  String _selectedScreen = 'myInfo';
  bool _showSubMenu = false;

  String get selectedScreen => _selectedScreen;
  bool get showSubMenu => _showSubMenu;

  void setSelectedScreen(String screen) {
    _selectedScreen = screen;
    if (screen == 'myInfo' || screen == 'myEdit') {
      _showSubMenu = true;
    } else {
      _showSubMenu = false;
    }
    notifyListeners();
  }

  void toggleSubMenu() {
    _showSubMenu = !_showSubMenu;
    notifyListeners();
  }

  void controlMenu() {
    if (!_scaffoldKey.currentState!.isDrawerOpen) {
      _scaffoldKey.currentState!.openDrawer();
    }
  }


}
