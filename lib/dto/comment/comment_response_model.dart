import 'package:front/dto/comment/comment_info_model.dart';

CommentResponseModel commentResponseJson(Map<String, dynamic> json) =>
    CommentResponseModel.fromJson(json);

class CommentResponseModel {
  CommentResponseModel({
    required this.message,
    required this.status,
    required this.commentinfo,
  });

  late final String message;
  late final int status;
  late final CommentInfoModel commentinfo;

  CommentResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    commentinfo = CommentInfoModel.fromJson(json['data']);
  }

  //CommentResponseModel을 JSON으로 변환
  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['message'] = message;
    _data['status'] = status;
    _data['data'] = [commentinfo.toJson()]; // Board 정보는 data의 리스트에 포함
    return _data;
  }
}
