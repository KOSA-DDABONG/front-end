import 'package:flutter/material.dart';

Widget showLoginSignupBackgroungImg(BuildContext context) {
  double screenWidth = MediaQuery.of(context).size.width;
  double screenHeight = MediaQuery.of(context).size.height;
  return Positioned(
    bottom: 0,
    top: 0,
    child: Opacity(
      opacity: 0.15,
      child: Image.asset(
        '../assets/images/login_background.png',
        width: screenWidth / 2,
        height: screenHeight * 2 / 3,
        fit: BoxFit.fill,
      ),
    ),
  );
}