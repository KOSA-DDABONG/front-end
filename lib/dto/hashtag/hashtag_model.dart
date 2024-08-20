class HashtagModel {
  HashtagModel({
    required this.hashname,
  });

  late final String hashname;

  @override
  String toString() {
    return '''
      Hashtag {
        hashname: $hashname
      }''';
  }

  factory HashtagModel.fromJson(Map<String, dynamic> json) {
    return HashtagModel(
      hashname: json['hashname'] ?? ''
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hashname': hashname
    };
  }
}
