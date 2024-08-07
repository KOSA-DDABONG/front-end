import 'package:dio/dio.dart';
import 'package:front/service/result.dart';

import '../config.dart';
import '../dto/login/login_request_model.dart';
import '../dto/login/login_response_model.dart';
import '../key/key.dart';

class ServiceTest {

  //로그인 테스트
  static Future<Result<LoginResponseModel>> logintest(LoginRequestModel model) async {
    final dio = Dio();
    print('login service0: ' + model.toString());
    print(model.userId);
    print(model.password);
    print('----');

    final url = Uri.http(API_URL, Config.loginAPI).toString();
    print('login service1: ' + url);
    print('----');

    try{
      print('this is "try" section');
      print('----');
      final response = await dio.post(url, data: model.toFormData());
      print('login service2: ' + response.toString());
      print(response.statusCode);
      print(response.statusMessage);
      print(response.data);
      print('----');
      return Result.success(
          loginResponseJson(response.data['data'] as Map<String, dynamic>));
    } catch (e) {
      print('login service3: catch' + e.toString());
      print('----');
      return Result.failure("[Login] An Error Occurred: $e");
    }
  }
}
