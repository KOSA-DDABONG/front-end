import 'board_model.dart';

BoardListResponseModel boardListResponseJson(Map<String, dynamic> json) =>
    BoardListResponseModel.fromJson(json);

class BoardListResponseModel {
  BoardListResponseModel({
    required this.message,
    required this.status,
    this.topList,
    this.boardList
  });

  late final String message;
  late final int status;
  List<Board>? topList;
  List<Board>? boardList;

  BoardListResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    topList = (json['data1'] as List<dynamic>?)?.map((item) => Board.fromJson(item)).toList(); // data2에서 리스트 추출
    boardList = (json['data2'] as List<dynamic>?)?.map((item) => Board.fromJson(item)).toList(); // data2에서 리스트 추출
  }

  //BoardResponseModel을 JSON으로 변환
  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['message'] = message;
    _data['status'] = status;
    _data['data2'] = boardList?.map((board) => board.toJson()).toList(); // 리스트를 data1에 포함
    _data['data2'] = boardList?.map((board) => board.toJson()).toList(); // 리스트를 data2에 포함
    return _data;
  }
}
