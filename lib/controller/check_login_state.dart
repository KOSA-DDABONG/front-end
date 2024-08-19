import 'package:flutter/material.dart';
import 'package:front/service/session_service.dart';

import '../component/dialog/request_login_dialog.dart';

Future<bool> checkLoginState(BuildContext context) async {
  try {
    final result = await SessionService.isLoggedIn();
    if (result) { // 로그인 상태
      return true;
    }
    else {
      // 로그인 상태가 아닐 때
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
    // 에러 발생 시 false 반환
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('문제가 발생했습니다. 잠시 후 다시 시도해주세요.'),
      ),
    );
    return false;
  }
}
