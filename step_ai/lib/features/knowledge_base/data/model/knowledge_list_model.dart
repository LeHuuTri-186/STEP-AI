import 'package:step_ai/features/knowledge_base/data/model/knowledge_model.dart';

class KnowledgeListModel {
  List<KnowledgeModel> knowledgeListModel;
  Meta meta;
  KnowledgeListModel({required this.knowledgeListModel, required this.meta});
  factory KnowledgeListModel.fromJson(Map<String, dynamic> json) {
    List<KnowledgeModel> knowledgeListModel = [];
    for (var knowledge in json['data']) {
      knowledgeListModel.add(KnowledgeModel.fromJson(knowledge));
    }
    return KnowledgeListModel(
        knowledgeListModel: knowledgeListModel, meta: Meta.fromJson(json['meta']));
  }
  //knowledge model
}

class Meta {
  int limit;
  int total;
  int offset;
  bool hasNext;
  Meta(
      {required this.limit,
      required this.total,
      required this.offset,
      required this.hasNext});
  factory Meta.fromJson(Map<String, dynamic> json) {
    print("\\\\\\\\\\\\\\\\\\\\\\Meta: $json");
    return Meta(
        limit: json['limit'] ?? 0,
        total: json['total'] ?? 0,
        offset: json['offset'] ?? 0,
        hasNext: json['hasNext'] ?? false);
  }
}
