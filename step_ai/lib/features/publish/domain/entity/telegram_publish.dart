class TelegramMetadata {
  final String botName;
  final String botToken;
  final String redirect;

  TelegramMetadata({
    required this.botName,
    required this.botToken,
    required this.redirect,
  });

  factory TelegramMetadata.fromJson(Map<String, dynamic> json) {
    return TelegramMetadata(
      botName: json['botName'] ?? '',
      botToken: json['botToken'] ?? '',
      redirect: json['redirect'] ?? '',
    );
  }
}




class TelegramPublish {
  final String id;
  final String type;
  final String? accessToken;
  final TelegramMetadata metadata;
  final String assistantId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  TelegramPublish({
    required this.id,
    required this.type,
    this.accessToken,
    required this.metadata,
    required this.assistantId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory TelegramPublish.fromJson(Map<String, dynamic> json) {
    return TelegramPublish(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      accessToken: json['accessToken'],
      metadata: TelegramMetadata.fromJson(json['metadata'] ?? {}),
      assistantId: json['assistantId'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? ''),
      updatedAt: DateTime.parse(json['updatedAt'] ?? ''),
      deletedAt: json['deletedAt'] != null
          ? DateTime.parse(json['deletedAt'])
          : null,
    );
  }
}
class ResponseData {
  final List<TelegramPublish> items;

  ResponseData({required this.items});

  factory ResponseData.fromJson(List<dynamic> jsonList) {
    return ResponseData(
      items: jsonList.map((json) => TelegramPublish.fromJson(json)).toList(),
    );
  }
}