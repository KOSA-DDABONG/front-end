class CommentInfoModel {
  CommentInfoModel({
    required this.profileUrl,
    required this.nickName,
    required this.content,
  });

  late final String profileUrl;
  late final String nickName;
  late final String content;

  @override
  String toString() {
    return '''
      CommentInfo {
        profileUrl: $profileUrl,
        nickName: $nickName,
        content: $content,
      }''';
  }

  factory CommentInfoModel.fromJson(Map<String, dynamic> json) {
    return CommentInfoModel(
      profileUrl: json['profileUrl'] ?? '',
      nickName: json['nickName'] ?? '',
      content: json['content'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'profileUrl': profileUrl,
      'nickName': nickName,
      'content': content,
    };
  }
}
