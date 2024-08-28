class JudgeDataModel {
  JudgeDataModel({
    required this.chatbotMessage,
    required this.travelSchedule,
  });

  late final String chatbotMessage;
  late final String travelSchedule;

  JudgeDataModel.fromJson(Map<String, dynamic> json) {
    chatbotMessage = json['chatbotMessage'];
    travelSchedule = json['travelSchedule'];
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
      'travelSchedule': travelSchedule,
    };
  }
}