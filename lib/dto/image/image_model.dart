class ImageModel {
  ImageModel({
    required this.postid,
    required this.imageid,
    required this.filename,
    required this.url,
    required this.imagetype,
    required this.travelid,
  });

  late final int postid;
  late final int imageid;
  late final String filename;
  late final String url;
  late final String imagetype;
  late final int travelid;

  @override
  String toString() {
    return '''
      Image {
        postid: $postid,
        imageid: $imageid,
        filename: $filename,
        url: $url,
        imagetype: $imagetype,
        travelid: $travelid,
      }''';
  }

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      postid: json['postid'] is int ? json['postid'] : int.tryParse(json['postid'] ?? '0') ?? 0,
      imageid: json['imageid'] is int ? json['imageid'] : int.tryParse(json['imageid'] ?? '0') ?? 0,
      filename: json['filename'] ?? '',
      url: json['url'] ?? '',
      imagetype: json['imagetype'] ?? '',
      travelid: json['travelid'] is int ? json['travelid'] : int.tryParse(json['travelid'] ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'postid': postid,
      'imageid': imageid,
      'filename': filename,
      'url': url,
      'imagetype': imagetype,
      'travelid': travelid,
    };
  }
}
