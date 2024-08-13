import 'package:flutter/material.dart';

class HorizontalWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    // 시작 지점 (왼쪽 위 모서리)
    path.lineTo(0, size.height * 0.4);

    // 왼쪽 아래 볼록한 웨이브 형태 그리기
    path.cubicTo(
      size.width * 0.2, size.height * 0.3, // 첫 번째 제어점 (왼쪽 아래)
      size.width * 0.4, size.height * 0.4, // 두 번째 제어점 (왼쪽 아래)
      size.width * 0.6, size.height * 0.5, // 종착점 (중간)
    );

    // 오른쪽 위 볼록한 웨이브 형태 그리기
    path.cubicTo(
      size.width * 0.8, size.height * 0.6, // 첫 번째 제어점 (오른쪽 위)
      size.width * 1.0, size.height * 0.4, // 두 번째 제어점 (오른쪽 위)
      size.width, size.height * 0.4, // 종착점 (오른쪽 아래)
    );

    // 오른쪽 아래부터 오른쪽 위까지 직선 그리기
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
