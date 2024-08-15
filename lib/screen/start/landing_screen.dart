import 'package:flutter/material.dart';
import 'package:front/controller/check_login_state.dart';
import 'package:front/responsive.dart';
import 'package:front/screen/trip/create_trip_screen.dart';
import 'dart:ui' as ui;
import 'package:google_fonts/google_fonts.dart';

import '../../component/clipper/vertical_wave_clipper.dart';
import '../../component/header/header.dart';
import '../../component/header/header_drawer.dart';
import '../../constants.dart';
import '../../service/session_service.dart';

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
      duration: const Duration(seconds: 1),
    );
    Future.delayed(const Duration(milliseconds: 500), () {
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
    return CheckLoginStateWidget(
      builder: (context, isLoggedIn) {
        PreferredSizeWidget currentAppBar;
        Widget? currentDrawer;
        if(isLoggedIn) {
          currentAppBar = Responsive.isNarrowWidth(context)
            ? ShortHeader(automaticallyImplyLeading: false)
            : AfterLoginHeader(automaticallyImplyLeading: false, context: context);
          currentDrawer = Responsive.isNarrowWidth(context)
            ? AfterLoginHeaderDrawer()
            : null;
        }
        else {
          currentAppBar = Responsive.isNarrowWidth(context)
            ? ShortHeader(automaticallyImplyLeading: false)
            : NotLoginHeader(automaticallyImplyLeading: false, context: context);
          currentDrawer = Responsive.isNarrowWidth(context)
            ? NotLoginHeaderDrawer()
            : null;
        }

        return Scaffold(
          appBar: currentAppBar,
          drawer: currentDrawer,
          extendBodyBehindAppBar: true,
          backgroundColor: subBackgroundColor,
          body: Responsive.isNarrowWidth(context)
              ? Stack(
            children: [
              _backgroundImgNarrowUI(),
              _contentNarrowUI()
            ],
          )
              : Stack(
            children: [
              _backgroundImgWideUI(),
              _contentWideUI()
            ],
          ),
        );
      }
    );
  }

  //배경이미지(좁은 화면)
  Widget _backgroundImgNarrowUI() {
    return Positioned.fill(
      child: ClipPath(
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: AnimatedOpacity(
            duration: const Duration(seconds: 1),
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
                    image: AssetImage('assets/images/landing_background.jpg'),
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

  //배경이미지(넓은 화면)
  Widget _backgroundImgWideUI() {
    return Positioned.fill(
      child: ClipPath(
        clipper: VerticalWaveClipper(),
        // clipper: HorizontalWaveClipper(),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: AnimatedOpacity(
            duration: const Duration(seconds: 1),
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
                    image: AssetImage('assets/images/landing_background.jpg'),
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

  //내용(좁은 화면)
  Widget _contentNarrowUI() {
    return AnimatedOpacity(
      duration: const Duration(seconds: 1),
      opacity: opacityLevel,
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _animationEffect(_titleNarrowUI()),
                      const SizedBox(height: 18),
                      _animationEffect(_createTripBtnNarrowUI()),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //내용
  Widget _contentWideUI() {
    return AnimatedOpacity(
      duration: const Duration(seconds: 1),
      opacity: opacityLevel,
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                children: [
                  const Expanded(
                    flex: 1,
                    child: SizedBox(),
                  ),
                  Expanded(
                    flex: 13,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _animationEffect(_titleWideUI()),
                        const SizedBox(height: 30),
                        _animationEffect(_createTripBtnWideUI()),
                      ],
                    ),
                  ),
                  const Expanded(
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

  //타이틀(좁은 화면)
  Widget _titleNarrowUI() {
    return Text(
      'TripFlow',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.indieFlower(
        fontSize: 75,
        fontWeight: FontWeight.bold,
        color: pointColor,
      )
    );
  }

  //타이틀(넓은 화면)
  Widget _titleWideUI() {
    return Text(
      'TripFlow',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.indieFlower(
        fontSize: 120,
        fontWeight: FontWeight.bold,
        color: pointColor,
      )
    );
  }

  //여행 일정 생성하기 버튼(좁은 화면)
  Widget _createTripBtnNarrowUI() {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CreateTripScreen()),
        );
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        backgroundColor: Colors.blue,
      ),
      child: const Text(
        '여행 일정 생성하기',
        style: TextStyle(
          fontSize: 13,
          color: Colors.white,
        ),
      ),
    );
  }

  //여행 일정 생성하기 버튼(넓은 화면)
  Widget _createTripBtnWideUI() {
   return ElevatedButton(
     onPressed: () {
       Navigator.push(
         context,
         MaterialPageRoute(builder: (context) => CreateTripScreen()),
       );
     },
     style: ElevatedButton.styleFrom(
       padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
       backgroundColor: Colors.blue,
     ),
     child: const Text(
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
        begin: const Offset(-1.0, 0.0),
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