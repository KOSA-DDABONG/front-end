class MyTravelDetailPlaceInfoModel {
  MyTravelDetailPlaceInfoModel({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.placeType,
  });

  late final String name;
  late final double latitude;
  late final double longitude;
  late final String placeType;

  @override
  String toString() {
    return '''
      MyTravelPlaceData {
        name: $name,
        latitude: $latitude,
        longitude: $longitude,
        placeType: $placeType,
      }''';
  }

  factory MyTravelDetailPlaceInfoModel.fromJson(Map<String, dynamic> json) {
    return MyTravelDetailPlaceInfoModel(
      name: json['name'] ?? '',
      latitude: json['latitude'] ?? 0,
      longitude: json['longitude'] ?? 0,
      placeType: json['placeType'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'placeType': placeType,
    };
  }
}
