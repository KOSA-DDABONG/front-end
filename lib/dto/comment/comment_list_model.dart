class CommentListModel {
  CommentListModel({
    required this.postid,
    required this.travelid,
    required this.memberid,
    required this.commentid2,
    required this.comcontent,
  });

  late final int postid;
  late final int travelid;
  late final int memberid;
  late final int commentid2;
  late final String comcontent;

  @override
  String toString() {
    return '''
      CommentList {
        postid: $postid,
        travelid: $travelid,
        memberid: $memberid,
        commentid2: $commentid2,
        comcontent: $comcontent,
      }''';
  }

  factory CommentListModel.fromJson(Map<String, dynamic> json) {
    return CommentListModel(
      postid: json['postid'] ?? '',
      travelid: json['travelid'] ?? '',
      memberid: json['memberid'] ?? '',
      commentid2: json['commentid2'] ?? '',
      comcontent: json['comcontent'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'postid': postid,
      'travelid': travelid,
      'memberid': memberid,
      'commentid2': commentid2,
      'comcontent': comcontent,
    };
  }
}
