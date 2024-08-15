import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:front/service/result.dart';

import '../config.dart';
import '../dto/user/login/login_request_model.dart';
import '../dto/user/login/login_response_model.dart';
import '../dto/user/user_model.dart';
import '../key/key.dart';
import 'dio_client.dart';

class SessionService {

  //안전한 저장소 설정
  static const storage = FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
      iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
      webOptions: WebOptions()
  );

  //로그인
  static Future<Result<LoginResponseModel>> login(LoginRequestModel model) async {
    // final url = Uri.http(API_URL, Config.loginAPI).toString();
    final url = Uri.http(Config.apiUrl, Config.loginAPI).toString();

    try{
      final response = await DioClient.sendRequest('POST', url, body: model.toJson());

      if (response.statusCode == 200) {
        // 로그인 응답 데이터 처리
        final loginResponse = loginResponseJson(response.data['data'] as Map<String, dynamic>);
        // accessToken 저장
        await SessionService.setLoginDetails(loginResponse);

        return Result.success(loginResponse);
      } else {
        return Result.failure("[Login] Error: ${response.statusCode}");
      }
    } catch (e) {
      return Result.failure("[Login] An Error Occurred: $e");
    }
  }

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

  // // 로그아웃
  // static Future<void> logout() async {
  //   await storage.delete(key: 'login_details');
  // }
  //로그아웃
  static Future<Result<bool>> logout() async {
    final accessToken = await SessionService.getAccessToken();
    // final refreshToken = await SessionService.getRefreshToken();

    final url = Uri.http(API_URL, Config.sampleAPI).toString();

    final headers = {
      'Authorization': 'Bearer $accessToken',
    };

    try {
      final response = await DioClient.sendRequest(
        'GET',
        url,
        headers: headers,
      );
      if (response.statusCode == 200) {
        await SessionService.logout();
        return Result.success(true);
      }
      return Result.failure("Logout failed");
    } catch (e) {
      return Result.failure("An error occurred: $e");
    }
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

  // User 가져오기. 값이 없을 경우 null 반환
  static Future<User?> getUser() async {
    final details = await loginDetails();
    return details?.user;
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
