import 'judge_result_data_model.dart';

JudgeResultResponseModel judgeResultResponseJson(Map<String, dynamic> json) =>
    JudgeResultResponseModel.fromJson(json);

class JudgeResultResponseModel {
  JudgeResultResponseModel({
    required this.message,
    required this.status,
    required this.data
  });

  late final String message;
  late final int status;
  late final JudgeDataModel data;

  JudgeResultResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    data = JudgeDataModel.fromJson(json['data']);
  }
}
