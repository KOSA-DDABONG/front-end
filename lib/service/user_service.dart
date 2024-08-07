import 'package:dio/dio.dart';
import 'package:front/service/result.dart';

import '../config.dart';
import '../dto/signup/signup_request_model.dart';
import '../dto/signup/signup_response_model.dart';
import '../dto/user_model.dart';
import 'dio_client.dart';
import 'session_service.dart';

class UserService {

  // //회원가입
  // static Future<Result<SignupResponseModel>> register(SignupRequestModel model) async {
  //   print('register0: ');
  //   print(model.userId);
  //   print(model.username);
  //   print('-------');
  //   final url = Uri.http(Config.apiURL, Config.signupAPI).toString();
  //   print('register1: ');
  //   print(url);
  //   print('-------');
  //   try {
  //     print('this is try section');
  //     print('-------');
  //     final response = await DioClient.sendRequest('POST', url, body: model.toFormData);
  //     print('register2: ');
  //     print(response.data);
  //     print('-------');
  //     return Result.success(
  //         signupResponseJson(response.data['data'] as Map<String, dynamic>)
  //     );
  //   } catch (e) {
  //     print(e);
  //     print('-------');
  //     return Result.failure("[Signup] An Error Occurred: ${e}");
  //   }
  // }
  //회원가입
  static Future<Result<String>> register(SignupRequestModel model) async {
    final url = Uri.http(Config.apiURL, Config.signupAPI).toString();

    try {
      final response = await DioClient.sendRequest('POST', url, body: model.toJson());
      print('**' + response.toString());
      return Result.success("Success");
    } catch (e) {
      return Result.failure("[Signup] An Error Occurred: ${e}");
    }
  }

  //사용자 프로필 조회
  static Future<Result<User>> getUserProfile() async {
    final accessToken = await SessionService.getAccessToken();
    final refreshToken = await SessionService.getRefreshToken();
    final url = Uri.http(Config.apiURL, Config.sampleAPI).toString();
    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Cookie': 'XRT=$refreshToken',
    };

    try {
      final response = await DioClient.sendRequest(
        'GET',
        url,
        headers: headers,
      );

      if (response.statusCode == 200) {
        final user = User.fromJson(response.data as Map<String, dynamic>);
        return Result.success(user);
      }
      return Result.failure("Failed to get user profile");
    } catch (e) {
      return Result.failure("An error occurred: $e");
    }
  }


  //이메일 인증 요청
  static Future<Response<dynamic>> emailVerifyRequest(String email) async {

    final parameters = {
      'email': email,
    };

    final url = Uri.http(Config.apiURL, Config.sampleAPI, parameters).toString();

    try {
      final response = await DioClient.sendRequest('POST', url);

      if (response.statusCode == 200) {
        return response;
      }
      throw DioException(
        response: response,
        requestOptions: RequestOptions(path: ''),
        error: "Email verification request failed with status code ${response.statusCode}",
      );
    } catch (e) {
      throw DioException(
        response: null,
        requestOptions: RequestOptions(path: ''),
        error: "An error occurred: $e",
      );
    }
  }


  //이메일 인증 토큰 확인 요청
  static Future<Response<dynamic>> emailVerifyTokenRequest(String token) async {

    final parameters = {
      'token': token,
    };

    final url = Uri.http(Config.apiURL, Config.sampleAPI, parameters).toString();

    try {
      final response = await DioClient.sendRequest('POST', url);

      if (response.statusCode == 200) {
        return response;
      }
      throw DioException(
        response: response,
        requestOptions: RequestOptions(path: ''),
        error: "Email verification request failed with status code ${response.statusCode}",
      );
    } catch (e) {
      throw DioException(
        response: null,
        requestOptions: RequestOptions(path: ''),
        error: "An error occurred: $e",
      );
    }
  }

}


