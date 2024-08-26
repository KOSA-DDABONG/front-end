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
