import 'chat_data_model.dart';

ChatResponseModel chatResponseJson(Map<String, dynamic> json) =>
    ChatResponseModel.fromJson(json);

class ChatResponseModel {
  ChatResponseModel({
    required this.message,
    required this.status,
    required this.data
  });

  late final String message;
  late final int status;
  late final ChatDataModel data;

  ChatResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    data = ChatDataModel.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'status': status,
      'data': data,
    };
  }
}
