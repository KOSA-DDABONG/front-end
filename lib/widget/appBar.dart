import 'package:flutter/material.dart';
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
    centerTitle: true, // This centers the title, but we'll adjust the layout further
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Image.asset(
              '../assets/images/tripflow_logo.png', // Update the path to your logo image
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
                // Add navigation logic here
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
        Row(
          children: [
            Image.asset(
              '../assets/images/tripflow_logo.png', // Update the path to your logo image
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
                // Add navigation logic here
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




class CommonAppBar extends AppBar {
  CommonAppBar({Key? key, required bool automaticallyImplyLeading, BuildContext? context})
      : super(
          key: key,
          backgroundColor: Color(0xffffecda),
          automaticallyImplyLeading: automaticallyImplyLeading,
          elevation: 0,
          centerTitle: false,
          title: const Text(
            "TripFlow",
            style: TextStyle(color: Color(0xffd86a04), fontWeight: FontWeight.bold),
          ),
          iconTheme: const IconThemeData(
            color: Color(0xffd86a04),
          ),
          leading: automaticallyImplyLeading == true
              ? IconButton(
                  onPressed: () => Navigator.of(context!).pop(true),
                  icon: Icon(Icons.arrow_back_ios),
                )
              : null
        );
}
//
// class RecCommonAppBar extends AppBar {
//   RecCommonAppBar({Key? key, required bool automaticallyImplyLeading, BuildContext? context})
//       : super(
//     key: key,
//     backgroundColor: Color(0xffffecda),
//     automaticallyImplyLeading: automaticallyImplyLeading,
//     elevation: 0,
//     centerTitle: false,
//     title: const Text(
//       "TripFlow",
//       style: TextStyle(color: Color(0xffd86a04), fontWeight: FontWeight.bold),
//     ),
//     iconTheme: const IconThemeData(
//       color: Color(0xffd86a04),
//     ),
//     leading: automaticallyImplyLeading == true
//         ? IconButton(
//       onPressed: () => Navigator.of(context!).pop(true),
//       icon: Icon(Icons.arrow_back_ios),
//     )
//         : null,
//     // 여기에 actions 속성 추가
//     actions: <Widget>[
//       IconButton(
//         icon: Icon(Icons.refresh),
//         onPressed: () {
//           Navigator.of(context!).pushReplacement(MaterialPageRoute(
//               builder: (context) => SplashScreen()));
//         },
//       ),
//     ],
//   );
// }
//
// class HomepageAppBar extends AppBar {
//   final List<Widget> actions;
//
//   HomepageAppBar({Key? key, required this.actions, bool automaticallyImplyLeading = false})
//       : super(
//     key: key,
//     automaticallyImplyLeading: automaticallyImplyLeading,
//     backgroundColor: Color(0xffffecda),
//     elevation: 0,
//     centerTitle: false,
//     title: const Text(
//       "TripFlow",
//       style: TextStyle(color: Color(0xffd86a04), fontWeight: FontWeight.bold),
//     ),
//     iconTheme: const IconThemeData(
//       color: Color(0xffd86a04),
//     ),
//     actions: actions,
//   );
// }
//
//
// class MyAppBar extends AppBar {
//   final VoidCallback? onBack;
//   final BuildContext context;
//
//   MyAppBar({Key? key, this.onBack, required this.context, bool automaticallyImplyLeading = false})
//       : super(
//     key: key,
//     automaticallyImplyLeading: automaticallyImplyLeading,
//     backgroundColor: Color(0xffffecda),
//     elevation: 0,
//     centerTitle: false,
//     title: const Text(
//       "TripFlow",
//       style: TextStyle(color: Color(0xffd86a04), fontWeight: FontWeight.bold),
//     ),
//     iconTheme: const IconThemeData(
//       color: Color(0xffd86a04),
//     ),
//     leading: IconButton(
//       onPressed: () {
//         if (onBack != null) {
//           onBack!();
//         } else {
//           Navigator.pop(context, true);
//         }
//       },
//       icon: Icon(Icons.arrow_back_ios),
//     ),
//   );
// }
//
//
// class UsualAppBar extends AppBar {
//
//   final String? text;
//   final VoidCallback? onAddPressed;
//   final VoidCallback? onMinusPressed;
//
//   UsualAppBar({Key? key, this.text, this.onAddPressed, this.onMinusPressed,})
//       : super(
//       key: key,
//       backgroundColor: Color(0xffffecda),
//       elevation: 0,
//       centerTitle: false,
//       title: text != null ?
//       Text(
//         text,
//         style: TextStyle(color: Color(0xffd86a04), fontWeight: FontWeight.bold),
//       )
//           : Text(
//         "TripFlow",
//         style: TextStyle(color: Color(0xffd86a04), fontWeight: FontWeight.bold),
//       ),
//       iconTheme: const IconThemeData(
//         color: Color(0xffd86a04),
//       ),
//       actions: [
//         if(onAddPressed != null)
//           IconButton(
//             icon: Icon(Icons.add, color: Color(0xffd86a04)),
//             onPressed: onAddPressed,
//           ),
//         if(onMinusPressed != null)
//           IconButton(
//             icon: Icon(Icons.remove, color: Color(0xffd86a04)),
//             onPressed: onMinusPressed,
//           ),
//       ]
//   );
// }
//
//
// class SearchAppBar extends AppBar {
//   final Widget title;
//   final VoidCallback? onBack;
//   final BuildContext context; // Add this line
//
//   SearchAppBar({Key? key, required this.title, this.onBack, required this.context})
//       : super(
//     key: key,
//     backgroundColor: Color(0xffffecda),
//     elevation: 0,
//     centerTitle: false,
//     title: title,
//     iconTheme: IconThemeData(
//       color: Color(0xffd86a04),
//     ),
//     leading: IconButton(
//       onPressed: () {
//         if (onBack != null) {
//           onBack!();
//         } else {
//           Navigator.pop(context, true);
//         }
//       },
//       icon: Icon(Icons.arrow_back_ios),
//     ),
//   );
// }
//
