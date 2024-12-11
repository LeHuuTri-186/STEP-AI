class KnowledgeParam {
  String knowledgeName;
  String? description;
  KnowledgeParam({
    required this.knowledgeName,
    this.description,
  });
  Map<String, dynamic> toJson() {
    return {
      'knowledgeName': knowledgeName,
      'description': description??'',
    };
  }
}
