import 'package:dio/dio.dart';

class CommentRequestModel {
  CommentRequestModel({
    required this.postid,
    required this.travelid,
    required this.commentid2,
    required this.memberid,
    required this.comcontent,
  });

  late final int postid;
  late final int travelid;
  late final int commentid2;
  late final int memberid;
  late final String comcontent;

  CommentRequestModel.fromJson(Map<String, dynamic> json) {
    postid = json['postid'];
    travelid = json['travelid'];
    commentid2 = json['commentid2'];
    memberid = json['memberid'];
    comcontent = json['comcontent'];
  }

  //Json 형태(Raw)로 변환하는 메서드
  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['postid'] = postid;
    _data['travelid'] = travelid;
    _data['commentid2'] = commentid2;
    _data['memberid'] = memberid;
    _data['comcontent'] = comcontent;
    return _data;
  }

  // FormData로 변환하는 메서드
  FormData toFormData() {
    final _formData = FormData.fromMap({
      'postid': postid,
      'travelid': travelid,
      'commentid2': commentid2,
      'memberid': memberid,
      'comcontent': comcontent
    });
    return _formData;
  }
}
