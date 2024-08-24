import 'package:front/service/result.dart';

import '../config.dart';
import '../dto/user/login/login_request_model.dart';
import '../dto/user/login/login_response_model.dart';
import '../dto/user/signup/signup_request_model.dart';
import '../key/key.dart';
import 'dio_client.dart';
import 'session_service.dart';

class UserService {

  //회원가입
  static Future<Result<String>> register(SignupRequestModel model) async {
    final url = Uri.https(API_URL, Config.signupAPI).toString();
    // final url = Uri.http(Config.apiUrl, Config.signupAPI).toString();

    try {
      final response = await DioClient.sendRequest('POST', url, body: model.toJson());
      final jsonData = response.data;
      print("[회원가입] : $jsonData");
      if (response == "Success") {
        return Result.success("Success");
      }
      else {
        throw Exception("[Signup] Failed Signup");
      }
    } catch (e) {
      return Result.failure("[Signup] An Error Occurred: ${e}");
    }
  }

  //로그인
  static Future<Result<LoginResponseModel>> login(LoginRequestModel model) async {
    final url = Uri.https(API_URL, Config.loginAPI).toString();
    // final url = Uri.http(Config.apiUrl, Config.loginAPI).toString();

    try{
      final response = await DioClient.sendRequest('POST', url, body: model.toJson());
      final jsonData = response.data;
      print("[로그인] : $jsonData");
      if (response.statusCode == 200) {
        // 로그인 응답 데이터 처리
        final loginResponse = loginResponseJson(response.data['data'] as Map<String, dynamic>);
        print(response.data['data']);

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
}


