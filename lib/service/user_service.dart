import 'package:front/service/result.dart';

import '../config.dart';
import '../dto/board/board_mylikelist_response_model.dart';
import '../dto/board/board_myreviewlist_response_model.dart';
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
        print("[로그인] : $loginResponse");

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

  //사용자가 작성한 게시물 리스트 조회
  static Future<Result<BoardMyListResponseModel>> getUserReviewList() async {
    final url = Uri.https(API_URL, Config.getUserBoardListAPI).toString();
    // final url = Uri.http(Config.apiUrl, Config.getUserBoardListAPI).toString();
    final accessToken = await SessionService.getAccessToken();
    final headers = {
      'Authorization': 'Bearer $accessToken'
    };

    try {
      final response = await DioClient.sendRequest(
          'GET',
          url,
          headers: headers
      );
      if (response.statusCode == 200) {
        dynamic jsonData = response.data;
        print("[사용자가 작성한 게시물 리스트 조회] : $jsonData");
        return Result.success(
            boardMyListResponseJson(jsonData as Map<String, dynamic>)
        );
      }
      else {
        throw Exception("Failed to get My Board List");
      }
    } catch (e) {
      return Result.failure("[Get My Board List] An Error Occurred: ${e}");
    }
  }

  //사용자 좋아요 리스트 조회
  static Future<Result<MyLikesListResponseModel>> getUserLikesList() async {
    final url = Uri.https(API_URL, Config.getMyLikesListAPI).toString();
    // final url = Uri.http(Config.apiUrl, Config.getMyLikesListAPI).toString();
    final accessToken = await SessionService.getAccessToken();
    final headers = {
      'Authorization': 'Bearer $accessToken'
    };

    try {
      final response = await DioClient.sendRequest(
          'GET',
          url,
          headers: headers
      );
      if (response.statusCode == 200) {
        dynamic jsonData = response.data;
        print("[사용자의 좋아요 리스트 조회] : $jsonData");
        return Result.success(
            myLikesListResponseJson(jsonData as Map<String, dynamic>)
        );
      }
      else {
        throw Exception("Failed to get My Likes List");
      }
    } catch (e) {
      return Result.failure("[Get My Likes List] An Error Occurred: ${e}");
    }
  }
}