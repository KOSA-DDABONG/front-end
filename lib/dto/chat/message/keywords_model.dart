class KeywordsModel {
  KeywordsModel({
    required this.days,
    required this.transport,
    required this.companion,
    required this.theme,
    required this.food,
  });

  late final int? days;
  late final String? transport;
  late final String? companion;
  late final String? theme;
  late final String? food;

  factory KeywordsModel.fromJson(Map<String, dynamic> json) {
    return KeywordsModel(
      days: json['days'],
      transport: json['transport'],
      companion: json['companion'],
      theme: json['theme'],
      food: json['food'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'days': days,
      'transport': transport,
      'companion': companion,
      'theme': theme,
      'food': food,
    };
  }
}
