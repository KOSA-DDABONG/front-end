import 'package:front/dto/chat/create_trip_request_model.dart';
import 'package:front/dto/chat/create_trip_response_model.dart';
import 'package:front/service/dio_client.dart';
import 'package:front/service/result.dart';

import '../config.dart';
import '../key/key.dart';

class ChatService {

  //여행일정 생성 시 요청 전달 및 응답 받아오기
  static Future<Result<CreateTripResponseModel>> getResponseForCreateSchedule(CreateTripRequestModel model) async {
    final url = Uri.http(FLASK_URL, Config.getResponseForCreateSchedule).toString();
    print("=====");
    print("${url}");
    print("=====");
    print("=====");
    print("${model.toJson()}");
    print("=====");

    final headers = {
      'Content-Type': 'application/json',
    };

    try {
      print("=====");
      print("Here is try");
      print("=====");
      // POST 요청을 위한 JSON 데이터 생성
      final response = await DioClient.sendRequest(
        'POST',
        url,
        headers: headers,
        body: model.toJson(),
      );
      print("=====");
      print("${response.statusCode}");
      print("${response.data}");
      print("=====");

      if (response.statusCode == 200) {
        //응답 성공
        dynamic jsonData = response.data;
        return Result.success(
            createTripResponseJson(jsonData as Map<String, dynamic>)
        );
      } else {
        //응답 실패
        print("서버 오류: ${response.statusCode}");
        throw Exception("Failed to connet Servier");
      }
    } catch (e) {
      //오류
      print("Error occured: ${e}");
      return Result.failure("[Chat] An Error Occurred: ${e}");
    }
  }

}