import 'package:dio/dio.dart';

class CommentRequestModel {
  CommentRequestModel({
    required this.postId,
    required this.comcontent,
  });

  late final int postId;
  late final String comcontent;

  CommentRequestModel.fromJson(Map<String, dynamic> json) {
    postId = json['postId'];
    comcontent = json['comcontent'];
  }

  //Json 형태(Raw)로 변환하는 메서드
  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['postId'] = postId;
    _data['comcontent'] = comcontent;
    return _data;
  }

  // FormData로 변환하는 메서드
  FormData toFormData() {
    final _formData = FormData.fromMap({
      'postId': postId,
      'comcontent': comcontent
    });
    return _formData;
  }
}
