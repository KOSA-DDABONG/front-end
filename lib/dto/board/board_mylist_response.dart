import 'board_model.dart';

BoardMyListResponseModel boardMyListResponseJson(Map<String, dynamic> json) =>
    BoardMyListResponseModel.fromJson(json);

class BoardMyListResponseModel {
  BoardMyListResponseModel({
    required this.message,
    required this.status,
    this.data
  });

  late final String message;
  late final int status;
  late final List<BoardListInfo>? data;

  BoardMyListResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    if (json['data'] != null) {
      data = (json['data'] as List<dynamic>).map((item) => BoardListInfo.fromJson(item as Map<String, dynamic>)).toList();
    }
  }

  //BoardResponseModel을 JSON으로 변환
  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['message'] = message;
    _data['status'] = status;
    _data['data'] = data?.map((item) => item.toJson()).toList();
    return _data;
  }
}
