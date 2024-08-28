import 'dart:convert';

import 'package:front/dto/chat/message/keywords_model.dart';

class TravelScheduleModel {
  TravelScheduleModel({
    required this.question,
    required this.keywords,
    required this.foods_context,
    required this.playing_context,
    required this.hotel_context,
    required this.scheduler,
    required this.explain,
    required this.second_sentence,
    required this.user_age,
    required this.user_token,
    required this.is_valid,
    required this.response,
  });

  late final String question;
  late final KeywordsModel keywords;
  late final List<dynamic>? foods_context;
  late final List<dynamic>? playing_context;
  late final List<dynamic>? hotel_context;
  late final List<dynamic>? scheduler;  // Ensure this is nullable and a list
  late final String? explain;
  late final String? second_sentence;
  late final int? user_age;
  late final int? user_token;
  late final int? is_valid;
  late final String response;

  factory TravelScheduleModel.fromJson(Map<String, dynamic> json) {
    return TravelScheduleModel(
      question: json['question'] ?? '',
      keywords: KeywordsModel.fromJson(json['keywords'] ?? {}),
      foods_context: json['foods_context'] != null
          ? List<dynamic>.from(json['foods_context'])
          : null,
      playing_context: json['playing_context'] != null
          ? List<dynamic>.from(json['playing_context'])
          : null,
      hotel_context: json['hotel_context'] != null
          ? List<dynamic>.from(json['hotel_context'])
          : null,
      scheduler: json['scheduler'] != null && json['scheduler'] != 'null'
          ? parseScheduler(json['scheduler']) // 수정된 부분
          : null,
      explain: json['explain'] as String?,
      second_sentence: json['second_sentence'] as String?,
      user_age: json['user_age'] as int?,
      user_token: json['user_token'] as int?,
      is_valid: json['is_valid'] as int?,
      response: json['response'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'keywords': keywords.toJson(),
      'foods_context': foods_context != null ? List<dynamic>.from(foods_context!) : null,
      'playing_context': playing_context != null ? List<dynamic>.from(playing_context!) : null,
      'hotel_context': hotel_context != null ? List<dynamic>.from(hotel_context!) : null,
      'scheduler': scheduler != null ? List<dynamic>.from(scheduler!) : null,
      'explain': explain,
      'second_sentence': second_sentence,
      'user_age': user_age,
      'user_token': user_token,
      'is_valid': is_valid,
      'response': response,
    };
  }

  // JSON 문자열을 파싱하여 Map으로 변환한 후 List로 반환하는 함수
  static List<dynamic> parseScheduler(dynamic schedulerJson) {
    try {
      if (schedulerJson is String) {
        final parsedJson = jsonDecode(schedulerJson) as Map<String, dynamic>;
        return parsedJson.values.toList();
      } else if (schedulerJson is List) {
        return schedulerJson;
      } else {
        throw Exception('Unsupported type for scheduler');
      }
    } catch (e) {
      throw Exception('Error parsing scheduler: $e');
    }
  }
}
