import 'package:flutter/material.dart';
import 'package:front/component/mypage/my_menu.dart';
import 'package:front/constants.dart';
import 'package:front/screen/contact/contact_screen.dart';
import 'package:front/screen/review/all_review_screen.dart';
import 'package:front/screen/start/signup_screen.dart';
import 'package:front/screen/start/landing_screen.dart';
import 'package:front/screen/trip/create_trip_screen.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../screen/start/login_screen.dart';

class NotLoginHeader extends AppBar {
  NotLoginHeader({Key? key, required bool automaticallyImplyLeading, BuildContext? context})
      : super(
    key: key,
    backgroundColor: Colors.transparent,
    automaticallyImplyLeading: automaticallyImplyLeading,
    elevation: 0,
    centerTitle: true,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context!,
              MaterialPageRoute(builder: (context) => LandingScreen()),
            );
          },
          child: Row(
            children: [
              Image.asset(
                'assets/images/tripflow_logo.png',
                height: 30,
                color: pointColor,
              ),
              const SizedBox(width: 5,),
              Text(
                'TripFlow',
                style: GoogleFonts.indieFlower(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: pointColor
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context!,
                  MaterialPageRoute(builder: (context) => LandingScreen()),
                );
              },
              child: Text(
                'HOME',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context!,
                  MaterialPageRoute(builder: (context) => CreateTripScreen()),
                );
              },
              child: Text(
                'TRIP',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context!,
                  MaterialPageRoute(builder: (context) => AllReviewScreen()),
                );
              },
              child: Text(
                'REVIEW',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context!,
                  MaterialPageRoute(builder: (context) => MyMenuScreen()),
                );
              },
              child: Text(
                'MY PAGE',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context!,
                  MaterialPageRoute(builder: (context) => ContactScreen()),
                );
              },
              child: Text(
                'CONTACT',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context!,
                  MaterialPageRoute(builder: (context) => SignupScreen()),
                );
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.blue),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
              ),
              child: Text(
                'Sign up',
                style: TextStyle(color: Colors.blue),
              ),
            ),
            SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context!,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
              ),
              child: Text(
                'Login',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 20),
          ],
        ),
      ],
    ),
    iconTheme: IconThemeData(
      color: pointColor,
    ),
    leading: automaticallyImplyLeading == true
        ? IconButton(
      onPressed: () => Navigator.of(context!).pop(true),
      icon: const Icon(Icons.arrow_back_ios),
    ) : null,
  );
}

class AfterLoginHeader extends AppBar {
  AfterLoginHeader({Key? key, required bool automaticallyImplyLeading, BuildContext? context})
      : super(
    key: key,
    backgroundColor: Colors.transparent,
    automaticallyImplyLeading: automaticallyImplyLeading,
    elevation: 0,
    centerTitle: true,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context!,
              MaterialPageRoute(builder: (context) => LandingScreen()),
            );
          },
          child: Row(
            children: [
              Image.asset(
                'assets/images/tripflow_logo.png',
                height: 30,
                color: pointColor,
              ),
              const SizedBox(width: 5,),
              Text(
                'TripFlow',
                style: GoogleFonts.indieFlower(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: pointColor,
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context!,
                  MaterialPageRoute(builder: (context) => LandingScreen()),
                );
              },
              child: Text(
                'HOME',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context!,
                  MaterialPageRoute(builder: (context) => CreateTripScreen()),
                );
              },
              child: Text(
                'TRIP',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context!,
                  MaterialPageRoute(builder: (context) => AllReviewScreen()),
                );
              },
              child: Text(
                'REVIEW',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context!,
                  MaterialPageRoute(builder: (context) => MyMenuScreen()),
                );
              },
              child: Text(
                'MY PAGE',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context!,
                  MaterialPageRoute(builder: (context) => ContactScreen()),
                );
              },
              child: Text(
                'CONTACT',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context!,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
              ),
              child: Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(width: 20),
          ],
        ),
      ],
    ),
    iconTheme: IconThemeData(
      color: pointColor,
    ),
    leading: automaticallyImplyLeading == true
        ? IconButton(
      onPressed: () => Navigator.of(context!).pop(true),
      icon: Icon(Icons.arrow_back_ios),
    ) : null,
  );
}

class ShortHeader extends StatelessWidget implements PreferredSizeWidget {
  final bool automaticallyImplyLeading;

  ShortHeader({Key? key, required this.automaticallyImplyLeading}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      key: key,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: automaticallyImplyLeading,
      elevation: 0,
      title: Row(
        children: [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LandingScreen()),
              );
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/tripflow_logo.png',
                  height: 30,
                  color: pointColor,
                ),
                SizedBox(width: 5),
                Text(
                  'TripFlow',
                  style: GoogleFonts.indieFlower(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: pointColor,
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
        ],
      ),
      iconTheme: IconThemeData(
        color: pointColor,
      ),
      leading: automaticallyImplyLeading
          ? IconButton(
        onPressed: () => Navigator.of(context).pop(true),
        icon: const Icon(Icons.arrow_back_ios),
      ) : null,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}