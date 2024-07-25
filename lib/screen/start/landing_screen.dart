import 'package:flutter/material.dart';
import 'package:front/component/header/header_drawer.dart';
import 'dart:ui' as ui;
import 'package:google_fonts/google_fonts.dart';

import '../../component/header/header.dart';


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
      vsync: this, // 여기서 vsync 사용
      duration: Duration(seconds: 1),
    );
    // 애니메이션 시작을 지연시키고 싶다면 Future.delayed를 사용할 수 있습니다.
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
      // appBar: NotLoginShortHeader(
      //   automaticallyImplyLeading: false,
      // ),
      // drawer: HeaderDrawer(),
      extendBodyBehindAppBar: true,
      // backgroundColor: Color(0xffe4f4ff),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background image with custom shape and blur effect
          Positioned.fill(
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
          ),
          // Content
          AnimatedOpacity(
            duration: Duration(seconds: 1),
            opacity: opacityLevel,
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      children: [
                        // Left side: Text and Button
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
                              SlideTransition(
                                position: Tween<Offset>(
                                  begin: Offset(-1.0, 0.0),
                                  end: Offset.zero,
                                ).animate(CurvedAnimation(
                                  parent: _controller,
                                  curve: Curves.easeOut,
                                )),
                                child: Text(
                                  'TripFlow',
                                  style: GoogleFonts.indieFlower(
                                    fontSize: 120,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF003680),
                                  ),
                                ),
                              ),
                              SlideTransition(
                                position: Tween<Offset>(
                                  begin: Offset(-1.0, 0.0),
                                  end: Offset.zero,
                                ).animate(CurvedAnimation(
                                  parent: _controller,
                                  curve: Curves.easeOut,
                                )),
                                child: Text(
                                  '설명을 추가하세요.',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              SizedBox(height: 30),
                              SlideTransition(
                                position: Tween<Offset>(
                                  begin: Offset(-1.0, 0.0),
                                  end: Offset.zero,
                                ).animate(CurvedAnimation(
                                  parent: _controller,
                                  curve: Curves.easeOut,
                                )),
                                child: ElevatedButton(
                                  onPressed: () {
                                    //
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
                                ),
                              ),
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
          ),
        ],
      ),
    );
  }
}

class VerticalWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    // 시작 지점 (왼쪽 위 모서리)
    path.lineTo(size.width * 0.4, 0);

    // 왼쪽 아래 볼록한 웨이브 형태 그리기
    path.cubicTo(
      size.width * 0.2, size.height * 0.2, // 첫 번째 제어점 (왼쪽 아래)
      size.width * 0.3, size.height * 0.35, // 두 번째 제어점 (왼쪽 아래)
      size.width * 0.4, size.height * 0.5, // 종착점 (중간)
    );

    // 오른쪽 위 볼록한 웨이브 형태 그리기
    path.cubicTo(
      size.width * 0.5, size.height * 0.7, // 첫 번째 제어점 (오른쪽 위)
      size.width * 0.6, size.height * 0.85, // 두 번째 제어점 (오른쪽 위)
      size.width * 0.2, size.height, // 종착점 (오른쪽 아래)
    );

    // 오른쪽 아래부터 오른쪽 위까지 직선 그리기
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
