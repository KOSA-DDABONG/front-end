class MyTravelListDataModel {
  MyTravelListDataModel({
    required this.travelId,
    required this.startTime,
    required this.endTime,
    required this.dayAndNights,
    required this.isWrite,
    required this.dday,
  });

  late final int travelId;
  late final String startTime;
  late final String endTime;
  late final String dayAndNights;
  late final bool isWrite;
  late final String dday;

  @override
  String toString() {
    return '''
      MyTravel {
        travelId: $travelId,
        startTime: $startTime,
        endTime: $endTime,
        dayAndNights: $dayAndNights,
        isWrite: $isWrite,
        dday: $dday,
      }''';
  }

  factory MyTravelListDataModel.fromJson(Map<String, dynamic> json) {
    return MyTravelListDataModel(
      travelId: json['travelId'] ?? 0,
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      dayAndNights: json['dayAndNights'] ?? '',
      isWrite: json['isWrite'] ?? true,
      dday: json['dday'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'travelId': travelId,
      'startTime': startTime,
      'endTime': endTime,
      'dayAndNights': dayAndNights,
      'isWrite': isWrite,
      'dday': dday,
    };
  }
}
