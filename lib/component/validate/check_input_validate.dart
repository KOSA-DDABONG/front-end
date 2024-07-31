import 'package:flutter/material.dart';

bool checkInputValidate(GlobalKey<FormState> globalFormKey) {
  final form = globalFormKey.currentState;
  if (form!.validate()) {
    form.save();
    return true;
  }
  return false;
}