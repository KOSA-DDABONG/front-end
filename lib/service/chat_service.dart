import 'package:front/dto/chat/create_trip_request_model.dart';
import 'package:front/dto/chat/create_trip_response_model.dart';
import 'package:front/service/dio_client.dart';
import 'package:front/service/result.dart';
import 'package:front/service/session_service.dart';

import '../config.dart';
import '../dto/chat/chatbot_message_response_model.dart';
import '../dto/chat/judge_result_response_model.dart';
import '../dto/chat/start_chat_response_model.dart';
import '../key/key.dart';

class ChatService {

  //여행일정 생성 시 요청 전달 및 응답 받아오기
  static Future<Result<CreateTripResponseModel>> getResponseForCreateSchedule(CreateTripRequestModel model) async {
    final url = Uri.http(FLASK_URL, Config.getResponseForCreateScheduleAPI).toString();

    final headers = {
      'Content-Type': 'application/json',
    };

    try {
      final response = await DioClient.sendRequest(
        'POST',
        url,
        headers: headers,
        body: model.toJson(),
      );

      if (response.statusCode == 200) {
        //응답 성공
        dynamic jsonData = response.data;
        print("[채팅] : $jsonData");
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


  //////////////////////////////////////////////////

  //채팅 시작 여부 전달
  static Future<Result<StartChatResponseModel>> isChatStart() async {
    final url = Uri.https(API_URL, Config.getChatConnectionAPI).toString();
    // final url = Uri.http(Config.apiUrl, Config.getChatConnectionAPI).toString();
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

      final jsonData = response.data;
      print("[채팅 시작 여부 전달] : $jsonData");
      return Result.success(
        startChatResponseJson(jsonData as Map<String, dynamic>)
      );
    } catch (e) {
      return Result.failure("[isChatStart] An Error Occurred: ${e}");
    }
  }

  //사용자가 입력한 메세지 전달
  static Future<Result<ChatbotMessageResponseModel>> getChatConversation(String userMessage) async {
    final url = Uri.https(API_URL, Config.getChatConversationAPI).toString();
    // final url = Uri.http(Config.apiUrl, Config.getChatConversationAPI).toString();
    final accessToken = await SessionService.getAccessToken();
    final headers = {
      'Authorization': 'Bearer $accessToken'
    };

    try {
      final response = await DioClient.sendRequest(
        'POST',
        url,
        headers: headers,
        body: userMessage
      );

      final jsonData = response.data;
      print("[사용자가 입력한 메세지 전달] : $jsonData");
      return Result.success(
          chatbotMessageResponseJson(jsonData as Map<String, dynamic>)
      );
    } catch (e) {
      return Result.failure("[getChatConversation] An Error Occurred: ${e}");
    }
  }

  //생성된 여행 일정에 대한 사용자의 반응 전달
  static Future<Result<JudgeResultResponseModel>> sendUserResponse(String userResponse) async {
    final url = Uri.https(API_URL, Config.sendUserResponseAPI).toString();
    // final url = Uri.http(Config.apiUrl, Config.sendUserResponseAPI).toString();
    final accessToken = await SessionService.getAccessToken();
    final headers = {
      'Authorization': 'Bearer $accessToken'
    };

    try {
      final response = await DioClient.sendRequest(
          'POST',
          url,
          headers: headers,
          body: userResponse
      );
      final jsonData = response.data;
      print("[생성된 여행 일정에 대한 사용자의 반응 전달] : $jsonData");
      return Result.success(
          judgeResultResponseJson(jsonData as Map<String, dynamic>)
      );
    } catch (e) {
      return Result.failure("[getChatConversation] An Error Occurred: ${e}");
    }
  }

  //////////////////////////////////////////////////
}