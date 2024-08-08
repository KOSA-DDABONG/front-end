import 'dart:js' as js;
import 'package:flutter/material.dart';
import 'package:front/component/mypage/my_menu.dart';
import 'package:front/screen/chat/chatbot_screen.dart';
import 'package:front/screen/contact/contact_screen.dart';
import 'package:front/screen/loading/creating_screen.dart';
import 'package:front/screen/my/my_info_screen.dart';
import 'package:front/screen/review/add_review_screen.dart';
import 'package:front/screen/review/all_review_screen.dart';
import 'package:front/screen/start/landing_screen.dart';
import 'package:front/screen/loading/loading_screen.dart';
import 'package:front/screen/trip/result_screen.dart';
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

  // 비동기적으로 JavaScript와 상호작용
  await Future.delayed(Duration.zero, () {
    // JavaScript의 loadGoogleMaps 함수 호출
    js.context.callMethod('loadGoogleMaps', [GOOGLE_MAP_KEY]);
  });
}


class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TripFlow',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: Colors.black),
        canvasColor: Colors.blue,
      ),
      home: LandingScreen(),
      // home: AddReviewScreen(),
      // home: MyMenuScreen(),
      // home: ChatbotScreen(),
      // home: AllReviewScreen(),
      // home: ResultScreen(),
      // home: LoadingScreen(),
      // home: CreatingScreen(),
    );
  }
}


