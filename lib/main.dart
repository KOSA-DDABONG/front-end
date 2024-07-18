import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:front/component/my_menu.dart';
import 'package:front/screen/my/my_info_screen.dart';
import 'package:front/screen/review/add_review_screen.dart';
import 'package:front/screen/start/login_screen.dart';
import 'package:front/screen/start/signup_screen.dart';
import 'package:front/screen/start/landing_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'constants.dart';
import 'controller/my_menu_controller.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // var naverMapApiKey = 'Wqc2BU96WJi2KiRvnF0DgmOqlo7HUA2QuiYuQOmf';
  // await NaverMapSdk.instance.initialize(
  //   clientId: naverMapApiKey,
  //   onAuthFailed: (ex) {
  //     debugPrint("********* 네이버맵 인증오류 : $ex *********");
  //   },
  // );
  runApp(
    ChangeNotifierProvider(
      create: (context) => MyMenuController(),
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
        scaffoldBackgroundColor: Colors.white,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: Colors.black),
        canvasColor: Colors.blue,
      ),
      // home: LandingScreen(),
      home: AddReviewScreen(),
    );
  }
}
