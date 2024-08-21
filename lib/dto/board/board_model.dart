import '../comment/comment_info_model.dart';
import '../hashtag/hashtag_model.dart';
import '../place/hotel_model.dart';
import '../place/restaurant_model.dart';
import '../place/tour_model.dart';

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



class BoardListInfo {
  BoardListInfo({
    required this.postId,
    required this.travelId,
    required this.url,
    required this.travelTitle,
    required this.startTime,
    required this.endTime,
    required this.dayAndNights,
    required this.dday,
  });

  late final int postId;
  late final int travelId;
  late final List<String> url;
  late final String travelTitle;
  late final String startTime;
  late final String endTime;
  late final String dayAndNights;
  late final String dday;


  @override
  String toString() {
    return '''
      BoardListInfo {
        postId: $postId,
        travelId: $travelId,
        url: $url,
        travelTitle: $travelTitle,
        startTime: $startTime,
        endTime: $endTime,
        dayAndNights: $dayAndNights,
        dday: $dday,
      }''';
  }

  factory BoardListInfo.fromJson(Map<String, dynamic> json) {
    return BoardListInfo(
      postId: json['postId'] != null
          ? int.tryParse(json['postId'].toString()) ?? 0
          : 0,
      travelId: json['travelId'] != null
          ? int.tryParse(json['travelId'].toString()) ?? 0
          : 0,
      url: json['url'] != null
          ? List<String>.from(json['url'])
          : [],
      travelTitle: json['travelTitle'] != null
          ? json['travelTitle'].toString()
          : '',
      startTime: json['startTime'] != null
          ? json['startTime'].toString()
          : '',
      endTime: json['endTime'] != null
          ? json['endTime'].toString()
          : '',
      dayAndNights: json['dayAndNights'] != null
          ? json['dayAndNights'].toString()
          : '',
      dday: json['dday'] != null
          ? json['dday'].toString()
          : '',
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'postId': postId,
      'travelId': travelId,
      'url': url,
      'travelTitle': travelTitle,
      'startTime': startTime,
      'endTime': endTime,
      'dayAndNights': dayAndNights,
      'dday': dday,
    };
  }
}




class BoardDetailInfo {
  BoardDetailInfo({
    required this.memberId,
    required this.postId,
    required this.travelId,
    required this.url,
    required this.tour,
    required this.restaurant,
    required this.hotel,
    required this.nickName,
    required this.content,
    required this.hashtags,
    required this.likeCnt,
    required this.commentCnt,
    required this.commentInfoDTOs,
  });

  late final int memberId;
  late final int postId;
  late final int travelId;
  late final List<String> url;
  late final List<Tour> tour;
  late final List<Restaurant> restaurant;
  late final List<Hotel> hotel;
  late final String nickName;
  late final String content;
  late final List<String> hashtags;
  late final int likeCnt;
  late final int commentCnt;
  late final List<CommentInfoModel>? commentInfoDTOs;

  @override
  String toString() {
    return '''
      BoardDetailInfo {
        memberId: $memberId,
        postId: $postId,
        travelId: $travelId,
        url: $url,
        tour: $tour,
        restaurant: $restaurant,
        hotel: $hotel,
        nickName: $nickName,
        content: $content,
        hashtags: $hashtags,
        likeCnt: $likeCnt,
        commentCnt: $commentCnt,
        commentInfoDTOs: $commentInfoDTOs,
      }''';
  }

  factory BoardDetailInfo.fromJson(Map<String, dynamic> json) {
    return BoardDetailInfo(
      memberId: json['memberId'] != null
          ? int.tryParse(json['memberId'].toString()) ?? 0
          : 0,
      postId: json['postId'] != null
          ? int.tryParse(json['postId'].toString()) ?? 0
          : 0,
      travelId: json['travelId'] != null
          ? int.tryParse(json['travelId'].toString()) ?? 0
          : 0,
      url: json['url'] != null
          ? List<String>.from(json['url'])
          : [],
      tour: json['tour'] != null
          ? (json['tour'] as List<dynamic>).map((item) => Tour.fromJson(item as Map<String, dynamic>)).toList()
          : [],
      restaurant: json['restaurant'] != null
          ? (json['restaurant'] as List<dynamic>).map((item) => Restaurant.fromJson(item as Map<String, dynamic>)).toList()
          : [],
      hotel: json['hotel'] != null
          ? (json['hotel'] as List<dynamic>).map((item) => Hotel.fromJson(item as Map<String, dynamic>)).toList()
          : [],
      nickName: json['nickName'] != null
          ? json['nickName'].toString()
          : '',
      content: json['content'] != null
          ? json['content'].toString()
          : '',
      hashtags: json['hashtags'] != null
          ? List<String>.from(json['hashtags'])
          : [],
      likeCnt: json['likeCnt'] != null
          ? int.tryParse(json['likeCnt'].toString()) ?? 0
          : 0,
      commentCnt: json['commentCnt'] != null
          ? int.tryParse(json['commentCnt'].toString()) ?? 0
          : 0,
      commentInfoDTOs: json['commentInfoDTOs'] != null
          ? (json['commentInfoDTOs'] as List<dynamic>).map((item) => CommentInfoModel.fromJson(item as Map<String, dynamic>)).toList()
          : [],
    );
  }

  //
  // Map<String, dynamic> toJson() {
  //   return {
  //     'memberId': memberId,
  //     'postId': postId,
  //     'travelId': travelId,
  //     'url': url,
  //     'tour': tour.map((item) => item.toJson()).toList(),
  //     'restaurant': restaurant.map((item) => item.toJson()).toList(),
  //     'hotel': hotel.map((item) => item.toJson()).toList(),
  //     'nickName': nickName,
  //     'content': content,
  //     'hashtags': hashtags.map((item) => item.toJson()).toList(),
  //     'likeCnt': likeCnt,
  //     'commentCnt': commentCnt,
  //     'commentInfoDTOs': commentInfoDTOs?.map((item) => item.toJson()).toList(),
  //   };
  // }
}