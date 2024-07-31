import 'package:flutter/material.dart';

bool checkIdValidate(String nickname, GlobalKey<FormState> globalFormKey) {
  final RegExp validCharacters = RegExp(r'^[a-zA-Z0-9]+$');
  return nickname.isNotEmpty &&
      nickname.length <= 20 &&
      validCharacters.hasMatch(nickname);
}