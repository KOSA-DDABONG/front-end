import 'my_travel_detail_place_info_model.dart';

class MyTravelDetailDataModel {
  MyTravelDetailDataModel({
    required this.memberId,
    required this.travelId,
    required this.dayNum,
    required this.place,
  });

  late final int memberId;
  late final int travelId;
  late final int dayNum;
  late final List<MyTravelDetailPlaceInfoModel> place;

  @override
  String toString() {
    return '''
      MyTravelDetailData {
        memberId: $memberId,
        travelId: $travelId,
        dayNum: $dayNum,
        place: $place,
      }''';
  }

  factory MyTravelDetailDataModel.fromJson(Map<String, dynamic> json) {
    return MyTravelDetailDataModel(
      memberId: json['memberId'] ?? 0,
      travelId: json['travelId'] ?? 0,
      dayNum: json['dayNum'] ?? 0,
      place: (json['place'] as List)
          .map((item) => MyTravelDetailPlaceInfoModel.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'memberId': memberId,
      'travelId': travelId,
      'dayNum': dayNum,
      'place': place.map((item) => item.toJson()).toList(),
    };
  }
}
