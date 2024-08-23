class Tour {
  Tour({
    required this.latitude,
    required this.longitude,
  });

  late final double latitude;
  late final double longitude;

  @override
  String toString() {
    return '''
      Tour {
        latitude: $latitude,
        longitude: $longitude,
      }''';
  }

  factory Tour.fromJson(Map<String, dynamic> json) {
    return Tour(
      latitude: json['latitude'] ?? '',
      longitude: json['longitude'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}