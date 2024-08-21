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

  // //BoardResponseModel을 JSON으로 변환
  // Map<String, dynamic> toJson() {
  //   final _data = <String, dynamic>{};
  //   _data['message'] = message;
  //   _data['status'] = status;
  //   _data['board'] = [board.toJson()]; // Board 정보는 board의 리스트에 포함
  //   _data['comment'] = commentList?.map((comment) => comment.toJson()).toList(); // 댓글 리스트를 comment에 포함
  //   _data['hash'] = hashtagList?.map((hashname) => hashname.toJson()).toList(); // 해시태그 리스트를 hash에 포함
  //   _data['image'] = imageList?.map((image) => image.toJson()).toList(); // 이미지 리스트를 image에 포함
  //   return _data;
  // }
}
