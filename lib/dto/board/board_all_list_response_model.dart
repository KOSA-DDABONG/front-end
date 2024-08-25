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
    topList = (json['top3'] as List<dynamic>?)?.map((item) => Board.fromJson(item)).toList(); // top3에서 리스트 추출
    boardList = (json['recentboard'] as List<dynamic>?)?.map((item) => Board.fromJson(item)).toList(); // recentboard에서 리스트 추출
  }

  //BoardResponseModel을 JSON으로 변환
  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['message'] = message;
    _data['status'] = status;
    _data['top3'] = boardList?.map((board) => board.toJson()).toList(); // 리스트를 data1에 포함
    _data['recentboard'] = boardList?.map((board) => board.toJson()).toList(); // 리스트를 data2에 포함
    return _data;
  }
}
