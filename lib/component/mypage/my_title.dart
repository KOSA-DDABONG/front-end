import 'package:flutter/material.dart';

Widget showTitle(String titleText) {
  return Text(
    titleText,
    style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold
    ),
  );
}