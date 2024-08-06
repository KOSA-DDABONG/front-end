import 'dart:js' as js;
import 'package:flutter/material.dart';
import 'package:front/component/mypage/my_menu.dart';
import 'package:front/screen/chat/chatbot_screen.dart';
import 'package:front/screen/contact/contact_screen.dart';
import 'package:front/screen/my/my_info_screen.dart';
import 'package:front/screen/review/add_review_screen.dart';
import 'package:front/screen/review/all_review_screen.dart';
import 'package:front/screen/start/login_screen.dart';
import 'package:front/screen/start/signup_screen.dart';
import 'package:front/screen/start/landing_screen.dart';
import 'package:front/screen/trip/loading_screen.dart';
import 'package:front/screen/trip/result_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'constants.dart';
import 'controller/my_menu_controller.dart';
import 'key.dart';

void main() async {
  runApp(
    ChangeNotifierProvider(
      create: (context) => MyMenuController(),
      child: MyApp(),
    ),
  );

  WidgetsFlutterBinding.ensureInitialized();

  // 비동기적으로 JavaScript와 상호작용
  await Future.delayed(Duration.zero, () {
    // JavaScript의 loadGoogleMaps 함수 호출
    js.context.callMethod('loadGoogleMaps', [mapApiKey]);
  });
}


class MyApp extends StatelessWidget {
  // const MyApp({super.key});

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
      // home: ContactScreen(),
      // home: AllReviewScreen(),
      // home: ResultScreen()
      // home: LoginScreen(),
      // home: LoadingScreen(),
    );
  }
}
