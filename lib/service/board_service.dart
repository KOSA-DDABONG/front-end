import 'package:front/service/result.dart';

import '../config.dart';
import '../dto/board/board_detail_response_model.dart';
import '../dto/board/board_list_response_model.dart';
import '../key/key.dart';
import 'dio_client.dart';
import 'session_service.dart';

class BoardService {

  //후기 전체 조회
  static Future<Result<BoardListResponseModel>> getReviewList() async {
    // final url = Uri.http(API_URL, Config.getBoardInfoAPI+boardId).toString();
    final url = Uri.http(Config.apiUrl, Config.getBoardListAPI).toString();
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
      print("@@@ getReviewList 3: " + response.toString());
      if (response.statusCode == 200) {
        print("@@@ getReviewList 4: " + response.statusCode.toString());
        dynamic jsonData = response.data;
        print("@@@ getReviewList 5: " + jsonData.toString());
        return Result.success(
            boardListResponseJson(response.data as Map<String, dynamic>)
        );
      } else {
        print("@@@ getReviewList 6: ");
        throw Exception("Failed to get Board Information");
      }
    } catch (e) {
      print("@@@ getReviewList 7: " + e.toString());
      return Result.failure("[Get Board Info] An Error Occurred: ${e}");
    }
  }

  //후기 상세 조회
  static Future<Result<BoardDetailResponseModel>> getReviewInfo(String boardId) async {
    // final url = Uri.http(API_URL, Config.getBoardInfoAPI+boardId).toString();
    final url = Uri.http(Config.apiUrl, Config.getBoardInfoAPI+boardId).toString();
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
      print("*** getReviewInfo 3: " + response.toString());
      if (response.statusCode == 200) {
        print("*** getReviewInfo 4: " + response.statusCode.toString());
        dynamic jsonData = response.data;
        print("*** getReviewInfo 5: " + jsonData.toString());
        return Result.success(
            boardDetailResponseJson(response.data as Map<String, dynamic>)
        );
      } else {
        print("*** getReviewInfo 6: ");
        throw Exception("Failed to get Board Information");
      }
    } catch (e) {
      print("*** getReviewInfo 7: " + e.toString());
      return Result.failure("[Get Board Info] An Error Occurred: ${e}");
    }
  }

}

