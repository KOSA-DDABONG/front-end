import 'dart:js' as js;
import 'package:flutter/material.dart';
import 'package:front/config.dart';
import 'package:front/screen/start/landing_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'controller/my_menu_controller.dart';
import 'key/key.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ChangeNotifierProvider(
      create: (context) => MyMenuController(),
      child: MyApp(),
    ),
  );

  //비동기적으로 JavaScript와 상호작용
  await Future.delayed(Duration.zero, () {
    //JavaScript의 loadGoogleMaps 함수 호출
    js.context.callMethod('loadGoogleMaps', [GOOGLE_MAP_KEY]);
  });
}


class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Config.appName,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: Colors.black),
        canvasColor: Colors.blue,
      ),
      // home: AddReviewScreen(),
      home: LandingScreen(),
      // home: CreatingScreen(),
    );
  }
}


