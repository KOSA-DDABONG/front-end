import '../comment/comment_info_model.dart';
import '../place/hotel_model.dart';
import '../place/restaurant_model.dart';
import '../place/tour_model.dart';

class AllBoardList {
  AllBoardList({
    required this.likecount,
    required this.likeflag,
    required this.comcontentcount,
    required this.postid,
    required this.createtime,
    this.imgurl
  });

  late final int likecount;
  late final bool likeflag;
  late final int comcontentcount;
  late final int postid;
  late final DateTime? createtime;
  late final String? imgurl;

  @override
  String toString() {
    return '''
      Board {
        likecount: $likecount,
        likeflag: $likeflag,
        comcontentcount: $comcontentcount,
        postid: $postid,
        createtime: $createtime,
        imgurl: $imgurl,
      }''';
  }

  factory AllBoardList.fromJson(Map<String, dynamic> json) {
    return AllBoardList(
      likecount: json['likecount'] != null
          ? int.tryParse(json['likecount'].toString()) ?? 0
          : 0,
      likeflag: json['likeflag'] != null
          ? json['likeflag'] as bool // JSON 데이터에서 bool로 변환
          : false, // 기본값을 false로 설정
      comcontentcount: json['comcontentcount'] != null
          ? int.tryParse(json['comcontentcount'].toString()) ?? 0
          : 0,
      postid: json['postid'] != null
          ? int.tryParse(json['postid'].toString()) ?? 0
          : 0,
      createtime: json['createtime'] != null && json['createtime'].isNotEmpty
          ? DateTime.parse(json['createtime'])
          : null,
      imgurl: json['imgurl'] as String?,
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'likecount': likecount,
      'likeflag': likeflag,
      'comcontentcount': comcontentcount,
      'postid': postid,
      'createtime': createtime?.toIso8601String(),
      'imgurl': imgurl
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



class MyBoardListInfo {
  MyBoardListInfo({
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

  factory MyBoardListInfo.fromJson(Map<String, dynamic> json) {
    return MyBoardListInfo(
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
    required this.isLike,
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
  late final bool isLike;
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
        isLike: $isLike,
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
      isLike: json['isLike'] != null
          ? json['isLike'] as bool // JSON 데이터에서 bool로 변환
          : false, // 기본값을 false로 설정
      commentInfoDTOs: json['commentInfoDTOs'] != null
          ? (json['commentInfoDTOs'] as List<dynamic>).map((item) => CommentInfoModel.fromJson(item as Map<String, dynamic>)).toList()
          : [],
    );
  }
}