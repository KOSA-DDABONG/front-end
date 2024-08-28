import 'dart:convert';
import 'package:front/dto/chat/message/travel_schedule_model.dart';

class ChatDataModel {
  ChatDataModel({
    required this.chatbotMessage,
    required this.travelSchedule,
  });

  late final String chatbotMessage;
  late final TravelScheduleModel travelSchedule;

  factory ChatDataModel.fromJson(Map<String, dynamic> json) {
    final travelScheduleData = json['travelSchedule'];
    Map<String, dynamic> travelScheduleMap;

    if (travelScheduleData is String) {
      travelScheduleMap = jsonDecode(travelScheduleData);
    } else if (travelScheduleData is Map<String, dynamic>) {
      travelScheduleMap = travelScheduleData;
    } else {
      throw TypeError(); // Handle unexpected data type
    }

    return ChatDataModel(
      chatbotMessage: json['chatbotMessage'] ?? '',
      travelSchedule: TravelScheduleModel.fromJson(travelScheduleMap),
    );
  }

  @override
  String toString() {
    return '''
      ChatDataModel {
        chatbotMessage: $chatbotMessage,
        travelSchedule: $travelSchedule,
      }''';
  }

  Map<String, dynamic> toJson() {
    return {
      'chatbotMessage': chatbotMessage,
      'travelSchedule': travelSchedule.toJson(),
    };
  }
}