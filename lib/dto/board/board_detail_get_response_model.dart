import 'board_model.dart';

BoardDetailGetResponseModel boardDetailGetResponseJson(Map<String, dynamic> json) =>
    BoardDetailGetResponseModel.fromJson(json);

class BoardDetailGetResponseModel {
  BoardDetailGetResponseModel({
    required this.message,
    required this.status,
    required this.data,
  });

  late final String message;
  late final int status;
  late final BoardDetailInfo data;

  BoardDetailGetResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    data = BoardDetailInfo.fromJson(json['data']); // data에서 BoardDetailInfo 정보 추출
  }
}
