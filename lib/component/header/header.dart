import 'package:flutter/material.dart';
import 'package:front/component/mypage/my_menu.dart';
import 'package:front/screen/contact/contact_screen.dart';
import 'package:front/screen/review/all_review_screen.dart';
import 'package:front/screen/start/signup_screen.dart';
import 'package:front/screen/start/landing_screen.dart';
import 'package:front/screen/trip/select_screen.dart';
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
                '../assets/images/tripflow_logo.png',
                height: 30,
                color: Color(0xFF003680),
              ),
              SizedBox(width: 5,),
              Text(
                'TripFlow',
                style: GoogleFonts.indieFlower(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF003680),
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
                  MaterialPageRoute(builder: (context) => SelectScreen()),
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
                backgroundColor: Colors.blue, // Background color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
              ),
              child: Text(
                'Login',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(width: 20),
          ],
        ),
      ],
    ),
    iconTheme: IconThemeData(
      color: Color(0xFF003680),
    ),
    leading: automaticallyImplyLeading == true
        ? IconButton(
      onPressed: () => Navigator.of(context!).pop(true),
      icon: Icon(Icons.arrow_back_ios),
    )
        : null,
  );
}

class NotLoginShortHeader extends StatelessWidget implements PreferredSizeWidget {
  final bool automaticallyImplyLeading;

  NotLoginShortHeader({Key? key, required this.automaticallyImplyLeading}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      key: key,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: automaticallyImplyLeading,
      elevation: 0,
      centerTitle: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Builder(
            builder: (context) {
              return IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LandingScreen()),
              );
            },
            child: Row(
              children: [
                Image.asset(
                  '../assets/images/tripflow_logo.png',
                  height: 30,
                  color: Color(0xFF003680),
                ),
                SizedBox(width: 5),
                Text(
                  'TripFlow',
                  style: GoogleFonts.indieFlower(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF003680),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
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
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Background color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(width: 20),
            ],
          ),
        ],
      ),
      iconTheme: IconThemeData(
        color: Color(0xFF003680),
      ),
      leading: automaticallyImplyLeading
          ? IconButton(
        onPressed: () => Navigator.of(context).pop(true),
        icon: Icon(Icons.arrow_back_ios),
      )
          : null,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class AfterLoginHeader extends AppBar {
  AfterLoginHeader({Key? key, required bool automaticallyImplyLeading, BuildContext? context})
      : super(
    key: key,
    backgroundColor: Colors.transparent,
    automaticallyImplyLeading: automaticallyImplyLeading,
    elevation: 0,
    centerTitle: true, // This centers the title, but we'll adjust the layout further
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
                '../assets/images/tripflow_logo.png',
                height: 30,
                color: Color(0xFF003680),
              ),
              SizedBox(width: 5,),
              Text(
                'TripFlow',
                style: GoogleFonts.indieFlower(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF003680),
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
                  MaterialPageRoute(builder: (context) => SelectScreen()),
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
                backgroundColor: Colors.blue, // Background color
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
      color: Color(0xFF003680),
    ),
    leading: automaticallyImplyLeading == true
        ? IconButton(
      onPressed: () => Navigator.of(context!).pop(true),
      icon: Icon(Icons.arrow_back_ios),
    )
        : null,
  );
}

class AfterLoginShortHeader extends StatelessWidget implements PreferredSizeWidget {
  final bool automaticallyImplyLeading;

  AfterLoginShortHeader({Key? key, required this.automaticallyImplyLeading}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      key: key,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: automaticallyImplyLeading,
      elevation: 0,
      centerTitle: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Builder(
            builder: (context) {
              return IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LandingScreen()),
              );
            },
            child: Row(
              children: [
                Image.asset(
                  '../assets/images/tripflow_logo.png',
                  height: 30,
                  color: Color(0xFF003680),
                ),
                SizedBox(width: 5),
                Text(
                  'TripFlow',
                  style: GoogleFonts.indieFlower(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF003680),
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
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
        ],
      ),
      iconTheme: IconThemeData(
        color: Color(0xFF003680),
      ),
      leading: automaticallyImplyLeading
          ? IconButton(
        onPressed: () => Navigator.of(context).pop(true),
        icon: Icon(Icons.arrow_back_ios),
      )
          : null,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}