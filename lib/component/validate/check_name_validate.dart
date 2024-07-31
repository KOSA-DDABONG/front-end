import 'package:flutter/material.dart';

bool checkNameValidate(String nickname, GlobalKey<FormState> globalFormKey) {
  final RegExp validCharacters = RegExp(r'^[a-zA-Z가-힣]+$');
  return nickname.isNotEmpty &&
      nickname.length <= 20 &&
      validCharacters.hasMatch(nickname);
}