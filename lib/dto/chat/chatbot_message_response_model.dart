ChatbotMessageResponseModel chatbotMessageResponseJson(Map<String, dynamic> json) =>
    ChatbotMessageResponseModel.fromJson(json);

class ChatbotMessageResponseModel {
  ChatbotMessageResponseModel({
    required this.message,
    required this.status,
    required this.chatMessageContent,
    required this.messageType,
  });

  late final String message;
  late final String status;
  late final String chatMessageContent;
  late final String messageType;


  ChatbotMessageResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    chatMessageContent = json['chatMessageContent'];
    messageType = json['messageType'];
  }
}
