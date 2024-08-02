import 'package:flutter/material.dart';

import '../../screen/contact/contact_screen.dart';
import '../../screen/review/all_review_screen.dart';
import '../../screen/start/landing_screen.dart';
import '../../screen/trip/create_trip_screen.dart';
import '../mypage/my_menu.dart';

class HeaderDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            title: Text('HOME'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LandingScreen()),
              );
            },
          ),
          ListTile(
            title: Text('TRIP'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateTripScreen()),
              );
            },
          ),
          ListTile(
            title: Text('REVIEW'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AllReviewScreen()),
              );
            },
          ),
          ListTile(
            title: Text('MY PAGE'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyMenuScreen()),
              );
            },
          ),
          ListTile(
            title: Text('CONTACT'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ContactScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
