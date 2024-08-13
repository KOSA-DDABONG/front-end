class Board {
  Board({
    required this.likecount,
    required this.comcontentcount,
    required this.postid,
    this.memberid,
    this.travelid,
    this.content,
    this.createdtime,
  });

  late final int likecount;
  late final int comcontentcount;
  late final int postid;
  late final int? memberid;
  late final int? travelid;
  late final String? content;
  late final DateTime? createdtime;

  @override
  String toString() {
    return '''
      Board {
        likecount: $likecount,
        comcontentcount: $comcontentcount,
        postid: $postid,
        memberid: $memberid,
        travelid: $travelid,
        content: $content,
        createdtime: $createdtime,
      }''';
  }

  // factory Board.fromJson(Map<String, dynamic> json) {
  //   return Board(
  //     likecount: json['likecount'] ?? '0',
  //     comcontentcount: json['comcontentcount'] ?? '0',
  //     postid: json['postid'] ?? '',
  //     memberid: json['memberid'] ?? '',
  //     travelid: json['travelid'] ?? '',
  //     content: json['content'] ?? '',
  //     createdtime: json['createdtime'] != null && json['createdtime'].isNotEmpty
  //         ? DateTime.parse(json['createdtime'])
  //         : null,
  //   );
  // }
  factory Board.fromJson(Map<String, dynamic> json) {
    return Board(
      likecount: json['likecount'] != null
          ? int.tryParse(json['likecount'].toString()) ?? 0
          : 0,
      comcontentcount: json['comcontentcount'] != null
          ? int.tryParse(json['comcontentcount'].toString()) ?? 0
          : 0,
      postid: json['postid'] != null
          ? int.tryParse(json['postid'].toString()) ?? 0
          : 0,
      memberid: json['memberid'] != null
          ? int.tryParse(json['memberid'].toString())
          : null,
      travelid: json['travelid'] != null
          ? int.tryParse(json['travelid'].toString())
          : null,
      content: json['content'] as String?,
      createdtime: json['createdtime'] != null && json['createdtime'].isNotEmpty
          ? DateTime.parse(json['createdtime'])
          : null,
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'likecount': likecount,
      'comcontentcount': comcontentcount,
      'postid': postid,
      'memberid': memberid,
      'travelid': travelid,
      'content': content,
      'createdtime': createdtime?.toIso8601String(),
    };
  }

  // Convert the createdAt array to a DateTime object
  static DateTime toDateTime(List<dynamic> createdAtArray) {
    return DateTime(
      createdAtArray[0],
      createdAtArray[1],
      createdAtArray[2],
      createdAtArray[3],
      createdAtArray[4],
      createdAtArray[5],
      createdAtArray[6] ~/ 1000000,
      createdAtArray[6] % 1000000 ~/ 1000, // Remaining nanoseconds to microseconds
    );
  }

  // Convert a DateTime object to the createdAt array
  static List<int> fromDateTime(DateTime createdAt) {
    return [
      createdAt.year,
      createdAt.month,
      createdAt.day,
      createdAt.hour,
      createdAt.minute,
      createdAt.second,
      createdAt.millisecond * 1000000 + createdAt.microsecond,
    ];
  }
}
