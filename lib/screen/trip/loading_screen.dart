import 'package:flutter/material.dart';
import 'package:front/constants.dart';

import '../../component/header/header.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> with SingleTickerProviderStateMixin {
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
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AfterLoginHeader(
        automaticallyImplyLeading: false,
        context: context,
      ),
      extendBodyBehindAppBar: true,
      backgroundColor: subBackgroundColor,
      body: _loadingTripScreenUI(),
    );
  }

  Widget _loadingTripScreenUI() {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              if (!mounted) return SizedBox.shrink();
              return Positioned(
                left: _animation.value,
                child: child!,
              );
            },
            child: Image.asset(
              '../assets/images/yellow_car.png',
              width: _imageWidth,
              height: 100,
            ),
          ),
          const Positioned(
            bottom: 200,
            child: Text(
              'Loading...',
              style: TextStyle(
                color: pointColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
