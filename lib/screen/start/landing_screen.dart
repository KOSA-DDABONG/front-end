import 'package:flutter/material.dart';
import 'package:front/screen/trip/create_trip_screen.dart';
import 'dart:ui' as ui;
import 'package:google_fonts/google_fonts.dart';

import '../../component/clipper/vertical_wave_clipper.dart';
import '../../component/header/header.dart';
import '../../constants.dart';

class LandingScreen extends StatefulWidget {
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double opacityLevel = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        opacityLevel = 1.0;
      });
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NotLoginHeader(
        automaticallyImplyLeading: false,
        context: context,
      ),
      extendBodyBehindAppBar: true,
      backgroundColor: subBackgroundColor,
      body: Stack(
        children: [
          _backgroundImgUI(),
          _contentUI(),
        ],
      ),
    );
  }

  //배경이미지
  Widget _backgroundImgUI() {
    return Positioned.fill(
      child: ClipPath(
        clipper: VerticalWaveClipper(),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: AnimatedOpacity(
            duration: Duration(seconds: 1),
            opacity: opacityLevel,
            child: ShaderMask(
              shaderCallback: (rect) {
                return LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.white,
                    Colors.transparent,
                  ],
                  stops: [0.3, 1.5],
                ).createShader(rect);
              },
              blendMode: BlendMode.dstOut,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('../assets/images/landing_background.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  //내용
  Widget _contentUI() {
    return AnimatedOpacity(
      duration: Duration(seconds: 1),
      opacity: opacityLevel,
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: SizedBox(),
                  ),
                  Expanded(
                    flex: 12,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _animationEffect(_titleUI()),
                        _animationEffect(_explainTextUI()),
                        SizedBox(height: 30),
                        _animationEffect(_createTripBtnUI()),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: SizedBox(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //타이틀
  Widget _titleUI() {
    return Text(
      'TripFlow',
      style: GoogleFonts.indieFlower(
        fontSize: 120,
        fontWeight: FontWeight.bold,
        color: pointColor
      ),
    );
  }

  //설명
  Widget _explainTextUI() {
    return Text(
      '설명을 추가하세요.',
      style: TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),
    );
  }

  //여행 일정 생성하기 버튼
  Widget _createTripBtnUI() {
   return ElevatedButton(
     onPressed: () {
       Navigator.push(
         context,
         MaterialPageRoute(builder: (context) => CreateTripScreen()),
       );
     },
     style: ElevatedButton.styleFrom(
       padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
       backgroundColor: Colors.blue,
     ),
     child: Text(
       '여행 일정 생성하기',
       style: TextStyle(
         fontSize: 18,
         color: Colors.white,
       ),
     ),
   );
  }

  //애니메이션 효과
  Widget _animationEffect(Widget widget) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset(-1.0, 0.0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Curves.easeOut,
        ),
      ),
      child: widget,
    );
  }
}
