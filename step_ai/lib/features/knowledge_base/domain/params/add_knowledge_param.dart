class AddKnowledgeParam {
  String knowledgeName;
  String? description;
  AddKnowledgeParam({
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
