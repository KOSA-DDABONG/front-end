class PostDTOModel {
  PostDTOModel({
    required this.travelId,
    required this.reviewContent,
    this.hashtags,
  });

  final int travelId;
  final String reviewContent;
  final List<String>? hashtags;

  //Json 형태(Raw)로 변환하는 메서드
  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['travelId'] = travelId;
    _data['reviewContent'] = reviewContent;
    _data['hashtags'] = hashtags?.map((hashtag) => hashtag).toList();
    return _data;
  }
}
