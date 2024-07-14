import 'package:flutter/material.dart';
import 'package:front/screen/menu/my_menu_screen.dart';
import 'package:front/screen/my/my_info_screen.dart';
import 'package:front/screen/start/login_screen.dart';
import 'package:front/screen/start/signup_screen.dart';
import 'package:front/screen/start/landing_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'constants.dart';
import 'controller/menu_app_controller.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => MenuAppController(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TripFlow',
      theme: ThemeData(
        scaffoldBackgroundColor: bgColor,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: Colors.black),
        canvasColor: secondaryColor,
      ),
      home: LandingScreen(),
      // home: MyMenuScreen(),
    );
  }
}
