import 'package:flutter/material.dart';

Widget showTitle(String titleText) {
  return Text(
    titleText,
    style: const TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold
    ),
  );
}