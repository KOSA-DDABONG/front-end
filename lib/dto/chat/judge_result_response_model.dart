JudgeResultResponseModel judgeResultResponseJson(Map<String, dynamic> json) =>
    JudgeResultResponseModel.fromJson(json);

class JudgeResultResponseModel {
  JudgeResultResponseModel({
    required this.message,
    required this.status,
  });

  late final String message;
  late final String status;

  JudgeResultResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
  }
}
