import 'package:flutter/material.dart';

bool checkNicknameValidate(String nickname, GlobalKey<FormState> globalFormKey) {
    final RegExp validCharacters = RegExp(r'^[a-zA-Z가-힣0-9]+$');
    return nickname.isNotEmpty &&
        nickname.length <= 20 &&
        validCharacters.hasMatch(nickname);
}