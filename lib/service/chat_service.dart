

import 'dart:convert';

import 'package:front/service/dio_client.dart';
import 'package:front/service/session_service.dart';

import '../config.dart';
import '../key/key.dart';

class ChatService {

  //여행일정 생성 시 요청 전달 및 응답 받아오기
  static Future<String> getResponseForCreateSchedule(String input) async {
    final url = Uri.https(FLASK_URL, Config.getResponseForCreateSchedule).toString();
    final accessToken = await SessionService.getAccessToken();

    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json'
    };

    try {
      // POST 요청을 위한 JSON 데이터 생성
      final response = await DioClient.sendRequest(
        'POST',
        url,
        headers: headers,
        body: jsonEncode({'question': input}),
      );

      if (response.statusCode == 200) {
        //응답 성공
        final responseData = jsonDecode(response.data);
        return responseData['response'];
        // return responseData['response'] ?? '서버 응답 없음';
      } else {
        //응답 실패
        print("서버 오류: ${response.statusCode}");
        return '응답 요청에 실패하였습니다. 새로고침 후 다시 시도해주세요.';
      }
    } catch (e) {
      //오류
      print("Error occured: ${e}");
      return '오류가 발생하였습니다. 새로고침 후 다시 시도해주세요.';
    }
  }

}