import '../comment/comment_model.dart';
import '../hashtag/hashtag_model.dart';
import '../image/image_model.dart';
import 'board_model.dart';

BoardDetailResponseModel boardDetailResponseJson(Map<String, dynamic> json) =>
    BoardDetailResponseModel.fromJson(json);

class BoardDetailResponseModel {
  BoardDetailResponseModel({
    required this.message,
    required this.status,
    required this.board,
    this.commentList,
    this.hashtagList,
    this.imageList
  });

  late final String message;
  late final int status;
  late final Board board;
  List<CommentModel>? commentList;
  List<HashtagModel>? hashtagList;
  List<ImageModel>? imageList;

  BoardDetailResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    board = Board.fromJson(json['board'][0]); // data1에서 Board 정보 추출
    commentList = (json['comment'] as List<dynamic>?)?.map((item) => CommentModel.fromJson(item)).toList(); // comment에서 댓글 리스트 추출
    hashtagList = (json['hash'] as List<dynamic>?)?.map((item) => HashtagModel.fromJson(item)).toList(); // hash에서 해시태그 리스트 추출
    imageList = (json['image'] as List<dynamic>?)?.map((item) => ImageModel.fromJson(item)).toList(); // image에서 이미지 리스트 추출
  }

  //BoardResponseModel을 JSON으로 변환
  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['message'] = message;
    _data['status'] = status;
    _data['board'] = [board.toJson()]; // Board 정보는 board의 리스트에 포함
    _data['comment'] = commentList?.map((comment) => comment.toJson()).toList(); // 댓글 리스트를 comment에 포함
    _data['hash'] = hashtagList?.map((hashname) => hashname.toJson()).toList(); // 해시태그 리스트를 hash에 포함
    _data['image'] = imageList?.map((image) => image.toJson()).toList(); // 이미지 리스트를 image에 포함
    return _data;
  }
}
