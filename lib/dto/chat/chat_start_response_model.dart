import 'package:front/dto/chat/chat_data_start_model.dart';

ChatStartResponseModel chatStartResponseJson(Map<String, dynamic> json) =>
    ChatStartResponseModel.fromJson(json);

class ChatStartResponseModel {
  ChatStartResponseModel({
    required this.message,
    required this.status,
    required this.data
  });

  late final String message;
  late final int status;
  late final ChatDataStartModel data;

  ChatStartResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    data = ChatDataStartModel.fromJson(json['data']);
  }
}
