class Comment {
  Comment({
    required this.commentid,
    required this.postid,
    required this.travelid,
    required this.memberid,
    required this.commentid2,
    required this.comcontent,
  });

  late final int commentid;
  late final int postid;
  late final int travelid;
  late final int memberid;
  late final int commentid2;
  late final String comcontent;

  @override
  String toString() {
    return '''
      Comment {
        commentid: $commentid,
        postid: $postid,
        travelid: $travelid,
        memberid: $memberid,
        commentid2: $commentid2,
        comcontent: $comcontent,
      }''';
  }

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      commentid: json['commentid'] ?? '',
      postid: json['postid'] ?? '',
      travelid: json['travelid'] ?? '',
      memberid: json['memberid'] ?? '',
      commentid2: json['commentid2'] ?? '',
      comcontent: json['comcontent'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'commentid': commentid,
      'postid': postid,
      'travelid': travelid,
      'memberid': memberid,
      'commentid2': commentid2,
      'comcontent': comcontent,
    };
  }
}
