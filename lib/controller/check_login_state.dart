import 'package:flutter/material.dart';
import 'package:front/service/session_service.dart';

import '../component/dialog/request_login_dialog.dart';
import '../component/snack_bar.dart';

Future<bool> checkLoginState(BuildContext context) async {
  try {
    final result = await SessionService.isLoggedIn();
    if (result) {
      return true;
    }
    else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return showRequestLoginDialog(context);
          },
        );
      });
      return false;
    }
  } catch (e) {
    showCustomSnackBar(context, '문제가 발생했습니다. 잠시 후 다시 시도해주세요.');
    return false;
  }
}