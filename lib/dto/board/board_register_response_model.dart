BoardRegisterResponseModel boardRegisterResponseJson(Map<String, dynamic> json) =>
    BoardRegisterResponseModel.fromJson(json);

class BoardRegisterResponseModel {
  BoardRegisterResponseModel({
    required this.message,
    required this.status
  });

  late final String message;
  late final int status;

  BoardRegisterResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
  }

  //BoardResponseModel을 JSON으로 변환
  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['message'] = message;
    _data['status'] = status;
    return _data;
  }
}
