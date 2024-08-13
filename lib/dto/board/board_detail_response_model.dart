import '../comment/comment_model.dart';
import 'board_model.dart';

BoardDetailResponseModel boardDetailResponseJson(Map<String, dynamic> json) =>
    BoardDetailResponseModel.fromJson(json);

class BoardDetailResponseModel {
  BoardDetailResponseModel({
    required this.message,
    required this.status,
    required this.board,
    this.commentList
  });

  late final String message;
  late final int status;
  late final Board board;
  List<Comment>? commentList;

  BoardDetailResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    board = Board.fromJson(json['data1'][0]); // data1에서 Board 정보 추출
    commentList = (json['data2'] as List<dynamic>?)?.map((item) => Comment.fromJson(item)).toList(); // data2에서 댓글 리스트 추출
  }

  //BoardResponseModel을 JSON으로 변환
  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['message'] = message;
    _data['status'] = status;
    _data['data1'] = [board.toJson()]; // Board 정보는 data1의 리스트에 포함
    _data['data2'] = commentList?.map((comment) => comment.toJson()).toList(); // 댓글 리스트를 data2에 포함
    return _data;
  }
}
