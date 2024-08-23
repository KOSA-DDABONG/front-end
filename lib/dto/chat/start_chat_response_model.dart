StartChatResponseModel startChatResponseJson(Map<String, dynamic> json) =>
    StartChatResponseModel.fromJson(json);

class StartChatResponseModel {
  StartChatResponseModel({
    required this.message,
    required this.status,
  });

  late final String message;
  late final String status;

  StartChatResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
  }
}
