import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  const Responsive({
    Key? key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  }) : super(key: key);

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 768;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < 1024 &&
          MediaQuery.of(context).size.width >= 768;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1024;

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    if (_size.width >= 1024) {
      return desktop;
    }
    else if (_size.width >= 768 && tablet != null) {
      return tablet!;
    }
    else {
      return mobile;
    }
  }



  // static bool isMobile(BuildContext context) {
  //   final Size size = MediaQuery.of(context).size;
  //   return size.width < 850 && size.height < 600;
  // }
  //
  // static bool isTablet(BuildContext context) {
  //   final Size size = MediaQuery.of(context).size;
  //   return size.width >= 850 && size.width < 1100 && size.height >= 600 && size.height < 800;
  // }
  //
  // static bool isDesktop(BuildContext context) {
  //   final Size size = MediaQuery.of(context).size;
  //   return size.width >= 1100 && size.height >= 800;
  // }

  // @override
  // Widget build(BuildContext context) {
  //   final Size _size = MediaQuery.of(context).size;
  //   if (isDesktop(context)) {
  //     return desktop;
  //   } else if (isTablet(context) && tablet != null) {
  //     return tablet!;
  //   } else {
  //     return mobile;
  //   }
  // }
}