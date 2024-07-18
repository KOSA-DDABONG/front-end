import 'package:flutter/material.dart';
import 'package:front/component/my_menu.dart';
import 'package:front/screen/start/signup_screen.dart';
import 'package:front/screen/start/landing_screen.dart';
import 'package:google_fonts/google_fonts.dart';

import '../screen/start/login_screen.dart';

class notLoginHeader extends AppBar {
  notLoginHeader({Key? key, required bool automaticallyImplyLeading, BuildContext? context})
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
                // Add navigation logic here
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
                //
              },
              child: Text(
                'MY TRIP',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                //
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
                //
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

class afterLoginHeader extends AppBar {
  afterLoginHeader({Key? key, required bool automaticallyImplyLeading, BuildContext? context})
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
                // Add navigation logic here
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
                // Add navigation logic here
              },
              child: Text(
                'MY TRIP',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                // Add navigation logic here
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
                // Add navigation logic here
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