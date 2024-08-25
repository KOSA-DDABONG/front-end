class LikesModel {
  LikesModel({
    required this.memberid,
    required this.postid,
    required this.likeflag,
  });

  late final int memberid;
  late final int postid;
  late final bool likeflag;

  @override
  String toString() {
    return '''
      Likes {
        memberid: $memberid,
        postid: $postid,
        likeflag: $likeflag
      }''';
  }

  factory LikesModel.fromJson(Map<String, dynamic> json) {
    return LikesModel(
        memberid: json['memberid'] ?? '',
        postid: json['postid'] ?? '',
        likeflag: json['likeflag'] ?? ''
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'memberid': memberid,
      'postid': postid,
      'likeflag': likeflag,
    };
  }
}
