import 'package:flutter/material.dart';

bool checkNumberValidate(String input, GlobalKey<FormState> globalFormKey) {
  final RegExp regex = RegExp(r'^010\d{8}$');
  return regex.hasMatch(input);
}