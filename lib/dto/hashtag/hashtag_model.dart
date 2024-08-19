class Hashtag {
  Hashtag({
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

  factory Hashtag.fromJson(Map<String, dynamic> json) {
    return Hashtag(
      hashname: json['hashname'] ?? ''
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hashname': hashname
    };
  }
}
