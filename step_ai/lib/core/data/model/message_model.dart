class MessageModel {
  String conversationId;
  String message;
  int remainingUsage;
  MessageModel({
    required this.conversationId,
    required this.message,
    required this.remainingUsage,
  });
  Map<String, dynamic> toJson() {
    return {
      'conversationId': conversationId,
      'message': message,
      'remainingUsage': remainingUsage,
    };
  }
  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      conversationId: json['conversationId'],
      message: json['message'],
      remainingUsage: json['remainingUsage'],
    );
  }
}