import 'dart:convert';

class ChatDataModel {
  ChatDataModel({
    required this.chatbotMessage,
    required this.travelSchedule,
  });

  late final String chatbotMessage;
  late final String travelSchedule;

  @override
  String toString() {
    return '''
      ChatDataModel {
        chatbotMessage: $chatbotMessage,
        travelSchedule: $travelSchedule,
      }''';
  }

  factory ChatDataModel.fromJson(Map<String, dynamic> json) {
    return ChatDataModel(
      chatbotMessage: json['chatbotMessage'] ?? '',
      travelSchedule: json['travelSchedule'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chatbotMessage': chatbotMessage,
      'travelSchedule': travelSchedule,
    };
  }
}

Map<String, dynamic> parseTravelSchedule(String jsonString) {
  try {
    // JSON 문자열을 Dart Map으로 변환
    final Map<String, dynamic> parsedMap = json.decode(jsonString);

    // 변환된 Map을 반환
    return parsedMap;
  } catch (e) {
    print('Failed to parse travel schedule: $e');
    return {};
  }
}

String formatTravelSchedule(Map<String, dynamic> schedule) {
  final buffer = StringBuffer();

  // 첫 번째 날의 일정만 표시
  final firstDay = schedule.keys.first;
  final activities = schedule[firstDay];

  buffer.writeln('Day $firstDay:');

  // Helper 함수: 리스트나 맵에서 이름 추출
  void extractNames(dynamic activity) {
    if (activity is List) {
      for (var item in activity) {
        if (item is List && item.isNotEmpty) {
          buffer.writeln(item[0]); // 첫 번째 항목이 장소 이름이라고 가정
        } else if (item is Map<String, dynamic> && item.containsKey('name')) {
          buffer.writeln(item['name']);
        }
      }
    } else if (activity is Map<String, dynamic> && activity.containsKey('name')) {
      buffer.writeln(activity['name']);
    }
  }

  // 특정 활동의 이름 추출
  if (activities is Map<String, dynamic>) {
    extractNames(activities['breakfast']);
    extractNames(activities['lunch']);
    extractNames(activities['dinner']);
    extractNames(activities['tourist_spots']);
    extractNames(activities['hotel']);
  }

  return buffer.toString();
}
