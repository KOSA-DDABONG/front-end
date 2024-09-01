import 'package:front/dto/chat/start/chat_data_start_model.dart';

EditModel editResponseJson(Map<String, dynamic> json) =>
    EditModel.fromJson(json);

class EditModel {
  EditModel({
    required this.message,
    required this.status,
    required this.data
  });

  late final String message;
  late final int status;
  late final ChatDataStartModel data;

  EditModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    data = ChatDataStartModel.fromJson(json['data']);
  }
}
