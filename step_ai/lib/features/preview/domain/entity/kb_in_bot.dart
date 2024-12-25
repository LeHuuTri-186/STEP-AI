class KbListInBot {
  List<KbInBot> data;

  KbListInBot({
    required this.data,
  });

  factory KbListInBot.fromJson(Map<String, dynamic> json) {
    return KbListInBot(
      data: (json['data'] as List<dynamic>)
          .map((item) => KbInBot.fromJson(item))
          .toList(),
    );
  }
}


///KnowledgeResDto
class KbInBot {
  DateTime createdAt;
  String? createdBy;
  String description;
  String knowledgeName;
  DateTime? updatedAt;
  String? updatedBy;
  String userId;

  KbInBot({
    required this.createdAt,
    this.createdBy,
    required this.description,
    required this.knowledgeName,
    this.updatedAt,
    this.updatedBy,
    required this.userId,
  });
  factory KbInBot.fromJson(Map<String, dynamic> json) {
    return KbInBot(
      createdAt: DateTime.parse(json['createdAt']),
      createdBy: json['createdBy'],
      description: json['description'],
      knowledgeName: json['knowledgeName'],
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      updatedBy: json['updatedBy'],
      userId: json['userId'],
    );
  }
}