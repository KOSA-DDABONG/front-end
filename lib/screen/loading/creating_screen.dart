import 'package:flutter/material.dart';
import 'package:front/constants.dart';
import 'package:front/screen/trip/result_screen.dart';

import '../../component/header/header.dart';
import '../../component/header/header_drawer.dart';
import '../../controller/login_state_for_header.dart';
import '../../responsive.dart';

class CreatingScreen extends StatefulWidget {
  const CreatingScreen({Key? key}) : super(key: key);

  @override
  _CreatingScreenState createState() => _CreatingScreenState();
}

class _CreatingScreenState extends State<CreatingScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late double _screenWidth;
  late double _imageWidth;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _screenWidth = MediaQuery.of(context).size.width;
    _imageWidth = 100;
    final double centerOffset = (_screenWidth - _imageWidth) / 2;
    _animation = Tween<double>(begin: centerOffset - 50, end: centerOffset + 50).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    //8초 후에 TripResultScreen으로 이동
    Future.delayed(const Duration(seconds: 8), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ResultScreen()),
        );
      }
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
        if (isLoggedIn) {
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
          body: _creatingTripScreenUI(),
        );
      }
    );
  }

  // 여행 일정 생성 로딩 페이지 UI
  Widget _creatingTripScreenUI() {
    return Stack(
      alignment: Alignment.center,
      children: [
        _imgAnimationUI(),
        _creatingTextUI(),
      ],
    );
  }

  // 이미지 애니메이션 UI
  Widget _imgAnimationUI() {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        if (!mounted) return const SizedBox.shrink();
        return Positioned(
          left: _animation.value,
          child: child!,
        );
      },
      child: Image.asset(
        'assets/images/blue_car.png',
        width: _imageWidth,
        height: 100,
      ),
    );
  }

  // 생성중 텍스트
  Widget _creatingTextUI() {
    double screenHeight = MediaQuery.of(context).size.height;
    double centerY = screenHeight / 2;
    double textHeight = 24;
    double textOffset = centerY + 60 - (textHeight / 2);

    return Positioned(
      top: textOffset,
      child: Text(
        'Creating...',
        style: TextStyle(
          color: pointColor,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
