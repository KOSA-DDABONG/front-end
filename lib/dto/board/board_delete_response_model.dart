BoardDeleteResponseModel boardDeleteResponseJson(Map<String, dynamic> json) =>
    BoardDeleteResponseModel.fromJson(json);

class BoardDeleteResponseModel {
  BoardDeleteResponseModel({
    required this.message,
    required this.status,
    required this.data,
  });

  late final String message;
  late final int status;
  late final String data;

  BoardDeleteResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    data =  json['data'];
  }
}
