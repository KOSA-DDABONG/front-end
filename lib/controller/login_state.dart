// login_state.dart
import 'package:flutter/material.dart';
import 'package:front/service/session_service.dart';

class CheckLoginStateWidget extends StatelessWidget {
  final Widget Function(BuildContext context, bool isLoggedIn) builder;

  CheckLoginStateWidget({required this.builder});

  Future<bool> _checkLoginStatus() async {
    return await SessionService.isLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkLoginStatus(),
      builder: (context, snapshot) {
        bool isLoggedIn = snapshot.data ?? false;
        return builder(context, isLoggedIn);
      },
    );
  }
}
