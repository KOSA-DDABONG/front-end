import 'package:front/service/dio_client.dart';
import 'package:front/service/result.dart';
import 'package:front/service/session_service.dart';

import '../config.dart';
import '../dto/chat/start/chat_start_response_model.dart';
import '../dto/chat/response/judge_result_response_model.dart';
import '../dto/chat/message/chat_response_model.dart';
import '../key/key.dart';

class ChatService {

  //채팅 시작 여부 전달
  static Future<Result<ChatStartResponseModel>> isChatStart(String startDate) async {
    final url = Uri.https(API_URL, Config.getChatConnectionAPI).toString();
    // final url = Uri.http(Config.apiUrl, Config.getChatConnectionAPI).toString();
    final accessToken = await SessionService.getAccessToken();
    final headers = {
      'Authorization': 'Bearer $accessToken'
    };

    try {
      final response = await DioClient.sendRequest(
        'POST',
        url,
        headers: headers,
        body: startDate,
      );

      final jsonData = response.data;
      print("[채팅 시작 여부 전달] : $jsonData");
      return Result.success(
        chatStartResponseJson(jsonData as Map<String, dynamic>)
      );
    } catch (e) {
      return Result.failure("[isChatStart] An Error Occurred: $e");
    }
  }

  //사용자가 입력한 메세지 전달
  static Future<Result<ChatResponseModel>> getChatConversation(String userMessage) async {
    final url = Uri.https(API_URL, Config.getChatConversationAPI).toString();
    // final url = Uri.http(Config.apiUrl, Config.getChatConversationAPI).toString();
    final accessToken = await SessionService.getAccessToken();
    final headers = {
      'Authorization': 'Bearer $accessToken',
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

      final chatResponse = chatResponseJson(jsonData as Map<String, dynamic>);
      print("[사용자가 입력한 메세지 전달 - ChatResponseModel] : ${chatResponse.data.travelSchedule.scheduler}");

      return Result.success(
        chatResponseJson(jsonData as Map<String, dynamic>)
      );
    } catch (e) {
      print("[사용자가 입력한 메세지 전달 에러] : $e");
      return Result.failure("[getChatConversation] An Error Occurred: $e");
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
      print("[생성된 여행 일정에 대한 사용자의 반응 전달 에러] : $e");
      return Result.failure("[getChatConversation] An Error Occurred: $e");
    }
  }
}