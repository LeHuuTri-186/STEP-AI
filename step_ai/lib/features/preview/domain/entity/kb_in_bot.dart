class KbListInBot {
  List<KbInBot> data;
  PageMetaDto meta;

  KbListInBot({
    required this.data,
    required this.meta,
  });

  factory KbListInBot.fromJson(Map<String, dynamic> json) {
    return KbListInBot(
        data: (json['data'] as List<dynamic>)
            .map((item) => KbInBot.fromJson(item))
            .toList(),
        meta: PageMetaDto.fromJson(json['meta'])
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
  String id;

  KbInBot({
    required this.createdAt,
    this.createdBy,
    required this.description,
    required this.knowledgeName,
    this.updatedAt,
    this.updatedBy,
    required this.userId,
    required this.id
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
      id: json['id'],
    );
  }
}
///PageMetaDto
class PageMetaDto {
  bool hasNext;
  double limit;
  double offset;
  double total;

  PageMetaDto({
    required this.hasNext,
    required this.limit,
    required this.offset,
    required this.total,
  });

  // Factory method to create PageMetaDto from JSON
  factory PageMetaDto.fromJson(Map<String, dynamic> json) {
    return PageMetaDto(
      hasNext: json['hasNext'] as bool,
      limit: (json['limit'] as num).toDouble(), // Convert to double
      offset: (json['offset'] as num).toDouble(), // Convert to double
      total: (json['total'] as num).toDouble(), // Convert to double
    );
  }
}