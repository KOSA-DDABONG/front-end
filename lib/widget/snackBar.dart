import 'package:flutter/material.dart';

void showCustomSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.blue), // 글씨 색상 파란색
      ),
      backgroundColor: Colors.white, // 배경색 흰색
    ),
  );
}
