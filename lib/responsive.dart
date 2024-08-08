import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  final Widget narrowWidth;
  final Widget wideWidth;

  const Responsive({
    Key? key,
    required this.narrowWidth,
    required this.wideWidth,
  }) : super(key: key);

  static bool isNarrowWidth(BuildContext context) =>
      MediaQuery.of(context).size.width < 800;

  static bool isWideWidth(BuildContext context) =>
      MediaQuery.of(context).size.width >= 800;

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    if (_size.width >= 800) {
      return wideWidth;
    }
    else {
      return narrowWidth;
    }
  }
}