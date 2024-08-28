class ChatDataStartModel {
  ChatDataStartModel({
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

  ChatDataStartModel.fromJson(Map<String, dynamic> json) {
    chatbotMessage = json['chatbotMessage'];
    travelSchedule = json['travelSchedule'];
  }
}