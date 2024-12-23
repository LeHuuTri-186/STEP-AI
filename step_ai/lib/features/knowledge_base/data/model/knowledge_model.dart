class KnowledgeModel {
  DateTime createdAt;
  DateTime updatedAt;
  String createdBy;
  String updatedBy;
  String userId;
  String knowledgeName;
  String description;
  String id;
  int numberUnits;
  int totalSize;
  KnowledgeModel(
      {required this.createdAt,
      required this.updatedAt,
      required this.createdBy,
      required this.updatedBy,
      required this.userId,
      required this.knowledgeName,
      required this.description,
      required this.id,
      required this.numberUnits,
      required this.totalSize});
  factory KnowledgeModel.fromJson(Map<String, dynamic> json) {
    return KnowledgeModel(
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.fromMillisecondsSinceEpoch(0),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.fromMillisecondsSinceEpoch(0),
      createdBy: json['createdBy'] ?? 'Default',
      updatedBy: json['updatedBy'] ?? 'Default',
      userId: json['userId'] ?? 'Default',
      knowledgeName: json['knowledgeName'] ?? 'Default',
      description: json['description'] ?? 'Default',
      id: json['id'] ?? 'Default',
      numberUnits: json['numUnits'] ?? 0,
      totalSize: json['totalSize'] ?? 0,
    );
  }
}
