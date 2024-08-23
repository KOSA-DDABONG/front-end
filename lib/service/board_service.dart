import 'package:front/dto/comment/comment_request_model.dart';
import 'package:front/service/result.dart';

import '../config.dart';
import '../dto/board/board_detail_get_response_model.dart';
import '../dto/board/board_list_response_model.dart';
import '../dto/board/board_mylist_response.dart';
import '../dto/board/board_register_request_model.dart';
import '../dto/board/board_register_response_model.dart';
import '../dto/comment/comment_response_model.dart';
import '../key/key.dart';
import 'dio_client.dart';
import 'session_service.dart';


class BoardService {

  //후기 전체 조회
  static Future<Result<BoardListResponseModel>> getReviewList() async {
    final url = Uri.https(API_URL, Config.getBoardListAPI).toString();
    // final url = Uri.http(Config.apiUrl, Config.getBoardListAPI).toString();
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
        return Result.success(
            boardListResponseJson(jsonData as Map<String, dynamic>)
        );
      } else {
        throw Exception("Failed to get Board Information");
      }
    } catch (e) {
      return Result.failure("[Get Board Info] An Error Occurred: ${e}");
    }
  }

  //후기 상세 조회
  static Future<Result<BoardDetailGetResponseModel>> getReviewDetailInfo(String boardId) async {
    final url = Uri.https(API_URL, Config.getBoardInfoAPI+boardId).toString();
    // final url = Uri.http(Config.apiUrl, Config.getBoardInfoAPI+boardId).toString();
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
      print("#######");
      print("${response.data}");
      print("#######");
      if (response.statusCode == 200) {
        dynamic jsonData = response.data;
        return Result.success(
            boardDetailGetResponseJson(jsonData as Map<String, dynamic>)
        );
      }
      else {
        print("#######");
        print("Else");
        print("#######");
        throw Exception("Failed to get Board Information");
      }
    } catch (e) {
      print("#######");
      print("$e");
      print("#######");
      return Result.failure("[Get Board Info] An Error Occurred: ${e}");
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
        return Result.success(
          boardMyListResponseJson(jsonData as Map<String, dynamic>)
        );
      }
      else {
        throw Exception("Failed to get Board Information");
      }
    } catch (e) {
      return Result.failure("[Get Board Info] An Error Occurred: ${e}");
    }
  }

  //댓글 작성
  static Future<Result<CommentResponseModel>> registerComment(CommentRequestModel model) async {
    final url = Uri.https(API_URL,  Config.registerCommentAPI).toString();
    // final url = Uri.http(Config.apiUrl, Config.registerCommentAPI).toString();
    final accessToken = await SessionService.getAccessToken();
    final headers = {
      'Authorization': 'Bearer $accessToken'
    };

    try {
      final response = await DioClient.sendRequest(
        'POST',
        url,
        headers: headers,
        body: model.toJson(),
      );
      if (response.statusCode == 200) {
        dynamic jsonData = response.data;
        return Result.success(
            commentResponseJson(jsonData as Map<String, dynamic>)
        );
      } else {
        throw Exception("Failed to register Comment");
      }
    } catch (e) {
      return Result.failure("[Register Comment] An Error Occurred: ${e}");
    }
  }

  // 게시물 작성
  static Future<Result<BoardRegisterResponseModel>> savePost(BoardRegisterRequestModel model) async {
    final url = Uri.https(API_URL,  Config.savePostAPI).toString();
    // final url = Uri.http(Config.apiUrl, Config.savePostAPI).toString();
    final accessToken = await SessionService.getAccessToken();

    try {
      // FormData 생성
      final formData = await model.toFormData();

      // 요청 헤더 설정
      final headers = {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'multipart/form-data'
      };

      // 응답 처리
      final response = await DioClient.sendRequest(
        'POST',
        url,
        headers: headers,
        body: formData,
      );

      if (response.statusCode == 200) {
        final jsonData = response.data;
        return Result.success(
            boardRegisterResponseJson(jsonData as Map<String, dynamic>)
        );
      } else {
        throw Exception("Failed to get Board Information");
      }
    } catch (e) {
      return Result.failure("[Get Board Info] An Error Occurred: ${e}");
    }
  }
}


