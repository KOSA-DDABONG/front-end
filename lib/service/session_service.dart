import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../dto/user/login/login_response_model.dart';

class SessionService {

  //안전한 저장소 설정
  static const storage = FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
      iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
      webOptions: WebOptions()
  );

  //로그인 여부 확인
  static Future<bool> isLoggedIn() async {
    return await storage.containsKey(key: 'login_details');
  }

  //로그인 상세 정보 가져오기
  static Future<LoginResponseModel?> loginDetails() async {
    final result = await storage.read(key: 'login_details');
    return result != null
        ? LoginResponseModel.fromJson(jsonDecode(result))
        : null;
  }

  // 로그인 상세 정보 저장하기
  static Future<void> setLoginDetails(LoginResponseModel loginResponse) async {
    await storage.write(
      key: 'login_details',
      value: jsonEncode(loginResponse.toJson()),
    );

    await storage.write(key: 'accessToken', value: loginResponse.accessToken);
  }

  // 로그아웃
  static Future<void> logout() async {
    await storage.delete(key: 'login_details');
  }

  // accessToken 가져오기. 값이 없을 경우 null 반환
  static Future<String?> getAccessToken() async {
    final details = await loginDetails();
    return details?.accessToken;
  }

  // accessToken 설정하기
  static Future<void> setAccessToken(String accessToken) async {
    await storage.write(key: 'accessToken', value: accessToken);
  }

  static Future<bool> getBool(String key) async {
    final result = await storage.read(key: key);
    return result == 'true' ? true : false;
  }

  static Future<String?> getString(String key) async {
    final result = await storage.read(key: key);
    return result;
  }
}
