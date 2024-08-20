import 'package:dio/dio.dart';
import 'package:front/dto/board/board_register_request_model.dart';
import 'package:front/dto/board/board_register_response_model.dart';
import 'package:front/dto/comment/comment_request_model.dart';
import 'package:front/service/result.dart';
import 'package:image_picker/image_picker.dart';

import '../config.dart';
import '../dto/board/board_detail_response_model.dart';
import '../dto/board/board_list_response_model.dart';
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
            boardListResponseJson(response.data as Map<String, dynamic>)
        );
      } else {
        throw Exception("Failed to get Board Information");
      }
    } catch (e) {
      return Result.failure("[Get Board Info] An Error Occurred: ${e}");
    }
  }

  //후기 상세 조회
  static Future<Result<BoardDetailResponseModel>> getReviewInfo(String boardId) async {
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
      if (response.statusCode == 200) {
        dynamic jsonData = response.data;
        return Result.success(
            boardDetailResponseJson(response.data as Map<String, dynamic>)
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
          headers: headers
      );
      if (response.statusCode == 200) {
        dynamic jsonData = response.data;
        return Result.success(
            commentResponseJson(jsonData as Map<String, dynamic>)
        );
      } else {
        throw Exception("Failed to get Board Information");
      }
    } catch (e) {
      return Result.failure("[Get Board Info] An Error Occurred: ${e}");
    }
  }

  //게시물 작성
  static Future<Result<BoardRegisterResponseModel>> registerReview(BoardRegisterRequestModel model) async {
    final url = Uri.https(API_URL,  Config.registerReviewAPI).toString();
    // final url = Uri.http(Config.apiUrl, Config.registerReviewAPI).toString();
    final accessToken = await SessionService.getAccessToken();
    final headers = {
      'Authorization': 'Bearer $accessToken',
    };

    try {
      final response = await DioClient.sendRequest(
        'POST',
        url,
        headers: headers,
      );
      if (response.statusCode == 200) {
        dynamic jsonData = response.data;
        return Result.success(
            boardRegisterResponseJson(response.data as Map<String, dynamic>)
        );
      } else {
        throw Exception("Failed to get Board Information");
      }
    } catch (e) {
      return Result.failure("[Get Board Info] An Error Occurred: ${e}");
    }
  }
}


