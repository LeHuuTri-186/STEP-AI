class PublishedMetadata {
  final String botName;
  final String botToken;
  final String redirect;

  PublishedMetadata({
    required this.botName,
    required this.botToken,
    required this.redirect,
  });

  factory PublishedMetadata.fromJson(Map<String, dynamic> json) {
    return PublishedMetadata(
      botName: json['botName'] ?? '',
      botToken: json['botToken'] ?? '',
      redirect: json['redirect'] ?? '',
    );
  }
}




class Published {
  final String id;
  final String type;
  final String? accessToken;
  final PublishedMetadata metadata;
  final String assistantId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  Published({
    required this.id,
    required this.type,
    this.accessToken,
    required this.metadata,
    required this.assistantId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory Published.fromJson(Map<String, dynamic> json) {
    return Published(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      accessToken: json['accessToken'],
      metadata: PublishedMetadata.fromJson(json['metadata'] ?? {}),
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
  final List<Published> items;

  ResponseData({required this.items});

  factory ResponseData.fromJson(List<dynamic> jsonList) {
    return ResponseData(
      items: jsonList.map((json) => Published.fromJson(json)).toList(),
    );
  }
}